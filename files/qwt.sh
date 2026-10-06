#!/usr/bin/env bash
# qwt — per-worktree local environment for the qarma monorepo.
#
# Each worktree gets a slot N: its own Postgres container qarma-db-<worktree> on port 5432+N, the backend on HTTP
# port 4000+N and an Erlang node qarma-<worktree> with cookie jeppecookie-<worktree>. The values live in
# <worktree>/.envrc (git-ignored), loaded by direnv. A worktree can instead share another worktree's setup (same DB,
# ports, node and cookie); only one of them can run its backend at a time, the second fails with eaddrinuse.
# Nodes use long names (<node>@127.0.0.1) because Livebook can only attach to long-name nodes.
#
#   qwt init [--slot N] [--rebind]   write .envrc for the current worktree, start its DB container, direnv allow
#   qwt init --share WORKTREE        use WORKTREE's setup instead of an own one
#   qwt show [PATH]                  print the environment of the worktree containing PATH (default: cwd) + status
#   qwt list                         all worktrees with their slot, ports and what is running
#   qwt start                        start the backend of the current worktree (iex -S mix phx.server, PORT=QARMA_HTTP_PORT)
#   qwt psql [psql args...]          psql against the current worktree's Postgres
#   qwt cd                           pick backend or a backend-libs project of the current worktree (fzf); the fish
#                                    qwt function cds there, the bare command prints the path. At the bare repo root
#                                    it picks the worktree first.
set -euo pipefail

IMAGE=postgis/postgis:14-3.2-alpine
NODE_HOST=127.0.0.1

die() { echo "qwt: $*" >&2; exit 1; }

worktree_root() {
  git -C "${1:-$PWD}" rev-parse --show-toplevel 2>/dev/null || die "not inside a git worktree: ${1:-$PWD}"
}

# Prints KEY=VALUE lines for the QARMA_* and DB variables of the .envrc in the given worktree root.
read_env() {
  local root=$1
  [[ -f $root/.envrc ]] || return 1
  (
    set +u
    # shellcheck disable=SC1091
    source "$root/.envrc" >/dev/null 2>&1
    for v in QARMA_WORKTREE QARMA_SHARED_FROM QARMA_SLOT QARMA_SNAME QARMA_COOKIE QARMA_DB_CONTAINER QARMA_HTTP_PORT DB_PORT PGHOST PGPORT PGUSER; do
      echo "$v=${!v-}"
    done
  )
}

env_value() { read_env "$1" | sed -n "s/^$2=//p"; }

all_worktrees() { git worktree list --porcelain | sed -n 's/^worktree //p' | while read -r w; do [[ -d $w/.git || -f $w/.git ]] && echo "$w"; done; }

# The worktree whose setup (DB, ports, node) the given worktree root uses: itself unless it shares another one's.
setup_owner() {
  local shared; shared=$(env_value "$1" QARMA_SHARED_FROM 2>/dev/null || true)
  echo "${shared:-$(basename "$1")}"
}

find_worktree() {
  local w
  for w in $(all_worktrees); do
    if [[ $(basename "$w") == "$1" || $w == "$(realpath -m "$1")" ]]; then echo "$w"; return; fi
  done
  die "no worktree named $1 (see qwt list)"
}

used_slots() { for w in $(all_worktrees); do env_value "$w" QARMA_SLOT 2>/dev/null || true; done; }

next_free_slot() {
  local used; used=" $(used_slots | tr '\n' ' ') "
  local n=0
  while [[ $used == *" $n "* ]]; do n=$((n + 1)); done
  echo "$n"
}

container_host_port() {
  docker inspect "$1" --format '{{with index .HostConfig.PortBindings "5432/tcp"}}{{(index . 0).HostPort}}{{end}}' 2>/dev/null || true
}

# docker inspect prints an empty line even for a missing container, so decide on its exit status, not its output
container_state() {
  local state
  if state=$(docker inspect "$1" --format '{{.State.Status}}' 2>/dev/null); then echo "$state"; else echo missing; fi
}

container_volume() {
  docker inspect "$1" --format '{{range .Mounts}}{{if eq .Destination "/var/lib/postgresql/data"}}{{.Name}}{{end}}{{end}}'
}

ensure_container() {
  local name=$1 port=$2 rebind=$3
  local state; state=$(container_state "$name")
  if [[ $state == missing ]]; then
    echo "creating container $name on port $port"
    docker run -d -p "$port:5432" --name "$name" -e POSTGRES_PASSWORD=postgres "$IMAGE" -N 1000 >/dev/null
    return
  fi
  local bound; bound=$(container_host_port "$name")
  if [[ $bound != "$port" ]]; then
    [[ $rebind == 1 ]] || die "container $name exists but is bound to port ${bound:-none}, not $port. Re-run with --rebind to recreate it on $port keeping its data volume."
    local volume; volume=$(container_volume "$name")
    [[ -n $volume ]] || die "could not find the data volume of $name; not recreating it"
    echo "recreating $name on port $port, keeping volume $volume"
    docker stop "$name" >/dev/null 2>&1 || true
    docker rm "$name" >/dev/null
    docker run -d -p "$port:5432" --name "$name" -e POSTGRES_PASSWORD=postgres -v "$volume:/var/lib/postgresql/data" "$IMAGE" -N 1000 >/dev/null
    return
  fi
  if [[ $state != running ]]; then
    echo "starting container $name"
    docker start "$name" >/dev/null
  fi
}

cmd_init() {
  local slot="" rebind=0 share=""
  while [[ $# -gt 0 ]]; do
    case $1 in
      --slot) slot=$2; shift 2 ;;
      --rebind) rebind=1; shift ;;
      --share) share=$2; shift 2 ;;
      *) die "unknown option $1" ;;
    esac
  done
  if [[ -n $share && ( -n $slot || $rebind == 1 ) ]]; then die "--share cannot be combined with --slot or --rebind"; fi
  local root name; root=$(worktree_root); name=$(basename "$root")
  # re-running a plain init keeps an existing share; --slot turns it back into an own setup
  if [[ -z $share && -z $slot ]]; then share=$(env_value "$root" QARMA_SHARED_FROM 2>/dev/null || true); fi

  if [[ -n $share ]]; then
    init_shared "$root" "$name" "$share"
  else
    init_own "$root" "$name" "$slot" "$rebind"
  fi
  if command -v direnv >/dev/null; then direnv allow "$root"; fi
}

init_own() {
  local root=$1 name=$2 slot=$3 rebind=$4
  if [[ -z $slot ]]; then slot=$(env_value "$root" QARMA_SLOT 2>/dev/null || true); fi
  [[ -n $slot ]] || slot=$(next_free_slot)
  [[ $slot =~ ^[0-9]+$ ]] || die "slot must be a number: $slot"
  local w
  for w in $(all_worktrees); do
    [[ $w == "$root" ]] && continue
    if [[ $(env_value "$w" QARMA_SLOT 2>/dev/null || true) == "$slot" && $(setup_owner "$w") != "$name" ]]; then
      die "slot $slot is already used by $w"
    fi
  done

  local db_port=$((5432 + slot)) http_port=$((4000 + slot))
  write_envrc "$root" "$name" "" "$slot" "qarma-$name" "jeppecookie-$name" "qarma-db-$name" "$http_port" "$db_port"
  ensure_container "qarma-db-$name" "$db_port" "$rebind"

  echo
  echo "first time for this DB? run:"
  echo "  cd $(realpath --relative-to="$PWD" "$root/backend") && mix ecto.create && mix ecto.migrate && mix run priv/repo/seeds.exs && mix run priv/repo/locales.exs"
  echo "start the backend with:  qwt start"
}

init_shared() {
  local root=$1 name=$2 share=$3
  local owner_root; owner_root=$(find_worktree "$share")
  [[ $owner_root != "$root" ]] || die "a worktree cannot share its own setup"
  [[ -f $owner_root/.envrc ]] || die "$share has no setup yet - run 'qwt init' there first"
  # sharing a worktree that itself shares means sharing its owner
  local owner; owner=$(setup_owner "$owner_root")
  [[ $owner != "$name" ]] || die "$share already shares this worktree's setup"
  owner_root=$(find_worktree "$owner")

  local k v; local -A e
  while IFS='=' read -r k v; do e[$k]=$v; done < <(read_env "$owner_root")
  write_envrc "$root" "$name" "$owner" "${e[QARMA_SLOT]}" "${e[QARMA_SNAME]}" "${e[QARMA_COOKIE]}" \
    "${e[QARMA_DB_CONTAINER]}" "${e[QARMA_HTTP_PORT]}" "${e[DB_PORT]}"
  ensure_container "${e[QARMA_DB_CONTAINER]}" "${e[DB_PORT]}" 0

  echo
  echo "sharing $owner's DB, ports and node; stop $owner's backend before 'qwt start' here"
}

write_envrc() {
  local root=$1 name=$2 shared_from=$3 slot=$4 sname=$5 cookie=$6 container=$7 http_port=$8 db_port=$9
  cat > "$root/.envrc" <<EOF
# Generated by qwt (~/.config/home-manager/files/qwt.sh). Local to this worktree, git-ignored.
export QARMA_WORKTREE=$name
export QARMA_SHARED_FROM=$shared_from
export QARMA_SLOT=$slot
export QARMA_SNAME=$sname
export QARMA_COOKIE=$cookie
export QARMA_DB_CONTAINER=$container

# not PORT: that would leak into the frontend and override its .env; qwt start sets PORT for the backend
export QARMA_HTTP_PORT=$http_port

export DB_PORT=$db_port
export JOB_HAVEN_DB_PORT=$db_port
export FEATURES_DB_PORT=$db_port
export SIDE_LOADED_DB_PORT=$db_port
export SHREK_DASHBOARDS_DB_PORT=$db_port

# plain psql in this worktree hits its own Postgres
export PGHOST=localhost
export PGPORT=$db_port
export PGUSER=postgres
export PGPASSWORD=postgres
EOF
  echo "wrote $root/.envrc (slot $slot: http $http_port, db $db_port, node $sname${shared_from:+, shared from $shared_from})"
}

# Which worktree the backend node was started from (its beam process' working directory).
running_worktree() {
  local pid; pid=$(pgrep -f -- "beam.*-s?name $1(@| |$)" | head -1)
  [[ -n $pid ]] || { echo "?"; return; }
  basename "$(git -C "$(readlink "/proc/$pid/cwd")" rev-parse --show-toplevel 2>/dev/null || echo "?")"
}

print_status() {
  local root=$1
  local sname port db_port container
  sname=$(env_value "$root" QARMA_SNAME); port=$(env_value "$root" QARMA_HTTP_PORT)
  db_port=$(env_value "$root" DB_PORT); container=$(env_value "$root" QARMA_DB_CONTAINER)
  local db node http
  db=$(container_state "$container")
  if epmd -names 2>/dev/null | grep -q "^name $sname at"; then
    node="up, running $(running_worktree "$sname")"
  else
    node=down
  fi
  if ss -ltn 2>/dev/null | grep -q ":$port\b"; then http=listening; else http=closed; fi
  echo "db_container=$container ($db, port $db_port)  node=$sname@$NODE_HOST ($node)  http=http://localhost:$port/q ($http)"
}

cmd_show() {
  local root; root=$(worktree_root "${1:-$PWD}")
  if ! read_env "$root"; then
    echo "QARMA_WORKTREE=$(basename "$root")"
    echo "no .envrc in $root — run 'qwt init' there. Until then mix falls back to the config defaults (HTTP 4000, Postgres 5432)."
    return 0
  fi
  print_status "$root"
}

cmd_list() {
  for w in $(all_worktrees); do
    local slot; slot=$(env_value "$w" QARMA_SLOT 2>/dev/null || true)
    if [[ -z $slot ]]; then
      printf '%-24s  (no .envrc)\n' "$(basename "$w")"
    else
      local shared; shared=$(env_value "$w" QARMA_SHARED_FROM)
      printf '%-24s  slot %-2s %-22s ' "$(basename "$w")" "$slot" "${shared:+(shares $shared)}"
      print_status "$w"
    fi
  done
}

initialised_root() {
  local root; root=$(worktree_root)
  [[ -f $root/.envrc ]] || die "no .envrc in $root — run 'qwt init' first"
  echo "$root"
}

cmd_start() {
  local root; root=$(initialised_root)
  source "$root/.envrc"
  cd "$root/backend"
  PORT=$QARMA_HTTP_PORT LOG_LEVEL=${LOG_LEVEL:-debug} exec iex --name "$QARMA_SNAME@$NODE_HOST" --cookie "$QARMA_COOKIE" -S mix phx.server
}

cmd_psql() {
  local root; root=$(initialised_root)
  source "$root/.envrc"
  exec psql "$@"
}

pick() { fzf --with-nth -1 -d / || true; }

cmd_cd() {
  local root
  if ! root=$(git rev-parse --show-toplevel 2>/dev/null); then
    git rev-parse --git-common-dir >/dev/null 2>&1 || die "not inside a git repo or worktree"
    local w trees=()
    for w in $(all_worktrees); do [[ -d $w/backend-libs ]] && trees+=("$w"); done
    [[ ${#trees[@]} -gt 0 ]] || die "no worktree contains backend-libs"
    root=$(printf '%s\n' "${trees[@]}" | pick)
    [[ -n $root ]] || return 0
  fi
  local d dirs=()
  for d in "$root"/backend-libs/*/ "$root"/backend/; do [[ -d $d ]] && dirs+=("${d%/}"); done
  [[ ${#dirs[@]} -gt 0 ]] || die "no backend or backend-libs in $root"
  printf '%s\n' "${dirs[@]}" | pick
}

case ${1:-} in
  init) shift; cmd_init "$@" ;;
  show) shift; cmd_show "$@" ;;
  list) shift; cmd_list ;;
  start) shift; cmd_start ;;
  psql) shift; cmd_psql "$@" ;;
  cd) shift; cmd_cd ;;
  *) sed -n '/^# qwt/,/^[^#]/{/^#/p}' "$0" | sed 's/^# \{0,1\}//'; exit 1 ;;
esac

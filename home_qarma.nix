{ inputs, pkgs, secrets, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  home.username = "jeppe";
  home.homeDirectory = "/home/jeppe";
  home.packages = with pkgs; [
    # CMD UTILS
    wl-clipboard
    awscli2
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.nix-index-database.homeModules.default
    ./configs/options.nix
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/yazi.nix
    ./configs/neovim
    ./configs/kitty.nix
    ./configs/vscode.nix
    ./configs/zellij.nix
    ./configs/posting.nix
  ];

  programs.nix-index-database.comma.enable = true;

  programs.fish.interactiveShellInit = ''
    source ~/.asdf/asdf.fish

    function jbo --description "Open Jenkins Blue Ocean activity for the current git branch"
      set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
      if [ -z "$branch" ]
        echo "jbo: not in a git repository" >&2
        return 1
      end
      set -l enc (string replace -a / %2F $branch)
      xdg-open "https://jenkins.aws.qarma.one/blue/organizations/jenkins/qarmainspect/activity?branch=$enc"
    end
  '';

  programs.neovim.initLua = /* lua */ ''
    vim.api.nvim_create_user_command("Jbo", function()
      local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
      if vim.v.shell_error ~= 0 or not branch or branch == "" then
        vim.notify("jbo: not in a git repository", vim.log.levels.ERROR)
        return
      end
      local enc = branch:gsub("/", "%%2F")
      vim.ui.open("https://jenkins.aws.qarma.one/blue/organizations/jenkins/qarmainspect/activity?branch=" .. enc)
    end, { desc = "Open Jenkins Blue Ocean activity for the current git branch" })

    -- user commands must be uppercase; let :jbo expand to :Jbo
    vim.cmd([[cnoreabbrev <expr> jbo (getcmdtype() == ':' && getcmdline() == 'jbo') ? 'Jbo' : 'jbo']])
  '';

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Jeppe Allerslev";
        email = secrets.work_email;
      };
    };
  };

  # https://tinted-theming.github.io/tinted-gallery/
  colorScheme = inputs.nix-colors.colorSchemes.ayu-mirage;

  fonts.fontconfig.enable = true;

  custom.elixirLsCmd = "/home/jeppe/elixir-ls/language_server.sh";

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}

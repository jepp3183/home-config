{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "harper";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "Automattic";
    repo = "harper";
    rev = "82665b0ea8fcae4dfeebe42e4cb8873fa0c286e3";
    hash = "sha256-nH1DyWGJMYiisdS4YRw+kUIJLX4twB9ZJ7OWH+QLlIA=";
  };

  buildAndTestSubdir = "harper-ls";
  useFetchCargoVendor = true;
  cargoHash = "sha256-C5+5cxsnyM6cZ724C2czuoCfmIE0nQJXCwYCjfW7sgE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Grammar Checker for Developers";
    homepage = "https://github.com/Automattic/harper";
    changelog = "https://github.com/Automattic/harper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pbsds
      sumnerevans
    ];
    mainProgram = "harper-ls";
  };
}

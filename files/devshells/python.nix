{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [ 
              (python3.withPackages(ps: with ps; [
                ipython
                ipykernel
                jupyter
                notebook
                tqdm
              ]))
            ];

            shellHook = ''
              exec fish
              echo "Python Development Shell"
            '';
          };
        }
      );
}

{
  description = "Home Manager configuration of jeppe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ];
      };

      # Helper function to create home manager configurations
      mkHome =
        {
          modules,
          includeSystem ? true,
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
          }
          // (if includeSystem then { inherit system; } else { });
          inherit modules;
        };
    in
    {
      homeConfigurations = {
        "jeppe@nixos-envy" = mkHome {
          modules = [ ./home_envy.nix ];
        };

        "jeppe@nixos-desktop" = mkHome {
          modules = [ ./home_desktop.nix ];
        };

        "jeppe-wsl" = mkHome {
          modules = [ ./home_wsl.nix ];
          includeSystem = false;
        };

        "jeppe@jeppe-qarma-ThinkPad" = mkHome {
          modules = [ ./home_qarma.nix ];
          includeSystem = false;
        };
      };
    };
}

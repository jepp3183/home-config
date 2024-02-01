Uses flakes!

- First, install [Nix](https://nixos.org/download)
- Enable experimental features flakes and nix-command:
  
  `mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`
- Then run the command `nix run home-manager/master -- init` to install home-manager
- Clone this repo into .config/home-manager
- `home-manager switch` 

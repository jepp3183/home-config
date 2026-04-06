Uses flakes!

- First, install [Nix](https://nixos.org/download)
- Enable experimental features flakes and nix-command:
  
  `mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`
- Then run the command `nix run home-manager/master -- init --switch` to install home-manager
- maybe remove default home config: `rm -r ~/.config/home-manager`
- Clone this repo into .config/home-manager
- Unlock secrets with git-crypt using the symmetric key stored in 1Password:
  ```bash
  # Export the key from 1Password, then:
  git-crypt unlock /path/to/git-crypt-key
  ```
- `home-manager switch`

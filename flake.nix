{
  description = "My custom NixOS configuration for Orange Pi 5";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    # Add other inputs as required
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.andy = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ({ pkgs, lib, ... }: {
          # User and Home Manager customization module
          users.users.andy = {
            isNormalUser = true;
            initialPassword = "andy";
            extraGroups = [ "wheel" "networkmanager" "tty" "video" ];
            packages = with pkgs; [
              home-manager
              neofetch
              pavucontrol
              direnv
              dunst
              firefox
              chromium
              qemu
            ];
          };

          # Direct Home Manager configuration
          home-manager.users.andy = { pkgs, lib, ... }: {
            programs.bash.enable = true;
            # Add more Home Manager configurations as needed
          };
        })
      ];
    };
  };
}

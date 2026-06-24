{
  description = "NixOS Flake";

  inputs = {
    # NixOS repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Pinned repo for BlueZ 5.85
    nixpkgs-bluez-pinned.url = "github:nixos/nixpkgs/e8bc37ff392557ca7cb006f8902096316713919e";

    # Hyprland repo
    hyprland.url = "github:hyprwm/Hyprland";

    # Home manager repo
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      nixos-fruit = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                bluez = inputs.nixpkgs-bluez-pinned.legacyPackages.${prev.stdenv.hostPlatform.system}.bluez;
              })
            ];
          }

          ./nixos/configuration.nix
          ./modules/nvidia.nix
          ./modules/bluetooth.nix
          ./modules/keyboard.nix
          ./modules/controller.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.coconut = import ./home-manager/home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
  };
}

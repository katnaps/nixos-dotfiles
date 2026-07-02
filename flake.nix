{
  description = "NixOS Flake";

  inputs = {
    # NixOS repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Hyprland repo
    hyprland.url = "github:hyprwm/Hyprland";

    # Home Manager repo
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Flatpak repo
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-flatpak,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nixos-fruit = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [

            ./nixos/configuration.nix
            ./modules/nvidia.nix
            ./modules/bluetooth.nix
            ./modules/keyboard.nix
            ./modules/controller.nix

            {
              nixpkgs.overlays = [
                (import ./overlays/bluez.nix)
                (import ./overlays/unstable.nix inputs)
              ];
            }

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

            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
      };
    };
}

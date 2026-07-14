{
  description = "NixOS Flake";

  inputs = {
    # NixOS repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Hyprland repo
    hyprland.url = "github:hyprwm/Hyprland";

    # Home Manager repo
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
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
                (import ./overlays/stable.nix inputs)
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
          ];
        };
      };
    };
}

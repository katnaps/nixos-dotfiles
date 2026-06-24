{
  description = "NixOS Flake";

  inputs = {
    # NixOS repo
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Hyprland repo
    hyprland.url = "github:hyprwm/Hyprland";

    # Home manager repo
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 

    let
      bluezOverlays = import ./overlays { inherit inputs; };
    in

  {
    nixosConfigurations = {
      nixos-fruit = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [

          { nixpkgs.overlays = [ bluezOverlays.additions]; }

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

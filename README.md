# Instllation
## Requirements
 - copy the hardware-configuration.nix from `/etc/nixos/hardware-configuration.nix` to `nixos-dotfiles/nixos/` directory.

You will need create the flake.lock from flake.nix
Run the following command
```
# nix flake update
```
To install from this flake<br/>
run the following command
```
# sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-fruit
```

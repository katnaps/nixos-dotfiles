# Instllation
## Requirements
 - Copy the hardware-configuration.nix from `/etc/nixos/hardware-configuration.nix` to `nixos-dotfiles/nixos/` directory.

Copy hardware-configuration.nix by running this command
```
# cp -v /etc/nixos/hardware-configuration.nix ~/nixos-dotfiles/nixos/
```

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

# Instllation

### Packages include:
 - stremio-linux-shell installed through flatpak

## Requirements
 - Copy the `hardware-configuration.nix` from `/etc/nixos/hardware-configuration.nix` to `nixos-dotfiles/nixos/` directory.

## Git Clone 
### SSH clone
```
# git clone git@github.com:katnaps/nixos-dotfiles.git
```
### HTTPS clone
```
# git clone https://github.com/katnaps/nixos-dotfiles.git
```
### Copying hardware-configuration.nix
Copy `hardware-configuration.nix` by running this command
```
# cp -v /etc/nixos/hardware-configuration.nix ~/nixos-dotfiles/nixos/
```
### Creating flake.lock
You will need create the flake.lock from flake.nix
Run the following command
```
# nix flake update
```
### Installing with flake
To install from this flake<br/>
run the following command
```
# sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-fruit
```

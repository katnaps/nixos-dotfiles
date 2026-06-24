{ inputs, ... }:
{
  # This imports the bluez file and grabs its 'additions' attribute
  additions = import ./bluez.nix { inherit inputs; };
}

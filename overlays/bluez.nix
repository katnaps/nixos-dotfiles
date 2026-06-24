{ inputs, ... }:
{
  # This gathers your bluez overlay and any future overlays into a clean list
  final: prev: {
    bluez = prev.bluez.overrideAttrs (oldAttrs: rec {
      version = "5.85";
      src = prev.fetchurl {
        url = "mirror://kernel/linux/bluetooth/bluez-${version}.tar.xz";
        sha256 = "0zg1dv9mz1y6frpp7p12frwgnc0hlrkfbdy397vg6jaa8f3cmhry"; 
      };
    });
    
    # You can add more package overrides right here later
  };
}

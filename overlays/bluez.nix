final: prev: {
  bluez = prev.bluez.overrideAttrs (old: rec {
    version = "5.85";

    src = prev.fetchurl {
      urls = [
        "mirror://kernel/linux/bluetooth/bluez-${version}.tar.xz"
        "https://www.kernel.org/pub/linux/bluetooth/bluez-${version}.tar.xz"
      ];
      hash = "sha256-PsPKhkNKSfP2ScO35WamEDD7eHYi3HNvdsaHX9Nu4X0=";
    };

    # Keeping it lightweight and fast by removing autoreconfHook
    # and clearing older patches cleanly
    patches = [ ];
  });
}

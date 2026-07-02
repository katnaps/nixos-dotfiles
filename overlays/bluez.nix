final: prev: {
  bluez = prev.bluez.overrideAttrs (old: {
    version = "master-unstable";

    src = prev.fetchFromGitHub {
      owner = "bluez";
      repo = "bluez";
      rev = "refs/heads/master";
      hash = "sha256-Wj52uHIFhW5DaRcBvH9S4n01id3PA3i9vorts6ZJ7qc=";
    };

    # Wipe patches that don't apply to master anymore
    patches = [ ];
  });
}

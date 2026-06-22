{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    foot = "foot";
    waybar = "waybar";
    rofi = "rofi";
    ohmyposh = "ohmyposh";
  };
in

{
  home.username = "coconut";
  home.homeDirectory = "/home/coconut";

  home.file.".zshrc" = {
    source = create_symlink "${config.home.homeDirectory}/nixos-dotfiles/.zshrc";
  };

  home.packages = with pkgs; [
    # Wayland
    hyprpaper
    rofi
    grim
    slurp
    wl-clipboard
    brightnessctl

    # Terminal & Shell Utilities
    foot
    kitty
    oh-my-posh
    fastfetch

    # Media & Viewers
    vlc
    mpv
    swayimg
    wiremix
  ];

  programs = {
    git.enable = true;
    waybar.enable = true;
    zoxide.enable = true;
    fzf.enable = true;
    zsh.enable = false;

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  services.udiskie.enable = true;

  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.stateVersion = "26.05";
}

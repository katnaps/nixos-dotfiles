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
    waybar
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
    nvtop
    bat

    # Media & Viewers
    vlc
    mpv
    swayimg
    wiremix
  ];

  programs = {
    zsh.enable = false;
    git.enable = true;
    zoxide.enable = true;
    fd.enable = true;
    btop.enable = true;


    fzf = {
      enable = true;
      enableZshIntegration = true;
      # This tells fzf to use fd for searching files
      defaultCommand = "fd --type f --hidden --exclude .git";
      # This tells fzf to use fd when you press Ctrl+T
      fileWidgetCommand = "fd --type f --hidden --exclude .git";
    };

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

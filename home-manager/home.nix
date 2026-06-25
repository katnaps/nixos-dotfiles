{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    foot = "foot";
    waybar = "waybar";
    rofi = "rofi";
    ohmyposh = "ohmyposh";
    hypr/hyprpaper.conf = "hypr/hyprpaper.conf";
    hypr/hl.meta.lua =  "hypr/hl.meta.lua";
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
    mesa-demos

    # Terminal & Shell Utilities
    foot
    kitty
    oh-my-posh
    fastfetch
    nvtopPackages.full
    bat

    # Media & Viewers
    vlc
    mpv
    swayimg
    wiremix

    # Languages
    rustup
    nodejs
    nixd
    alejandra
  ];

  programs = {
    zsh.enable = false;
    zoxide.enable = true;
    fd.enable = true;
    btop.enable = true;
    firefox.enable = true;
    brave.enable = true;
    keepassxc.enable = true;

    git = {
      enable = true;
      includes = [
        { path = "~/.config/git/local.config"; }
      ];
    };

    fzf = {
      enable = true;
      # This tells fzf to use fd for searching files
      defaultCommand = "fd --type f --hidden --exclude .git";
      # This tells fzf to use fd when you press Ctrl+T
      fileWidgetCommand = "fd --type f --hidden --exclude .git";
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        waylandSupport = true;

    extraPackages = with pkgs; [
      gcc
      gnumake
      unzip
      ripgrep
      fd
      tree-sitter
      rust-analyzer
      alejandra
      nixd
      lua-language-server
      ];
    };
  };

  services.udiskie.enable = true;

  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      enable = true;
      variables = ["--all"];
    };

    configType = "lua";
    extraConfig = builtins.readFile ../config/hypr/hyprland.lua;
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
  configs; 

  home.stateVersion = "26.05";
}

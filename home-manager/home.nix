{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    foot = "foot";
    waybar = "waybar";
    rofi = "rofi";
    ohmyposh = "ohmyposh";
  };
in

{
  home.username = "coconut";
  home.homeDirectory = "/home/coconut";

  wayland.windowManager.hyprland = {
    enable = true;

    # This is the key part for proper service startup (udiskie, etc.)
    systemd = {
      enable = true;
      variables = ["--all"];
    };

    # Since you're managing config with symlink, tell HM not to generate its own
    configType = "lua";        # or "none" depending on your HM version
    extraConfig = builtins.readFile ../config/hypr/hyprland.lua;
  };

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

    sideloadInitLua = true;
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
      ];
    };
  };

  services.udiskie.enable = true;
  # systemd.user.services.udiskie.Install.WantedBy = [ "default.target" ];

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

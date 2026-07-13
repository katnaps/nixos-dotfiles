{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    foot = "foot";
    waybar = "waybar";
    rofi = "rofi";
    ohmyposh = "ohmyposh";
    "hypr/hyprpaper.conf" = "hypr/hyprpaper.conf";
    "hypr/hl.meta.lua" = "hypr/hl.meta.lua";
    "nvim/lua" = "nvim/lua";
  };
in

{
  home.username = "coconut";
  home.homeDirectory = "/home/coconut";

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

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
    unzip
    zip

    # Media & Viewers
    vlc
    mpv
    swayimg
    wiremix

    # Languages
    nixd
    nixfmt
    rustup
    nodejs
  ];

  programs = {
    zoxide.enable = true;
    fd.enable = true;
    btop.enable = true;
    firefox.enable = true;
    brave.enable = true;
    keepassxc.enable = true;
    gpg.enable = true;

    zsh = {
      enable = true;
      initContent = ''
        source /home/coconut/nixos-dotfiles/.zshrc;
        export GPG_TTY=$(tty)
      '';
    };

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
      fileWidget.command = "fd --type f --hidden --exclude .git";
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
      initLua = builtins.readFile ../config/nvim/init.lua;

      extraPackages = with pkgs; [
        gcc
        gnumake
        unzip
        ripgrep
        fd
        tree-sitter

        # LSPs and Formatters
        lua-language-server
        nixd
        nixfmt
        rust-analyzer
        prettier
        stylua
      ];
    };
  };

  services = {
    udiskie.enable = true;

    # pinetry for gpg
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry = {
        package = pkgs.pinentry-curses;
      };
    };
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    configType = "lua";
    extraConfig = builtins.readFile ../config/hypr/hyprland.lua;
  };

  home.stateVersion = "26.05";
}

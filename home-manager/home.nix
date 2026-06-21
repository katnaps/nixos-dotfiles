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

    programs.git = { 
        enable = true;
    };

    home.stateVersion = "26.05";
    programs.zsh.enable = false;

    program.fzf = {
        enable = true;
    };

    home.packages = with pkgs; [
        hyprpaper
        oh-my-posh
    ];

    home.pointerCursor = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 24;
        gtk.enable = true;
    };

    xdg.configFile = builtins.mapAttrs ( name: subpath: {
        source = create_symlink "${dotfiles}/${subpath}";
        recursive = true;
    })
    configs;

}

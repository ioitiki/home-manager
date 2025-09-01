{ pkgs, inputs, ... }:

{
  # User-level packages used with Hyprland
  home.packages = with pkgs; [
    rofi-wayland
    hyprpaper
    xfce.thunar
    nwg-clipman
    hyprshot
    sublime
    sublime-merge
    
    # Dark theme support for various apps
    adwaita-qt
    adwaita-qt6
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 13;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.dracula-theme;
      name = "Dracula";
    };

    iconTheme = {
      package = pkgs.dracula-icon-theme;
      name = "Dracula";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    xwayland.enable = true;
  };
}


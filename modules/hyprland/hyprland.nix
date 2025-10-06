{ pkgs, inputs, ... }:

let
  cliphist-rofi-img = import ./cliphist-rofi-img.nix { inherit pkgs; };
in
{
  # User-level packages used with Hyprland
  home.packages = with pkgs; [
    hyprpaper
    xfce.thunar
    cliphist
    wl-clipboard
    hyprshot
    cliphist-rofi-img

    # Dark theme support for various apps
    adwaita-qt
    adwaita-qt6
  ];

  services.mako = {
    enable = true;
    extraConfig = ''
      background-color=#000000
      text-color=#FFFFFF
      border-color=#bd93f9
    '';
  };

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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
}

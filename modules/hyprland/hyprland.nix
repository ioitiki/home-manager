{ pkgs, inputs, ... }:

{
  # User-level packages used with Hyprland
  home.packages = with pkgs; [
    hyprpaper
    xfce.thunar
    cliphist
    wl-clipboard
    hyprshot

    # Dark theme support for various apps
    adwaita-qt
    adwaita-qt6
  ];

  # Enable GNOME Keyring for secret storage (needed by 1Password extension)
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

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
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
  };
}

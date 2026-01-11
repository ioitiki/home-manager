{ ... }:

let
  left = "/home/andy/Pictures/Backgrounds/earthandmoon_left.jpg";
  right = "/home/andy/Pictures/Backgrounds/earthandmoon_right.jpg";
  vert = "/home/andy/Pictures/Backgrounds/earthandmoon_right.jpg";
in
{
  # Disable the home-manager service since it generates old format
  services.hyprpaper.enable = false;

  # Write config manually with new 0.8+ format
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ${left}
    preload = ${right}

    wallpaper {
      monitor = DP-3
      path = ${left}
    }

    wallpaper {
      monitor = HDMI-A-1
      path = ${right}
    }

    wallpaper {
      monitor = DP-1
      path = ${vert}
    }

    ipc = on
    splash = false
  '';
}

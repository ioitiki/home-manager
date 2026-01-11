{ config, lib, ... }:

let
  # Change this to your wallpaper path
  left = "/home/andy/Pictures/Backgrounds/earthandmoon_left.jpg";
  right = "/home/andy/Pictures/Backgrounds/earthandmoon_right.jpg";
  vert = "/home/andy/Pictures/Backgrounds/earthandmoon_right.jpg";
in
{
  # Create hyprpaper configuration
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ${left}
    preload = ${right}
    preload = ${vert}

    wallpaper = DP-3,${left}
    wallpaper = HDMI-A-1,${right}
    wallpaper = DP-1,${vert}

    # Enable IPC for wallpaper changes at runtime
    ipc = on
  '';
}

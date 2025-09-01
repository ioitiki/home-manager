{ config, lib, ... }:

let
  # Change this to your wallpaper path
  left = "~/Pictures/Backgrounds/earthandmoon_left.jpg";  # Update this path to your wallpaper
  right = "~/Pictures/Backgrounds/earthandmoon_right.jpg";
in
{
  # Create hyprpaper configuration
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ${left}
    preload = ${right}
    
    wallpaper = DP-3,${left}
    wallpaper = HDMI-A-1,${right}
    
    # Enable IPC for wallpaper changes at runtime
    ipc = on
  '';
}

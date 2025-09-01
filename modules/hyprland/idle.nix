{ pkgs, lib, ... }:

{
  # Use Hyprland's native idle daemon
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    extraConfig = ''
      general {
          before_sleep_cmd = hyprctl dispatch dpms on
          after_sleep_cmd = hyprctl dispatch dpms on
          inhibit_sleep = 0
      }

      listener {
          timeout = 900
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
      }
    '';
  };
}



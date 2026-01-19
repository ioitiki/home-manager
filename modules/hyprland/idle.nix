{ pkgs, ... }:

{
  # Ensure hypridle is installed
  home.packages = [ pkgs.hypridle ];

  # Provide hypridle configuration file
  xdg.configFile."hypr/hypridle.conf".text = ''
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
}

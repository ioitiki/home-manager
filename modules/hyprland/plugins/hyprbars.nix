{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    plugins = [ inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars ];

    settings = {
      plugin.hyprbars = {
        enabled = false;
        bar_height = 20;

        "hyprbars-button" = [
          "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
          "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
        ];

        on_double_click = "hyprctl dispatch fullscreen 1";
      };
    };
  };
}

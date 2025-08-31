{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    plugins = [ inputs.hyprtasking.packages.${pkgs.system}.hyprtasking ];

    settings = {
      plugin.hyprtasking = {
        layout = "grid";
        gap_size = 20;
        bg_color = "0xff26233a";
        border_size = 4;
        exit_on_hovered = false;
      };

      # bind = [
      #   "ALT, up, hyprtasking:toggle, cursor"
      # ];
    };
  };
}
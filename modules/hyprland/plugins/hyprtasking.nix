{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    plugins = [ inputs.hyprtasking.packages.${pkgs.system}.hyprtasking ];
  };

  extraConfig = ''
    # hyprlang noerror true
    bind=ALT, up, hyprtasking:toggle, cursor
    # hyprlang noerror false
  '';
}
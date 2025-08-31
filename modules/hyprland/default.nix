{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./plugins
    inputs.hyprland.homeManagerModules.default
  ];
}

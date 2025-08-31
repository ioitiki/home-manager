{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./settings.nix
    ./plugins
    inputs.hyprland.homeManagerModules.default
  ];
}

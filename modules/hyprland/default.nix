{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./settings.nix
    ./variables.nix
    ./plugins
    inputs.hyprland.homeManagerModules.default
  ];
}

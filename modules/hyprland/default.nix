{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./settings.nix
    ./variables.nix
    ./idle.nix
    ./plugins
    inputs.hyprland.homeManagerModules.default
  ];
}

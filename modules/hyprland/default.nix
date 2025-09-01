{ inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./settings.nix
    ./variables.nix
    ./plugins
    inputs.hyprland.homeManagerModules.default
  ];
}

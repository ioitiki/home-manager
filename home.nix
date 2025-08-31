{ pkgs, inputs, ... }:

{
  imports = [
    ./zsh.nix
    ./modules/waybar/waybar.nix
    ./modules/hyprland/hyprexpo.nix
    ./modules/hyprland/hyprland.nix
  ];

  home.username = "andy";
  home.homeDirectory = "/home/andy";
  home.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;

  programs = {
    google-chrome.enable = true;
    alacritty.enable = true;
  };

  home = {
    packages = with pkgs; [
      neofetch
      cups-brother-hll2340dw
      resources
      lsof
      xarchiver
    ];
  };

  programs.home-manager.enable = true;
}

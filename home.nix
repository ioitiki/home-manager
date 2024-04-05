{ pkgs, ... }:

{
  imports = [./zsh.nix];

  home.username = "andy";
  home.homeDirectory = "/home/andy";
  home.stateVersion = "23.11";

  programs = {
    google-chrome.enable = true;
  };

  home = {
    packages = with pkgs; [
      neofetch
    ];
  };

  programs.home-manager.enable = true;
}
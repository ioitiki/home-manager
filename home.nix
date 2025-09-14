{ pkgs, inputs, ... }:

{
  imports = [
    ./zsh.nix
    ./modules
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
      zed-editor-fhs
      neofetch
      cups-brother-hll2340dw
      resources
      lsof
      xarchiver
      vivaldi
      vivaldi-ffmpeg-codecs
      _1password
      _1password-gui
      pavucontrol
      pamixer
      # Add TypeScript Language Server
      nodePackages.typescript-language-server
      nodePackages.typescript
    ];
  };

  programs.home-manager.enable = true;
}

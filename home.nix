{ pkgs, ... }:

let
  claude-code = import ./claude-code/package.nix {
    inherit (pkgs)
      lib
      buildNpmPackage
      fetchzip
      writableTmpDirAsHomeHook
      versionCheckHook
      ;
  };
in
{
  imports = [
    ./zsh.nix
    ./modules
    ./redis.nix
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
    enableNixpkgsReleaseCheck = false;
    packages = with pkgs; [
      android-file-transfer
      figma-linux
      ripgrep
      lazydocker
      claude-code
      zenity
      gnome-calculator
      buf
      obs-studio
      zed-editor-fhs
      neofetch
      cups-brother-hll2340dw
      resources
      lsof
      libnotify
      xarchiver
      vivaldi
      vivaldi-ffmpeg-codecs
      _1password-cli
      _1password-gui
      pavucontrol
      pamixer
      solaar
      # Add Language Servers
      yaml-language-server
      nodePackages.typescript-language-server
      nodePackages.typescript
      zathura
      # Fonts
      nerd-fonts.jetbrains-mono # or other nerd-fonts variants
      # nerd-fonts.fira-code
      hack-font
      noto-fonts
      noto-fonts-color-emoji
      font-awesome
      fira-code
      inter
      # Interactive Brokers TWS
      (callPackage ./ib-tws.nix { })
    ];
  };

  fonts.fontconfig.enable = true;

  # fonts.packages = with pkgs; [
  #     noto-fonts
  #     noto-fonts-cjk-sans
  #     noto-fonts-color-emoji
  #     liberation_ttf
  #     fira-code
  #     fira-code-symbols
  #     mplus-outline-fonts.githubRelease
  #     dina-font
  #     proggyfonts
  #     nerd-fonts.fira-code
  #     font-awesome
  #   ];

  programs.home-manager.enable = true;
}

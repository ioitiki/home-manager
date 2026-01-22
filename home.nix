{ pkgs, ... }:

let
  whisper-cpp-cuda = pkgs.whisper-cpp.override {
    cudaSupport = true;
  };
  claude-code = import ./claude-code/package.nix {
    inherit (pkgs)
      lib
      buildNpmPackage
      fetchzip
      writableTmpDirAsHomeHook
      versionCheckHook
      ;
  };
  zed-editor = import ./zed-editor/package.nix {
    inherit (pkgs)
      lib
      rustPlatform
      fetchFromGitHub
      cmake
      copyDesktopItems
      curl
      perl
      pkg-config
      protobuf
      fontconfig
      freetype
      libgit2
      openssl
      sqlite
      zlib
      zstd
      alsa-lib
      libxkbcommon
      wayland
      libglvnd
      xorg
      stdenv
      makeFontsConf
      vulkan-loader
      envsubst
      nix-update-script
      cargo-about
      versionCheckHook
      buildFHSEnv
      cargo-bundle
      git
      apple-sdk_15
      darwinMinVersionHook
      makeBinaryWrapper
      nodejs
      libGL
      livekit-libwebrtc
      testers
      writableTmpDirAsHomeHook
      ;
    libX11 = pkgs.xorg.libX11;
    libXext = pkgs.xorg.libXext;
    zed-editor = pkgs.zed-editor;
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
    sessionPath = [ "$HOME/.config/home-manager/scripts" ];
    packages = with pkgs; [
      android-file-transfer
      whisper-cpp-cuda
      figma-linux
      ripgrep
      vim
      # beekeeper-studio
      lazydocker
      claude-code
      zenity
      gnome-calculator
      buf
      obs-studio
      zed-editor.fhs
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
      wtype
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

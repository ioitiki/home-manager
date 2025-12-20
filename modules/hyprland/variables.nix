{ ... }:
{
  home.sessionVariables = {
    NODE_OPTIONS = "--max-old-space-size=8192"; # 8GB heap
    BROWSER = "vivaldi";
    NIXOS_OZONE_WL = 1;
    # __GL_GSYNC_ALLOWED = 0;
    # __GL_VRR_ALLOWED = 0;
    # _JAVA_AWT_WM_NONEREPARENTING = 1;
    # SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
    # DISABLE_QT5_COMPAT = 0;
    GDK_BACKEND = "wayland";
    # ANKI_WAYLAND = 1;
    # DIRENV_LOG_FORMAT = "";
    # WLR_DRM_NO_ATOMIC = "1";
    # WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0:/dev/dri/card2";
    # QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    # QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "gtk3";
    # QT_STYLE_OVERRIDE = "kvantum";
    MOZ_ENABLE_WAYLAND = 1;
    # WLR_BACKEND = "vulkan";
    # WLR_RENDERER = "vulkan";
    # WLR_NO_HARDWARE_CURSORS = 1;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    # SDL_VIDEODRIVER = "wayland";
    # CLUTTER_BACKEND = "wayland";
    GTK_THEME = "Dracula";
    GRIMBLAST_HIDE_CURSOR = 0;
    
    # Additional dark theme variables
    GTK_USE_PORTAL = 1;
    GSETTINGS_BACKEND = "keyfile";
  };
}

{ ... }:

let
  # Sunshine configuration for Wayland/Hyprland
  # See: https://docs.lizardbyte.dev/projects/sunshine/
  sunshineConf = ''
    # Anthropic Sunshine configuration for Hyprland

    # Capture method - use wlroots for Hyprland
    capture = wlroots

    # Encoder settings (adjust based on your GPU)
    encoder = nvenc

    # Quality settings
    min_fps_factor = 1

    # Audio settings
    audio_sink =

    # Logging
    min_log_level = info
  '';

  # Apps configuration with entries for each monitor
  appsJson = builtins.toJSON {
    env = {
      PATH = "$(PATH):$(HOME)/.local/bin";
    };
    apps = [
      {
        name = "Desktop - All Monitors";
        output = "";  # Empty = default behavior
        image-path = "desktop.png";
      }
      {
        name = "Main Monitor (DP-3)";
        output = "DP-3";
        image-path = "desktop.png";
      }
      {
        name = "Right Monitor (HDMI-A-1)";
        output = "HDMI-A-1";
        image-path = "desktop.png";
      }
      {
        name = "Vertical Monitor (DP-1)";
        output = "DP-1";
        image-path = "desktop.png";
      }
      {
        name = "Steam Big Picture";
        output = "DP-3";
        detached = [
          "setsid steam steam://open/bigpicture"
        ];
        prep-cmd = [
          {
            do = "";
            undo = "setsid steam steam://close/bigpicture";
          }
        ];
        image-path = "steam.png";
      }
    ];
  };
in
{
  xdg.configFile."sunshine/sunshine.conf".text = sunshineConf;
  xdg.configFile."sunshine/apps.json".text = appsJson;
}

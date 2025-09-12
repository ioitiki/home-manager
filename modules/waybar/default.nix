{ ... }:
let
  custom = {
    font = "FiraCode Nerd Font";
    font_size = "18px";
    font_weight = "bold";
    text_color = "#F8F8F2";
    purple = "#bd93f9";
    background_0 = "#1E1F29";
    background_1 = "#282A36";
    border_color = "#44475A";
    red = "#FF5555";
    green = "#50FA7B";
    yellow = "#F1FA8C";
    blue = "#6272A4";
    magenta = "#BD93F9";
    cyan = "#8BE9FD";
    orange = "#FFB86C";
    orange_bright = "#FFD1A6";
    opacity = "1";
    indicator_height = "2px";
  };

  customSettings = {
    font = "FiraCode Nerd Font";
    font_size = "18px";
    font_weight = "bold";
    text_color = "#F8F8F2";
    purple = "#bd93f9";
    background_0 = "#1E1F29";
    background_1 = "#282A36";
    border_color = "#44475A";
    red = "#FF5555";
    green = "#50FA7B";
    yellow = "#F1FA8C";
    blue = "#6272A4";
    magenta = "#BD93F9";
    cyan = "#8BE9FD";
    orange = "#FFB86C";
    opacity = "1";
    indicator_height = "2px";
  };
in
{
  programs.waybar.enable = true;

  programs.waybar.settings.leftBar = with customSettings; {
    position = "top";
    layer = "top";
    height = 30;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    output = [ "DP-3" ];
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
      "wlr/taskbar"
    ];
    modules-center = [ ];
    modules-right = [ "clock" ];
    cpu = {
      format = "<span foreground='${green}'> </span> {usage}%";
      format-alt = "<span foreground='${green}'> </span> {avg_frequency} GHz";
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    memory = {
      format = "<span foreground='${cyan}'>󰟜 </span>{}%";
      format-alt = "<span foreground='${cyan}'>󰟜 </span>{used} GiB"; # 
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    disk = {
      # path = "/";
      format = "<span foreground='${orange}'>󰋊 </span>{percentage_used}%";
      interval = 60;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    network = {
      format-wifi = "<span foreground='${magenta}'> </span> {signalStrength}%";
      format-ethernet = "<span foreground='${magenta}'>󰀂 </span>";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "<span foreground='${magenta}'>󰖪 </span>";
    };
    "wlr/taskbar" = {
      format = "{icon}";
      icon-size = 20;
      icon-theme = "Papirus";
      all-outputs = false;
      tooltip-format = "{app_id} — {title}";
      on-click = "activate";
      on-click-middle = "close";
      on-click-right = "minimize";
    };
    clock = {
      format = "{:%a %b %d  %I:%M %p}";
      tooltip-format = "{:%A, %B %d, %Y  %I:%M:%S %p}";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "<span foreground='${blue}'> </span> {volume}%";
      format-icons = {
        default = [ "<span foreground='${blue}'> </span>" ];
      };
      scroll-step = 2;
      on-click = "pamixer -t";
      on-click-right = "pavucontrol";
    };
  };

  programs.waybar.settings.rightBar = with customSettings; {
    position = "top";
    layer = "top";
    height = 30;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    output = [ "HDMI-A-1" ];
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
      "wlr/taskbar"
    ];
    modules-center = [ ];
    modules-right = [
      "tray"
      "cpu"
      "memory"
      "disk"
      "pulseaudio"
      "network"
    ];
    cpu = {
      format = "<span foreground='${green}'> </span> {usage}%";
      format-alt = "<span foreground='${green}'> </span> {avg_frequency} GHz";
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    memory = {
      format = "<span foreground='${cyan}'>󰟜 </span>{}%";
      format-alt = "<span foreground='${cyan}'>󰟜 </span>{used} GiB"; # 
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    disk = {
      # path = "/";
      format = "<span foreground='${orange}'>󰋊 </span>{percentage_used}%";
      interval = 60;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    network = {
      format-wifi = "<span foreground='${magenta}'> </span> {signalStrength}%";
      format-ethernet = "<span foreground='${magenta}'>󰀂 </span>";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "<span foreground='${magenta}'>󰖪 </span>";
    };
    "wlr/taskbar" = {
      format = "{icon}";
      icon-size = 20;
      icon-theme = "Papirus";
      all-outputs = false;
      tooltip-format = "{app_id} — {title}";
      on-click = "activate";
      on-click-middle = "close";
      on-click-right = "minimize";
    };
    clock = {
      format = "{:%a %b %d  %I:%M %p}";
      tooltip-format = "{:%A, %B %d, %Y  %I:%M:%S %p}";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "<span foreground='${blue}'> </span> {volume}%";
      format-icons = {
        default = [ "<span foreground='${blue}'> </span>" ];
      };
      scroll-step = 2;
      on-click = "pamixer -t";
      on-click-right = "pavucontrol";
    };
  };

  programs.waybar.style = with custom; ''
    * {
      border: none;
      border-radius: 0px;
      padding: 0;
      margin: 0;
      font-family: ${font}, "Symbols Nerd Font", "Font Awesome 6 Free", "Font Awesome 6 Brands", "Font Awesome 5 Free";
      font-weight: ${font_weight};
      opacity: ${opacity};
      font-size: ${font_size};
    }

    window#waybar {
      background: ${background_0};
      border-top: 1px solid ${border_color};
    }

    tooltip {
      background: ${background_1};
      border: 1px solid ${border_color};
    }
    tooltip label {
      margin: 5px;
      color: ${text_color};
    }

    #workspaces {
      padding-left: 15px;
    }
    #workspaces button {
      color: ${yellow};
      padding-left:  5px;
      padding-right: 5px;
      margin-right: 10px;
    }
    #workspaces button.empty {
      color: ${text_color};
    }
    #workspaces button.active {
      color: ${purple};
    }

    #clock {
      color: ${text_color};
      margin-top: 2px;
      margin-right: 20px;
    }

    #tray {
      margin-right: 10px;
      color: ${text_color};
    }
    #tray menu {
      background: ${background_1};
      border: 1px solid ${border_color};
      padding: 8px;
    }
    #tray menuitem {
      padding: 1px;
    }

    #pulseaudio, #network, #cpu, #memory, #disk, #battery, #language, #custom-notification {
      padding-left: 5px;
      padding-right: 5px;
      margin-right: 10px;
      color: ${text_color};
    }

    #pulseaudio, #language {
      margin-left: 15px;
    }

    #custom-notification {
      margin-left: 15px;
      padding-right: 2px;
      margin-right: 5px;
    }

    #custom-launcher {
      font-size: 20px;
      color: ${text_color};
      font-weight: bold;
      margin-left: 15px;
      padding-right: 10px;
    }

    #taskbar {
      padding-left: 5px;
      padding-right: 5px;
      margin-right: 10px;
    }
    #taskbar button {
      padding-left: 6px;
      padding-right: 6px;
      color: ${text_color};
    }
    #taskbar button.active {
      color: ${orange_bright};
    }
  '';

  home.file.".config/waybar/scripts/hypr-windows.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      if ! command -v jq >/dev/null 2>&1; then
        notify-send "hypr-windows" "jq is not installed"
        exit 1
      fi

      active_ws_id=$(hyprctl activeworkspace -j | jq -r '.id')
      clients_json=$(hyprctl clients -j)

      # Build menu of windows on the active workspace
      menu=$(echo "$clients_json" | jq -r --argjson ws "$active_ws_id" '
        .[]
        | select(.workspace.id == $ws and .mapped == true)
        | "\(.address)\t\(.class)\t\(.title)"')

      [ -z "$menu" ] && exit 0

      choice=$(echo "$menu" | rofi -dmenu -i -p "Windows" -sep "\t" -theme "$HOME/.config/rofi/themes/custom.rasi" \
        | awk '{print $1}')

      [ -z "$choice" ] && exit 0

      hyprctl dispatch focuswindow "address:$choice"
    '';
  };
}

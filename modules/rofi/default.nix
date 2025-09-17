{ config, pkgs, ... }:

let
  themeFile = ''
    * {
        selected-normal-foreground:  rgba ( 249, 249, 249, 100 % );
        foreground:                  rgba ( 196, 203, 212, 100 % );
        normal-foreground:           @foreground;
        alternate-normal-background: rgba ( 0, 0, 0, 59 % );
        red:                         rgba ( 220, 50, 47, 100 % );
        selected-urgent-foreground:  rgba ( 249, 249, 249, 100 % );
        blue:                        rgba ( 38, 139, 210, 100 % );
        urgent-foreground:           rgba ( 204, 102, 102, 100 % );
        alternate-urgent-background: rgba ( 75, 81, 96, 90 % );
        active-foreground:           rgba ( 145, 102, 255, 100 % );
        lightbg:                     rgba ( 238, 232, 213, 100 % );
        selected-active-foreground:  rgba ( 249, 249, 249, 100 % );
        alternate-active-background: rgba ( 75, 81, 96, 89 % );
        background:                  rgba ( 0, 0, 0, 95 % );
        alternate-normal-foreground: @foreground;
        normal-background:           @background;
        lightfg:                     rgba ( 88, 104, 117, 100 % );
        selected-normal-background:  rgba ( 249, 249, 249, 20 % );
        border-color:                rgba ( 124, 131, 137, 100 % );
        spacing:                     2;
        separatorcolor:              rgba ( 29, 31, 33, 100 % );
        urgent-background:           rgba ( 29, 31, 33, 17 % );
        selected-urgent-background:  rgba ( 165, 66, 66, 100 % );
        alternate-urgent-foreground: @urgent-foreground;
        background-color:            rgba ( 0, 0, 0, 0 % );
        alternate-active-foreground: @active-foreground;
        active-background:           rgba ( 29, 31, 33, 17 % );
        selected-active-background:  rgba ( 249, 249, 249, 20 % );
    }
    window {
        background-color: @background;
        border:           1;
        padding:          5;
    }
    mainbox {
        border:  0;
        padding: 0;
    }
    message {
        border:       2px 0px 0px ;
        border-color: @separatorcolor;
        padding:      1px ;
    }
    textbox {
        text-color: @foreground;
    }
    listview {
        fixed-height: 0;
        border:       2px 0px 0px ;
        border-color: @separatorcolor;
        spacing:      2px ;
        scrollbar:    true;
        padding:      2px 0px 0px ;
    }
    element {
        border:  0;
        padding: 1px ;
    }
    element-text {
        background-color: inherit;
        text-color:       inherit;
    }
    element.normal.normal {
        background-color: @normal-background;
        text-color:       @normal-foreground;
    }
    element.normal.urgent {
        background-color: @urgent-background;
        text-color:       @urgent-foreground;
    }
    element.normal.active {
        background-color: @active-background;
        text-color:       @active-foreground;
    }
    element.selected.normal {
        background-color: @selected-normal-background;
        text-color:       @selected-normal-foreground;
    }
    element.selected.urgent {
        background-color: @selected-urgent-background;
        text-color:       @selected-urgent-foreground;
    }
    element.selected.active {
        background-color: @selected-active-background;
        text-color:       @selected-active-foreground;
    }
    element.alternate.normal {
        background-color: @alternate-normal-background;
        text-color:       @alternate-normal-foreground;
    }
    element.alternate.urgent {
        background-color: @alternate-urgent-background;
        text-color:       @alternate-urgent-foreground;
    }
    element.alternate.active {
        background-color: @alternate-active-background;
        text-color:       @alternate-active-foreground;
    }
    scrollbar {
        width:        4px ;
        border:       0;
        handle-color: @normal-foreground;
        handle-width: 8px ;
        padding:      0;
    }
    mode-switcher {
        border:       2px 0px 0px ;
        border-color: @separatorcolor;
    }
    button {
        spacing:    0;
        text-color: @normal-foreground;
    }
    button.selected {
        background-color: @selected-normal-background;
        text-color:       @selected-normal-foreground;
    }
    inputbar {
        spacing:    0;
        text-color: @normal-foreground;
        padding:    1px ;
    }
    case-indicator {
        spacing:    0;
        text-color: @normal-foreground;
    }
    entry {
        spacing:    0;
        text-color: @normal-foreground;
    }
    prompt {
        spacing:    0;
        text-color: @normal-foreground;
    }
    inputbar {
        children:   [ prompt,textbox-prompt-colon,entry,case-indicator ];
    }
    textbox-prompt-colon {
        expand:     false;
        str:        ":";
        margin:     0px 0.3em 0em 0em ;
        text-color: @normal-foreground;
    }
  '';
in
{
  # Use the built-in Home Manager module for programs.rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  # Manage config and theme files declaratively
  xdg.configFile."rofi/themes/custom.rasi".text = themeFile;

  xdg.configFile."rofi/config.rasi".text = ''
    @theme "themes/custom.rasi"

    configuration {
      modes: [ drun, run, window ];
      show-icons: true;
      icon-theme: "Papirus";
      display-drun: "  Apps";
      display-run:  "  Run";
      display-window:"  Windows";
      drun-display-format: "{name} [<span weight='light' size='small'>{exec}</span>]";
      sidebar-mode: false;
      sort: true;
      matching: "fuzzy";
      case-sensitive: false;
      click-to-exit: true;
      global-kb: true;
    }
  '';

  # Minimal power menu script for shutdown and reboot
  home.file.".config/rofi/power-menu.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      choices="Shutdown\nReboot"
      selection=$(printf "%b" "$choices" | rofi -dmenu -i -p "Power")

      case "${selection:-}" in
        Shutdown)
          systemctl poweroff
          ;;
        Reboot)
          systemctl reboot
          ;;
        *)
          exit 0
          ;;
      esac
    '';
  };
}




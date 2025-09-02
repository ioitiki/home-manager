{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.programs.rofi;
in
{

  home.packages = with pkgs; [
    rofi-wayland
  ];

  options.programs.rofi = {
    enable = mkEnableOption "Enable rofi-wayland with declarative config and theme";

    package = mkOption {
      type = types.package;
      default = pkgs.rofi-wayland;
      description = "Rofi package to install (Wayland fork by default).";
    };

    theme = mkOption {
      type = types.str;
      default = "custom";
      description = "Theme name to use (without extension).";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra lines appended to config.rasi.";
    };

    themeFile = mkOption {
      type = types.lines;
      default = ''
        * {
          font: "Maple Mono 14";
          text-color: #FBF1C7;
          background: #282828FF;
          border-color: #928374FF;
        }

        window {
          background-color: @background;
          border: 2px;
          border-color: @border-color;
          padding: 8px;
        }

        inputbar {
          background-color: #1D2021FF;
          text-color: @text-color;
          padding: 6px 8px;
          border: 1px;
          border-color: @border-color;
        }

        prompt { text-color: #FABD2FFF; }
        entry { text-color: @text-color; }

        listview {
          background-color: @background;
          padding: 6px 0;
          columns: 1;
          spacing: 3px;
          fixed-height: false;
        }

        element { padding: 4px 10px; }
        element selected { background-color: #3C3836FF; }
        element-text { text-color: @text-color; }
        element-text selected { text-color: #FE8019FF; }
      '';
      description = "Contents of the custom theme file themes/<theme>.rasi.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = {
      "rofi/config.rasi".text = ''
        @theme "themes/${cfg.theme}.rasi"

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
        }
        ${cfg.extraConfig}
      '';

      "rofi/themes/${cfg.theme}.rasi".text = cfg.themeFile;
    };
  };
}



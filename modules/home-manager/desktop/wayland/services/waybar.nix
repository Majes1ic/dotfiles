{ config
, nixosConfig
, lib
, hostname
, ...
}:
let
  cfg = config.modules.desktop.waybar;
  desktopCfg = config.modules.desktop;
  isWayland = lib.fetchers.isWayland config;
  osDesktopEnabled = nixosConfig.usrEnv.desktop.enable;
  sessionTarget = lib.fetchers.getDesktopSessionTarget config;
  colors = config.colorscheme.colors;
in
lib.mkIf (osDesktopEnabled && isWayland && cfg.enable) {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = sessionTarget;
    };
    style =
      let
        cornerRadius = builtins.toString desktopCfg.style.cornerRadius;
        halfCornerRadius = builtins.toString (desktopCfg.style.cornerRadius / 2);
        borderWidth = builtins.toString desktopCfg.style.borderWidth;
      in
        /* css */ ''
        @define-color background #${colors.base00};
        @define-color border #${colors.base05};
        @define-color text-dark #${colors.base00};
        @define-color text-light #${colors.base07};
        @define-color green #${colors.base0B};
        @define-color blue #${colors.base0D};
        @define-color red #${colors.base08};
        @define-color purple #${colors.base0E};
        @define-color orange #${colors.base0F};
        @define-color transparent rgba(0,0,0,0);

        * {
            font-family: '${desktopCfg.style.font.family}';
            font-size: 16px;
            font-weight: 600;
            min-height: 0px;
        }

        tooltip {
            background: @background;
            color: @text-light;
            border-radius: ${halfCornerRadius}px;
            border: ${borderWidth}px solid @background;
        }

        window#waybar {
            background: @background;
            color: @text-light;
            border-radius: ${cornerRadius}px;
            border: ${borderWidth}px solid @background;
        }

        window#waybar.fullscreen {
            border: ${borderWidth}px solid @red;
        }

        #workspaces {
            margin: 5px 0px 5px 5px;
            padding: 0px 0px;
            border-radius: ${halfCornerRadius}px;
            background: @blue;
        }

        button {
          border-color: @transparent;
          background: @transparent;
        }

        #workspaces button {
            padding: 5px;
        }

        #workspaces button:hover {
            box-shadow: inherit;
            text-shadow: inherit;
        }

        #workspaces button label {
            border-radius: ${halfCornerRadius}px;
            border: ${borderWidth}px solid @transparent;

            padding: 0px 0.4em;

            color: @text-dark;
            font-weight: 500;
        }

        #workspaces button.visible label {
            background: @transparent;
            border: ${borderWidth}px solid @background;
            color: @text-dark;
            font-weight: 900;
        }

        #workspaces button.active label {
            background: @background;
            border: ${borderWidth}px solid @background;
            color: @text-light;
            font-weight: 900;
        }

        #custom-wlogout {
            padding-right: 4px;
            color: @red;
        }

        #network.hostname {
            margin: 5px 5px 5px 0px;
            padding: 5px 7px;
            border-radius: ${halfCornerRadius}px;
            background: @blue;
            color: @text-dark;
        }
      '';
    settings = {
      bar =
        let
          gapSize = builtins.toString desktopCfg.style.gapSize;
        in
        {
          layer = "top";
          height = 45;
          margin = "${gapSize} ${gapSize} 0 ${gapSize}";
          spacing = 17;
          "hyprland/workspaces" = {
            "on-click" = "activate";
            "sort-by-number" = true;
            "active-only" = false;
            # TODO: Configure this modularly
            "persistent-workspaces" = {
              "1" = [
                "DP-2"
              ];
              "3" = [
                "DP-2"
              ];
              "2" = [
                "HDMI-A-1"
              ];
              "4" = [
                "HDMI-A-1"
              ];
            };
          };
          "hyprland/submap" = {
            format = "{}";
            "max-length" = 8;
            tooltip = false;
          };
          "hyprland/window" = {
            "max-length" = 59;
            "separate-outputs" = true;
          };
          clock = {
            interval = 1;
            format = "{:%H:%M:%S}";
            "format-alt" = "{:%e %B %Y}";
            "tooltip-format" = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              "mode-mon-col" = 3;
              "weeks-pos" = "";
              "on-scroll" = 1;
              format = {
                months = "<span color='#${colors.base05}'><b>{}</b></span>";
                days = "<span color='#${colors.base05}'><b>{}</b></span>";
                weekdays = "<span color='#${colors.base03}'><b>{}</b></span>";
                today = "<span color='#${colors.base0B}'><b>{}</b></span>";
              };
            };
            actions = {
              "on-click-right" = "mode";
              "on-scroll-up" = "shift_up";
              "on-scroll-down" = "shift_down";
            };
          };
          pulseaudio = {
            format = "<span color='#${colors.base04}'>{icon}</span> {volume:2}%";
            "format-muted" = "<span color='#${colors.base08}'>󰖁</span> {volume:2}%";
            "format-icons" = {
              headphone = "";
              hdmi = "󰍹";
              default = [
                "<span size='large'></span>"
                "<span size='large'>󰕾</span>"
                "<span size='large'></span>"
              ];
            };
            "on-click" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
            tooltip = false;
          };
          network = {
            interval = 5;
            format = "<span color='#${colors.base04}'>󰈀</span> {bandwidthTotalBytes}";
            "tooltip-format" = "<span color='#${colors.base0D}'>󰇚</span>{bandwidthDownBytes:>} <span color='#59c2ff'>󰕒</span>{bandwidthUpBytes:>}";
            "max-length" = 50;
          };
          cpu = {
            interval = 5;
            format = "<span color='#${colors.base04}'></span> {usage}%";
          };
          memory = {
            interval = 30;
            format = "<span color='#${colors.base04}'></span> {used:0.1f}GiB";
          };
          "network#hostname" = {
            "format-ethernet" = "${lib.toUpper hostname}";
            "format-disconnected" = "<span color='#${colors.base08}'>${lib.toUpper hostname}</span>";
            "tooltip-format-ethernet" = "<span color='#${colors.base0B}'>{ipaddr}</span>";
            "tooltip-format-disconnected" = "<span color='#${colors.base08}'>Disconnected</span>";
          };
          tray = {
            "icon-size" = 19;
            "show-passive-items" = true;
            spacing = 17;
          };
          "custom/wlogout" = {
            format = "⏻";
            "on-click" = "wlogout";
            tooltip = false;
          };
          "modules-left" = [
            "custom/fullscreen"
            "hyprland/workspaces"
            "hyprland/submap"
            "hyprland/window"
          ];
          "modules-center" = [
            "clock"
          ];
          "modules-right" = [
            "network"
            "cpu"
            "memory"
            "pulseaudio"
            "tray"
            "custom/wlogout"
            "network#hostname"
          ];
        };
    };
  };
}

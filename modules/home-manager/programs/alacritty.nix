{ config
, lib
, ...
}:
let
  binary = "${config.programs.alacritty.package}/bin/alacritty";
  cfg = config.modules.programs.alacritty;
  desktopCfg = config.modules.desktop;
  colors = config.colorscheme.colors;
in
lib.mkIf cfg.enable {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };
        dynamic_padding = true;
        decorations = "none";
        opacity = cfg.opacity;
        dynamic_title = true;
      };
      scrolling = {
        history = 10000;
      };
      font = {
        size = 13.5;
        normal = {
          family = "${desktopCfg.style.font.family}";
          style = "Regular";
        };
      };
      colors = {
        primary = {
          background = "#${colors.base00}";
          foreground = "#${colors.base05}";
          bright_foreground = "#${colors.base06}";
        };
        normal = {
          black = "#${colors.base02}";
          red = "#${colors.base08}";
          green = "#${colors.base0B}";
          yellow = "#${colors.base0A}";
          blue = "#${colors.base0D}";
          magenta = "#${colors.base0E}";
          cyan = "#${colors.base0C}";
          white = "#${colors.base07}";
        };
      };
      mouse = {
        hide_when_typing = true;
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        blink_interval = 500;
      };
    };
  };
  desktop.hyprland.binds = lib.mkIf (desktopCfg.windowManager == "hyprland")
    [ "${desktopCfg.hyprland.modKey}, Return, exec, ${binary}" ];
}

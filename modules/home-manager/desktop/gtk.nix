{ pkgs
, config
, nixosConfig
, lib
, ...
}:
let
  desktopCfg = config.modules.desktop;
  colors = config.colorscheme.colors;
in
lib.mkIf nixosConfig.usrEnv.desktop.enable {
  gtk = {
    enable = true;
    theme = {
      name = "Plata-Noir-Compact";
      package = pkgs.plata-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = desktopCfg.style.cursorSize;
    };
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  desktop.hyprland.settings = lib.mkIf (desktopCfg.windowManager == "hyprland") {
    env = [
      "XCURSOR_THEME,${config.gtk.cursorTheme.name}"
      "XCURSOR_SIZE,${builtins.toString desktopCfg.style.cursorSize}"
    ];
    exec-once = [
      "hyprctl setcursor ${config.gtk.cursorTheme.name} ${builtins.toString desktopCfg.style.cursorSize}"
    ];
  };
}

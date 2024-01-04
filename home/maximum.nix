{ pkgs
, config
, lib
, inputs
, ...
}: {
  imports = [
    ./core.nix
  ];

  home.packages = with pkgs; [
    mpv
  ];

  modules = {
    shell.enable = true;

    desktop = {
      windowManager = "hyprland";

      style = {
        font = {
          family = "FiraCode Nerd Font";
          package = pkgs.nerdfonts.override {fonts = ["FiraCode"];};
        };
        cursorSize = 24;
        cornerRadius = 10;
        borderWidth = 2;
        gapSize = 10;
      };

      swaylock = {
        enable = false;
      };

      swayidle = {
        enable = false;
        lockTime = 3 * 60;
        lockedScreenOffTime = 2 * 60;
      };

      anyrun.enable = true;
      waybar.enable = true;
      dunst.enable = true;
      swww.enable = true;
    };

    programs = {
      alacritty.enable = true;
      btop.enable = true;
      cava.enable = true;
      firefox.enable = true;
      git.enable = true;
      neovim.enable = true;
      spotify.enable = true;
      fastfetch.enable = true;
      discord.enable = true;
      obs.enable = true;
    };
  };
}

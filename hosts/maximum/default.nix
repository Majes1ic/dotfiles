{
  imports = [
    ./hardware-configuration.nix
  ];

  device = {
    type = "desktop";
    cpu = "vm-intel";
    gpu = null;
    monitors = [
      {
        name = "DP-1";
        number = 1;
        refreshRate = 60.0;
        width = 2560;
        height = 1440;
        position = "0x0";
        workspaces = [ 1 2 3 4 5 6 7 8 9 ];
      }
    ];
  };

  usrEnv = {
    homeManager.enable = true;
    desktop = {
      enable = true;
      desktopManager = null;
    };
  };

  modules = {
    hardware = {
      fileSystem = {
        trim = true;
        rootTmpfsSize = "1G";
        zpoolName = "zpool";
        bootLabel = "boot";
      };
    };

    programs = {
      wine.enable = false;
      winbox.enable = false;
      steam.enable = false;
    };

    services = {
      greetd = {
        enable = false;
        launchCmd = "Hyprland";
      };
      syncthing.enable = false;
    };

    system = {
      windowsBootEntry.enable = false;
      networking = {
        tcpOptimisations = true;
        firewall.enable = true;
        resolved.enable = true;
      };
      audio = {
        enable = true;
        extraAudioTools = false;
      };
      virtualisation.enable = false;
    };
  };

  networking.hostId = "625ec505";

  system.stateVersion = "23.05";
}

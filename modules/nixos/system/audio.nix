{ pkgs
, username
, lib
, config
, ...
}:
let
  cfg = config.modules.system.audio;
in
lib.mkMerge [

  (lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };

    hardware.pulseaudio.enable = false;

    # Reduces latency in some situations
    security.rtkit.enable = true;
  })

  (lib.mkIf cfg.extraAudioTools {
    environment.systemPackages = with pkgs; [
      easyeffects
      helvum
    ];

    environment.persistence."/persist".users.${username} = {
      directories = [
        ".config/easyeffects"
      ];
    };
  })
]

{ hostname
, config
, lib
, ...
}:
let
  inherit (lib) mkMerge mkIf;
  cfg = config.modules.system.networking;
in
{
  networking = {
    hostName = "${hostname}";
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };
    firewall = {
      enable = cfg.firewall.enable;
    };
  };

  boot = {
    kernel.sysctl = mkMerge [
      {
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        # Enable reverse path filtering
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        # Do not accept IP source route packets
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv6.conf.all.accept_source_route" = 0;
        # Don't send ICMP redirects
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;
        # Refuse ICMP redirects
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 0;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        # Protects against SYN flood attacks
        "net.ipv4.tcp_syncookies" = 1;
        # Incomplete protection again TIME-WAIT assassination
        "net.ipv4.tcp_rfc1337" = 1;
      }
      (mkIf cfg.tcpOptimisations {
        # Enables data to be exchanged during the initial TCP SYN
        "net.ipv4.tcp_fastopen" = 3;
        # Theoretical higher bandwidth + lower latency
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.core.default_qdisc" = "cake";
      })
    ];

    kernelModules = lib.lists.optional cfg.tcpOptimisations "tcp_bbr";
  };

  services.resolved = {
    enable = cfg.resolved.enable;
  };
}

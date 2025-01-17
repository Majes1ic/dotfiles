{ inputs
, outputs
, username
, hostname
, ...
}:
let
  homeManagerImpermanence = outputs.nixosConfigurations.${hostname}.config.home-manager.users.${username}.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  programs.zsh.shellAliases = {
    # List all files that will be lost on shutdown
    impermanence = ''sudo fd --base-directory / -a -tf -H -E "{$(findmnt -n -o TARGET --list -t zfs | sed 's/^.//' | tr '\n' ',' | sed 's/.$//'),proc,sys,run,dev,tmp,boot}"'';
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/tmp"
      "/var/lib/systemd"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
      "/var/db/sudo/lectured"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/machine-id"
      "/etc/adjtime"
    ];
    # Take this config from our home-manager module
    users.${username} = homeManagerImpermanence;
  };
}

{ config
, lib
, modulesPath
, ...
}: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    # Should set this to false after initial setup. May cause import to break
    # so be prepared to set zfs_force=1 kernel param in boot menu.
    zfs.forceImportRoot = true;
  };
  virtualisation.vmware.guest.enable = true;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

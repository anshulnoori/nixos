# x86_64 desktop — stub, not yet implemented.
# Uncomment the "desktop" entry in flake.nix when ready.
#
# Planned: CachyOS kernel, AMD/NVIDIA GPU drivers, hardware-configuration.nix
{...}: {
  imports = [
    # ./hardware-configuration.nix
    ../../users/mvs/default.nix
  ];

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  # boot.kernelPackages = pkgs.linuxPackages_cachyos;
  # hardware.opengl.enable = true;

  services.automatic-timezoned.enable = true;
  system.stateVersion = "25.11";
}

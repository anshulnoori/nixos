{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../users/mvs/default.nix
  ];

  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ./firmware;
    extractPeripheralFirmware = false;
  };

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  networking.hostName = "macbook";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  services.automatic-timezoned.enable = true;
  system.stateVersion = "25.11";
}

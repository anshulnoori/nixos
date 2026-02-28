{
  lib,
  config,
  ...
}: let
  c = config.lib.stylix.colors;

  # Limine term_palette: 8 semicolon-separated RRGGBB values (ANSI colors 0-7)
  # https://limine-bootloader.org/
  palette = "${c.base00};${c.base08};${c.base0B};${c.base0A};${c.base0D};${c.base0E};${c.base0C};${c.base05}";
  paletteBright = "${c.base03};${c.base08};${c.base0B};${c.base0A};${c.base0D};${c.base0E};${c.base0C};${c.base07}";
in {
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce false;

  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    extraConfig = ''
      interface_branding: NixOS
      interface_branding_color: 6

      term_background: ${c.base00}
      term_foreground: ${c.base05}
      term_foreground_bright: ${c.base07}
      term_background_bright: ${c.base01}

      term_palette: ${palette}
      term_palette_bright: ${paletteBright}
    '';
  };

  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs = {
      root = {
        SUBVOLUME = "/";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        NUMBER_LIMIT = "5";
        TIMELINE_LIMIT_HOURLY = "5";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "6";
        TIMELINE_LIMIT_YEARLY = "0";
      };
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        NUMBER_LIMIT = "5";
        TIMELINE_LIMIT_HOURLY = "5";
        TIMELINE_LIMIT_DAILY = "7";
      };
    };
  };
}

pkgs: {
  logo-font = pkgs.callPackage ./logo-font {
    fontFile = ../assets/logo.ttf;
  };

  waybar-indicators = pkgs.callPackage ./waybar-indicators {};

  # sddm-theme requires stylixColors injected at NixOS module eval time;
  # called directly in modules/nixos/desktop/default.nix via callPackage.

  # `theme <name>` — fast NixOS rebuild to switch the active Stylix theme.
  # Override at runtime: FLAKE_DIR=~/nixos theme gruvbox
  theme-switcher = pkgs.callPackage ./theme-switcher {
    flakeDir = "/etc/nixos";
    hostname = "macbook";
  };
}

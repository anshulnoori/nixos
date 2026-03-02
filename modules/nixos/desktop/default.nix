{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  themeWallpapers = {
    "catppuccin-latte" = ../../../assets/wallpapers/catppuccin-latte.jpg;
    "catppuccin" = ../../../assets/wallpapers/catppuccin.jpg;
    "ethereal" = ../../../assets/wallpapers/ethereal.jpg;
    "everforest" = ../../../assets/wallpapers/everforest.jpg;
    "flexoki-light" = ../../../assets/wallpapers/flexoki-light.jpg;
    "gruvbox" = ../../../assets/wallpapers/gruvbox.jpg;
    "hackerman" = ../../../assets/wallpapers/hackerman.jpg;
    "kanagawa" = ../../../assets/wallpapers/kanagawa.jpg;
    "matte-black" = ../../../assets/wallpapers/matte-black.jpg;
    "miasma" = ../../../assets/wallpapers/miasma.jpg;
    "nord" = ../../../assets/wallpapers/nord.jpg;
    "osaka-jade" = ../../../assets/wallpapers/osaka-jade.jpg;
    "ristretto" = ../../../assets/wallpapers/ristretto.jpg;
    "rose-pine" = ../../../assets/wallpapers/rose-pine.jpg;
    "tokyo-night" = ../../../assets/wallpapers/tokyo-night.jpg;
    "vantablack" = ../../../assets/wallpapers/vantablack.jpg;
    "white" = ../../../assets/wallpapers/white.jpg;
  };

  lightThemes = ["catppuccin-latte" "flexoki-light" "white"];

  theme = config.desktop.theme;
in {
  imports = [
    ./hyprland.nix
    inputs.stylix.nixosModules.stylix
  ];

  options.desktop.theme = lib.mkOption {
    type = lib.types.enum [
      "catppuccin-latte"
      "catppuccin"
      "ethereal"
      "everforest"
      "flexoki-light"
      "gruvbox"
      "hackerman"
      "kanagawa"
      "matte-black"
      "miasma"
      "nord"
      "osaka-jade"
      "ristretto"
      "rose-pine"
      "tokyo-night"
      "vantablack"
      "white"
    ];
    default = "gruvbox";
    description = ''
      Active Stylix theme. All 17 themes ship as base16 YAML files in
      nixos/themes/. Change this option and rebuild to switch permanently,
      or use `theme <name>` for a fast switch.
    '';
  };

  config = {
    stylix = {
      enable = true;

      base16Scheme = ../../../themes + "/${theme}.yaml";
      image = themeWallpapers.${theme};

      polarity =
        if builtins.elem theme lightThemes
        then "light"
        else "dark";

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        serif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sizes = {
          terminal = 13;
          applications = 12;
          desktop = 12;
          popups = 12;
        };
      };

      targets = {
        gtk.enable = true;
        qt.enable = true;
        # stylix.targets.sddm not available; themed via pkgs/sddm-theme instead.
      };
    };

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "nixos";
      # extraPackages is for Qt runtime plugins only, not theme discovery.
      # The theme package must be in systemPackages so SDDM finds share/sddm/themes/.
      extraPackages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    environment.systemPackages = [
      pkgs.theme-switcher
      (pkgs.callPackage ../../../pkgs/sddm-theme {
        stylixColors = config.lib.stylix.colors;
      })
    ];
  };
}

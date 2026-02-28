{
  pkgs,
  lib,
  inputs,
  ...
}: let
  pkgs-hypr = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [inputs.hyprland.nixosModules.default];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  hardware.graphics =
    {
      package = pkgs-hypr.mesa;
    }
    // lib.optionalAttrs pkgs.stdenv.isx86_64 {
      enable32Bit = true;
      package32 = pkgs-hypr.pkgsi686Linux.mesa;
    };

  environment.sessionVariables = {
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_STYLE_OVERRIDE = "kvantum";
    SDL_VIDEODRIVER = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    OZONE_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    hyprsunset
    hypridle
    hyprlock
    hyprpicker

    uwsm

    waybar

    mako
    swayosd

    swww

    hyprpolkitagent

    grim
    slurp
    satty

    playerctl
    pamixer

    brightnessctl

    python3Packages.terminaltexteffects

    xdg-desktop-portal-gtk
    xdg-utils

    gnome-themes-extra
    adwaita-icon-theme

    kdePackages.qt6ct
    libsForQt5.qt5ct
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
  ];
}

{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      _1password-gui
      _1password-cli

      mpv
      imv
      playerctl
      pamixer

      obsidian

      brave

      nautilus
      nautilus-python
      gnome-disk-utility

      grim
      slurp
      satty
      obs-studio

      bruno
      lazygit
      lazydocker
      bluetui
      wiremix

      opencode

      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      font-awesome

      xdg-utils
      xdg-user-dirs
      gnome-keyring
      seahorse
      gnome-calculator
      wl-clipboard
    ]
    ++ lib.optionals pkgs.stdenv.isx86_64 [
      spotify
      gpu-screen-recorder
    ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
    music = "${config.home.homeDirectory}/Music";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
  };

  xdg.configFile."brave-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
    --enable-wayland-ime
  '';

  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    exec = "obsidian --enable-wayland-ime %u";
    icon = "obsidian";
    terminal = false;
    categories = ["Office" "Productivity"];
    mimeType = ["x-scheme-handler/obsidian"];
  };

  xdg.configFile."xdg-terminals.list".text = ''
    ghostty.desktop
  '';
}

{pkgs, ...}: let
  defaultWallpaper = ../../../assets/wallpapers/gruvbox.jpg;

  setWallpaper = pkgs.writeShellScriptBin "set-wallpaper" ''
    WALLPAPER="''${1:-${builtins.toString defaultWallpaper}}"
    swww img "$WALLPAPER" \
      --transition-type grow \
      --transition-pos center \
      --transition-duration 1.5 \
      --transition-fps 60
  '';

  wallpapersDir = builtins.toString ../../../assets/wallpapers;

  cycleWallpaper = pkgs.writeShellScriptBin "cycle-wallpaper" ''
    mapfile -t ALL_WALLPAPERS < <(
      find "$HOME/Pictures/wallpapers" "${wallpapersDir}" \
        -maxdepth 1 \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) \
        2>/dev/null
    )
    if [ ''${#ALL_WALLPAPERS[@]} -gt 0 ]; then
      RANDOM_WALL="''${ALL_WALLPAPERS[RANDOM % ''${#ALL_WALLPAPERS[@]}]}"
      set-wallpaper "$RANDOM_WALL"
    fi
  '';
in {
  home.packages = [setWallpaper cycleWallpaper];

  home.file.".config/swww/wallpaper".text = builtins.toString defaultWallpaper;
}

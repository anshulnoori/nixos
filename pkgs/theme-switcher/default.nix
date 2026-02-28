{
  pkgs,
  lib,
  flakeDir,
  hostname,
}: let
  # https://github.com/danth/stylix — available themes (base16 YAML files in nixos/themes/)
  validThemes = [
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
  themeList = lib.concatStringsSep " " validThemes;
in
  pkgs.writeShellApplication {
    name = "theme";
    runtimeInputs = with pkgs; [coreutils gnused];
    text = ''
      usage() {
        cat >&2 <<EOF
      theme — switch the desktop theme (Stylix + fast NixOS rebuild)

      Usage:
        theme <name>     switch to <name> and rebuild
        theme --list     list all available themes
        theme --help     show this help

      Available themes:
        ${themeList}

      Notes:
        • Uses nixos-rebuild switch --fast (~30-60s, skips Nix recompile).
        • Waybar reloads its CSS automatically (reload_style_on_change).
        • To persist permanently: set desktop.theme = "<name>" in your
          host configuration.nix and rebuild normally.
        • Override flake path:  FLAKE_DIR=~/nixos theme gruvbox
        • Override hostname:    HOSTNAME=desktop theme gruvbox
      EOF
      }

      FLAKE_DIR="''${FLAKE_DIR:-${flakeDir}}"
      HOSTNAME_ARG="''${HOSTNAME:-${hostname}}"
      THEME_FILE="''${HOME}/.config/nixos/theme"

      if [ $# -eq 0 ]; then usage; exit 1; fi

      case "$1" in
        --list|-l)
          printf '%s\n' ${themeList}
          exit 0
          ;;
        --help|-h)
          usage; exit 0
          ;;
      esac

      THEME="$1"

      valid=0
      for t in ${themeList}; do
        if [ "$t" = "$THEME" ]; then valid=1; break; fi
      done
      if [ "$valid" -eq 0 ]; then
        echo "error: unknown theme '$THEME'" >&2
        echo "run 'theme --list' to see available themes" >&2
        exit 1
      fi

      mkdir -p "$(dirname "$THEME_FILE")"
      echo "$THEME" > "$THEME_FILE"
      echo "theme: $THEME"

      echo "rebuilding: nixos-rebuild switch --flake ''${FLAKE_DIR}#''${HOSTNAME_ARG} --fast"
      exec sudo nixos-rebuild switch \
        --flake "''${FLAKE_DIR}#''${HOSTNAME_ARG}" \
        --fast \
        --option pure-eval false
    '';
  }

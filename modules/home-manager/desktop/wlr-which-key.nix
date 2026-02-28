# https://github.com/nix-community/home-manager/pull/5677
# Vendored — PR not yet merged as of 2026-02.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.wlr-which-key;
  yamlFormat = pkgs.formats.yaml {};
in {
  options.programs.wlr-which-key = {
    enable = lib.mkEnableOption "wlr-which-key keymap manager";

    package = lib.mkPackageOption pkgs "wlr-which-key" {nullable = true;};

    commonSettings = lib.mkOption {
      type = lib.types.submodule {freeformType = yamlFormat.type;};
      default = {};
      description = ''
        Settings applied to every config under `configs`.
        See https://github.com/MaxVerevkin/wlr-which-key for all options.
      '';
      example = {
        font = "JetBrainsMono Nerd Font 12";
        anchor = "center";
        background = "#282828d0";
        color = "#ebdbb2";
        border = "#3c3836";
        border_width = 2;
        corner_r = 10;
        padding = 16;
        separator = " → ";
      };
    };

    configs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        freeformType = yamlFormat.type;

        options.menu = lib.mkOption {
          description = "Menu entries. Each key maps to { desc, cmd } or { desc, submenu }.";
          type = lib.types.attrs;
          default = {};
        };

        config = cfg.commonSettings;
      });

      default = {};
      description = ''
        Named configurations written to ~/.config/wlr-which-key/<name>.yaml.
        Invoke with `wlr-which-key <name>` (omit name to use `config.yaml`).
      '';
      example.config = {
        anchor = "center";
        menu = {
          p = {
            desc = "Power";
            submenu = {
              o = {cmd = "poweroff"; desc = "Off";};
              r = {cmd = "reboot"; desc = "Reboot";};
              s = {cmd = "systemctl suspend"; desc = "Sleep";};
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [cfg.package];

    xdg.configFile = lib.mapAttrs' (name: value:
      lib.nameValuePair "wlr-which-key/${name}.yaml" {
        source = yamlFormat.generate "wlr-which-key-${name}.yaml" value;
      })
    cfg.configs;
  };
}

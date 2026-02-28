{config, ...}: let
  c = config.lib.stylix.colors;
in {
  home.file.".config/swayosd/style.css".text = ''
    window {
      background: alpha(#${c.base00}, 0.9);
      border: 2px solid #${c.base0D};
      border-radius: 8px;
    }

    #container {
      padding: 10px 20px;
    }

    image {
      color: #${c.base05};
    }

    progressbar trough {
      background: #${c.base01};
      border-radius: 4px;
    }

    progressbar progress {
      background: #${c.base0D};
      border-radius: 4px;
    }

    label {
      color: #${c.base05};
      font-family: '${config.stylix.fonts.monospace.name}';
    }
  '';
}

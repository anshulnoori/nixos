{config, ...}: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.monospace.name;
in {
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
        grace = 0;
        hide_cursor = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 7;
          brightness = 0.6;
          contrast = 0.75;
        }
      ];

      animations.enabled = false;

      input-field = [
        {
          monitor = "";
          size = "650, 100";
          position = "0, 0";
          halign = "center";
          valign = "center";
          inner_color = "rgb(${c.base01})";
          outer_color = "rgb(${c.base05})";
          font_color = "rgb(${c.base05})";
          check_color = "rgb(${c.base0D})";
          fail_color = "rgb(${c.base08})";
          outline_thickness = 4;
          font_family = font;
          placeholder_text = "Enter Password";
          fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
          rounding = 0;
          shadow_passes = 0;
          fade_on_empty = false;
          dots_center = true;
        }
      ];

      auth.fingerprint.enabled = false;
    };
  };
}

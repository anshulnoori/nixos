{...}: let
  screensaverCmd = "ghostty --class=org.nixos.screensaver --fullscreen -e tte scattered";
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "sleep 1 && hyprctl dispatch dpms on";
        inhibit_sleep = 3;
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "pidof hyprlock || ${screensaverCmd}";
        }
        {
          timeout = 151;
          on-timeout = "loginctl lock-session";
          on-resume = "pkill -f org.nixos.screensaver || true";
        }
        {
          timeout = 330;
          on-timeout = "brightnessctl -sd '*::kbd_backlight' set 0";
          on-resume = "brightnessctl -rd '*::kbd_backlight'";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }
      ];
    };
  };
}

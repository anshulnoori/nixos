{config, ...}: let
  c = config.lib.stylix.colors;

  activeBorder = "rgba(${c.base0D}ee) rgba(${c.base0B}ee) 45deg";
  inactiveBorder = "rgba(${c.base02}aa)";
in {
  stylix.targets.hyprland.enable = false;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.variables = ["--all"];

    settings = {
      monitor = ",preferred,auto,2";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_STYLE_OVERRIDE,kvantum"
        "SDL_VIDEODRIVER,wayland,x11"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "NIXOS_OZONE_WL,1"
        "GDK_SCALE,2"
        "GUM_CONFIRM_PROMPT_FOREGROUND,6"
        "GUM_CONFIRM_SELECTED_FOREGROUND,0"
        "GUM_CONFIRM_SELECTED_BACKGROUND,2"
        "GUM_CONFIRM_UNSELECTED_FOREGROUND,7"
        "GUM_CONFIRM_UNSELECTED_BACKGROUND,8"
      ];

      exec-once = [
        "uwsm-app -- hypridle"
        "uwsm-app -- mako"
        "uwsm-app -- waybar"
        "uwsm-app -- swww-daemon"
        "uwsm-app -- swayosd-server"
        "uwsm-app -- walker --gapplication-service"
        "uwsm-app -- hyprsunset"
        "systemctl --user start hyprpolkitagent"
        "gnome-keyring-daemon --start --components=secrets,pkcs11"
        "systemctl --user import-environment $(env | cut -d'=' -f 1)"
        "dbus-update-activation-environment --systemd --all"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = activeBorder;
        "col.inactive_border" = inactiveBorder;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          special = true;
          brightness = 0.60;
          contrast = 0.75;
        };
      };

      group = {
        "col.border_active" = activeBorder;
        "col.border_inactive" = inactiveBorder;
        "col.border_locked_active" = "-1";
        "col.border_locked_inactive" = "-1";
        groupbar = {
          font_size = 12;
          font_family = "monospace";
          font_weight_active = "ultraheavy";
          font_weight_inactive = "normal";
          indicator_height = 0;
          indicator_gap = 5;
          height = 22;
          gaps_in = 5;
          gaps_out = 0;
          text_color = "rgb(ffffff)";
          text_color_inactive = "rgba(ffffff90)";
          "col.active" = "rgba(00000040)";
          "col.inactive" = "rgba(00000020)";
          gradients = true;
          gradient_rounding = 0;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 0, 0, ease"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master.new_status = "master";

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        anr_missed_pings = 3;
        on_focus_under_fullscreen = 1;
      };

      cursor = {
        hide_on_key_press = true;
        warp_on_change_workspace = 1;
      };

      binds.hide_special_on_workspace_change = true;
      xwayland.force_zero_scaling = true;
      ecosystem.no_update_news = true;

      # bind / bindl / bindel / bindm are in keybinds.nix

      windowrule = [
        "suppress_event maximize, match:class .*"
        "tag +default-opacity, match:class .*"
        "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
        "opacity 0.97 0.9, match:tag default-opacity"
        "fullscreen, match:class org.nixos.screensaver"
        "float, match:class org.nixos.screensaver"
        "tag -default-opacity, match:class org.nixos.screensaver"
        "float, match:class ^(dev.benschi.walker)$"
        "center, match:class ^(dev.benschi.walker)$"
        "stayfocused, match:class ^(dev.benschi.walker)$"
        "tag -default-opacity, match:class ^(dev.benschi.walker)$"
        "float, match:class ^(1Password)$"
        "center, match:class ^(1Password)$"
        "tag -default-opacity, match:class ^(1Password)$"
        "float, match:class ^(floating-terminal)$"
        "center, match:class ^(floating-terminal)$"
        "size 1000 600, match:class ^(floating-terminal)$"
        "tag -default-opacity, match:class ^(com.obsproject.Studio)$"
        "float, match:title ^(Picture-in-Picture)$"
        "pin, match:title ^(Picture-in-Picture)$"
        "keepaspectratio, match:title ^(Picture-in-Picture)$"
      ];
    };
  };

  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "ghostty";
  };
}

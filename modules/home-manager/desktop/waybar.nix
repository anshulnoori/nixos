{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  indicatorsDir = "${pkgs.waybar-indicators}/bin";
in {
  stylix.targets.waybar.enable = true;

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.main = {
      reload_style_on_change = true;
      layer = "top";
      position = "top";
      spacing = 0;
      height = 26;

      modules-left = ["custom/logo" "hyprland/workspaces"];
      modules-center = [
        "clock"
        "custom/nixos-update"
        "custom/screenrecording-indicator"
        "custom/idle-indicator"
        "custom/notification-silencing-indicator"
      ];
      modules-right = [
        "group/tray-expander"
        "bluetooth"
        "network"
        "pulseaudio"
        "cpu"
        "battery"
      ];

      "hyprland/workspaces" = {
        on-click = "activate";
        format = "{icon}";
        format-icons = {
          "default" = "";
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "0";
          active = "󱓻";
        };
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };
      };

      "custom/logo" = {
        format = "<span font='logo'>\ue900</span>";
        on-click = "walker";
        on-click-right = "ghostty";
        tooltip-format = "Open Launcher\n\nSuper + Space";
      };

      "custom/nixos-update" = {
        format = "";
        exec = "${indicatorsDir}/waybar-nixos-update-indicator";
        return-type = "json";
        signal = 7;
        interval = 21600;
        on-click = "ghostty --class=floating-terminal -e sh -c 'cd ~/nixos && nixos-rebuild switch --flake .#macbook'";
        tooltip-format = "NixOS update available — click to rebuild";
      };

      cpu = {
        interval = 5;
        format = "󰍛";
        on-click = "ghostty --class=floating-terminal -e btop";
        on-click-right = "ghostty";
      };

      clock = {
        format = "{:L%A %H:%M}";
        format-alt = "{:L%d %B W%V %Y}";
        tooltip = false;
      };

      network = {
        format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        format = "{icon}";
        format-wifi = "{icon}";
        format-ethernet = "󰀂";
        format-disconnected = "󰤮";
        tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
        tooltip-format-disconnected = "Disconnected";
        interval = 3;
        spacing = 1;
        on-click = "ghostty --class=floating-terminal -e iwctl";
      };

      battery = {
        format = "{capacity}% {icon}";
        format-discharging = "{icon}";
        format-charging = "{icon}";
        format-plugged = "";
        format-icons = {
          charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
          "default" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        format-full = "󰂅";
        tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
        tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
        interval = 5;
        states = {
          warning = 20;
          critical = 10;
        };
      };

      bluetooth = {
        format = "";
        format-off = "󰂲";
        format-disabled = "󰂲";
        format-connected = "󰂱";
        format-no-controller = "";
        tooltip-format = "Devices connected: {num_connections}";
        on-click = "ghostty --class=floating-terminal -e bluetui";
      };

      pulseaudio = {
        format = "{icon}";
        on-click = "ghostty --class=floating-terminal -e wiremix";
        on-click-right = "pamixer -t";
        tooltip-format = "Playing at {volume}%";
        scroll-step = 5;
        format-muted = "";
        format-icons = {
          headphone = "";
          headset = "";
          "default" = ["" "" ""];
        };
      };

      "group/tray-expander" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 600;
          children-class = "tray-group-item";
        };
        modules = ["custom/expand-icon" "tray"];
      };

      "custom/expand-icon" = {
        format = "";
        tooltip = false;
        on-scroll-up = "";
        on-scroll-down = "";
        on-scroll-left = "";
        on-scroll-right = "";
      };

      "custom/screenrecording-indicator" = {
        on-click = "pkill gpu-screen-recorder || notify-send 'Recording stopped'";
        exec = "${indicatorsDir}/waybar-screen-recording-indicator";
        signal = 8;
        return-type = "json";
        interval = 5;
      };

      "custom/idle-indicator" = {
        on-click = "if [ -f $XDG_RUNTIME_DIR/hypridle-inhibit ]; then rm $XDG_RUNTIME_DIR/hypridle-inhibit; else touch $XDG_RUNTIME_DIR/hypridle-inhibit; fi";
        exec = "${indicatorsDir}/waybar-idle-indicator";
        signal = 9;
        return-type = "json";
        interval = 10;
      };

      "custom/notification-silencing-indicator" = {
        on-click = "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb";
        exec = "${indicatorsDir}/waybar-notification-silencing-indicator";
        signal = 10;
        return-type = "json";
        interval = 10;
      };

      tray = {
        icon-size = 12;
        spacing = 17;
      };
    };

    style = ''
      * {
        background-color: @background;
        color: @foreground;

        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: '${config.stylix.fonts.monospace.name}';
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;
        color: @foreground;
        background-color: @background;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #workspaces button.active {
        color: #${c.base0D};
      }

      #cpu,
      #battery,
      #pulseaudio,
      #custom-logo,
      #custom-nixos-update {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #tray {
        margin-right: 16px;
      }

      #bluetooth {
        margin-right: 17px;
      }

      #network {
        margin-right: 13px;
      }

      #custom-expand-icon {
        margin-right: 18px;
      }

      tooltip {
        padding: 2px;
      }

      #custom-nixos-update {
        font-size: 10px;
      }

      #clock {
        margin-left: 8.75px;
      }

      .hidden {
        opacity: 0;
      }

      #custom-screenrecording-indicator,
      #custom-idle-indicator,
      #custom-notification-silencing-indicator {
        min-width: 12px;
        margin-left: 5px;
        margin-right: 0;
        font-size: 10px;
        padding-bottom: 1px;
      }

      #custom-screenrecording-indicator.active,
      #custom-idle-indicator.active,
      #custom-notification-silencing-indicator.active {
        color: #${c.base08};
      }

      #battery.warning {
        color: #${c.base0A};
      }

      #battery.critical {
        color: #${c.base08};
      }
    '';
  };

  home.packages = [pkgs.logo-font];
}

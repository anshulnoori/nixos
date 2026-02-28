{
  config,
  lib,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors;
  font = config.stylix.fonts.monospace.name;

  wkStyle = {
    font = "${font} 13";
    background = "#${c.base00}e6";
    color = "#${c.base05}";
    border = "#${c.base0D}";
    border_width = 2;
    corner_r = 8;
    padding = 18;
    separator = "  ";
    anchor = "center";
  };

  wk = name: "exec, ${lib.getExe pkgs.wlr-which-key} ${name}";

  mainMenu = {
    t = {
      desc = " Terminal";
      cmd = "ghostty";
    };
    b = {
      desc = " Browser";
      cmd = "brave";
    };
    e = {
      desc = " Editor";
      cmd = "ghostty -e nvim";
    };
    f = {
      desc = " Files";
      cmd = "nautilus";
    };
    m = {
      desc = " Music";
      cmd = "spotify";
    };
    p = {
      desc = " 1Password";
      cmd = "1password";
    };
    o = {
      desc = " Obsidian";
      cmd = "obsidian";
    };
    g = {
      desc = " Lazygit";
      cmd = "ghostty --class=floating-terminal -e lazygit";
    };
    d = {
      desc = " Docker";
      cmd = "ghostty --class=floating-terminal -e lazydocker";
    };
    r = {
      desc = " Bruno";
      cmd = "bruno";
    };
    s = {
      desc = " Screenshot";
      submenu = {
        s = {
          desc = "Region → clipboard";
          cmd = "grim -g \"$(slurp)\" - | wl-copy";
        };
        f = {
          desc = "Region → annotate";
          cmd = "grim -g \"$(slurp)\" - | satty --filename -";
        };
        w = {
          desc = "Window";
          cmd = "grim -g \"$(hyprctl activewindow -j | jq -r '.at,.size' | awk 'NR==1{x=$1;y=$2} NR==2{print x\",\"y\" \"$1\"x\"$2}')\" - | wl-copy";
        };
      };
    };
    Escape = {
      desc = " System";
      submenu = {
        l = {
          desc = " Lock";
          cmd = "hyprlock";
        };
        e = {
          desc = " Logout";
          cmd = "uwsm stop";
        };
        s = {
          desc = " Suspend";
          cmd = "systemctl suspend";
        };
        r = {
          desc = " Reboot";
          cmd = "systemctl reboot";
        };
        q = {
          desc = " Power off";
          cmd = "systemctl poweroff";
        };
        c = {
          desc = " Reload config";
          cmd = "hyprctl reload";
        };
      };
    };
  };

  windowMenu = {
    q = {
      desc = " Kill";
      cmd = "hyprctl dispatch killactive";
    };
    f = {
      desc = " Float";
      cmd = "hyprctl dispatch togglefloating";
    };
    m = {
      desc = " Maximize";
      cmd = "hyprctl dispatch fullscreen 1";
    };
    F = {
      desc = " Fullscreen";
      cmd = "hyprctl dispatch fullscreen 0";
    };
    g = {
      desc = " Toggle group";
      cmd = "hyprctl dispatch togglegroup";
    };
    s = {
      desc = " Scratchpad";
      cmd = "hyprctl dispatch movetoworkspace special:magic";
    };
    S = {
      desc = " Show scratch";
      cmd = "hyprctl dispatch togglespecialworkspace magic";
    };
    p = {
      desc = " Pin";
      cmd = "hyprctl dispatch pin";
    };
    c = {
      desc = " Centre";
      cmd = "hyprctl dispatch centerwindow";
    };
  };
in {
  programs.wlr-which-key = {
    enable = true;
    commonSettings = wkStyle;
    configs = {
      config.menu = mainMenu;
      windows.menu = windowMenu;
    };
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER,       Space,  ${wk "config"}"
      "SUPER,       W,      ${wk "windows"}"
      "SUPER CTRL,  Space,  exec, walker"

      "SUPER, H, movefocus, l"
      "SUPER, J, movefocus, d"
      "SUPER, K, movefocus, u"
      "SUPER, L, movefocus, r"

      "SUPER, left,  movefocus, l"
      "SUPER, down,  movefocus, d"
      "SUPER, up,    movefocus, u"
      "SUPER, right, movefocus, r"

      "SUPER SHIFT, H, movewindow, l"
      "SUPER SHIFT, J, movewindow, d"
      "SUPER SHIFT, K, movewindow, u"
      "SUPER SHIFT, L, movewindow, r"

      "SUPER SHIFT, left,  movewindow, l"
      "SUPER SHIFT, down,  movewindow, d"
      "SUPER SHIFT, up,    movewindow, u"
      "SUPER SHIFT, right, movewindow, r"

      "SUPER CTRL, H, resizeactive, -40 0"
      "SUPER CTRL, J, resizeactive, 0 40"
      "SUPER CTRL, K, resizeactive, 0 -40"
      "SUPER CTRL, L, resizeactive, 40 0"

      "SUPER CTRL, left,  resizeactive, -40 0"
      "SUPER CTRL, down,  resizeactive, 0 40"
      "SUPER CTRL, up,    resizeactive, 0 -40"
      "SUPER CTRL, right, resizeactive, 40 0"

      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"
      "SUPER, 0, workspace, 10"

      "SUPER SHIFT, 1, movetoworkspace, 1"
      "SUPER SHIFT, 2, movetoworkspace, 2"
      "SUPER SHIFT, 3, movetoworkspace, 3"
      "SUPER SHIFT, 4, movetoworkspace, 4"
      "SUPER SHIFT, 5, movetoworkspace, 5"
      "SUPER SHIFT, 6, movetoworkspace, 6"
      "SUPER SHIFT, 7, movetoworkspace, 7"
      "SUPER SHIFT, 8, movetoworkspace, 8"
      "SUPER SHIFT, 9, movetoworkspace, 9"
      "SUPER SHIFT, 0, movetoworkspace, 10"

      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up,   workspace, e-1"
    ];

    bindl = [
      ", XF86AudioMute,        exec, pamixer -t"
      ", XF86AudioPlay,        exec, playerctl play-pause"
      ", XF86AudioPrev,        exec, playerctl previous"
      ", XF86AudioNext,        exec, playerctl next"
    ];

    bindel = [
      ", XF86AudioRaiseVolume,  exec, swayosd-client --output-volume raise"
      ", XF86AudioLowerVolume,  exec, swayosd-client --output-volume lower"
      ", XF86MonBrightnessUp,   exec, swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
    ];

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
  };
}

{
  writeShellScriptBin,
  symlinkJoin,
}: let
  screen-recording = writeShellScriptBin "waybar-screen-recording-indicator" ''
    #!/usr/bin/env bash
    if pgrep -x "gpu-screen-recorder" > /dev/null 2>&1; then
      echo '{"text":"","class":"active","tooltip":"Screen recording active"}'
    else
      echo '{"text":"","class":"","tooltip":"Screen recording"}'
    fi
  '';

  idle = writeShellScriptBin "waybar-idle-indicator" ''
    #!/usr/bin/env bash
    FLAG="$XDG_RUNTIME_DIR/hypridle-inhibit"
    if [ -f "$FLAG" ]; then
      echo '{"text":"󰛐","class":"active","tooltip":"Idle lock disabled"}'
    else
      echo '{"text":"","class":"","tooltip":"Idle lock enabled"}'
    fi
  '';

  notification-silencing = writeShellScriptBin "waybar-notification-silencing-indicator" ''
    #!/usr/bin/env bash
    if makoctl mode | grep -q "do-not-disturb"; then
      echo '{"text":"󰂛","class":"active","tooltip":"Notifications silenced"}'
    else
      echo '{"text":"","class":"","tooltip":"Notifications active"}'
    fi
  '';

  nixos-update = writeShellScriptBin "waybar-nixos-update-indicator" ''
    #!/usr/bin/env bash
    LAST_CHECK="$XDG_RUNTIME_DIR/nixos-update-check"
    if [ -f "$LAST_CHECK" ]; then
      cat "$LAST_CHECK"
    else
      echo '{"text":"","class":"","tooltip":""}'
    fi
  '';
in
  symlinkJoin {
    name = "waybar-indicators";
    paths = [
      screen-recording
      idle
      notification-silencing
      nixos-update
    ];
  }

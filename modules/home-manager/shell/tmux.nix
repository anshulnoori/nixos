{pkgs, ...}: {
  stylix.targets.tmux.enable = true;

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 50000;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    aggressiveResize = true;

    plugins = [
      {
        plugin = pkgs.tmuxPlugins.tmux-which-key;
        extraConfig = ''
          set -g @tmux-which-key-xdg-enable 1
          set -g @tmux-which-key-disable-autobuild 1
        '';
      }
    ];

    extraConfig = ''
      unbind C-b
      set -g prefix Space
      bind Space send-prefix

      setw -g pane-base-index 1
      set -g renumber-windows on

      set -g status-position top

      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",ghostty:RGB"
      set -g focus-events on

      set -g set-titles on
      set -g set-titles-string "#W"
      set -g allow-rename off
    '';
  };

  # https://github.com/alexwforsythe/tmux-which-key
  xdg.configFile."tmux/plugins/tmux-which-key/config.yaml".text = ''
    command_alias_start_index: 200

    keybindings:

      # ── Splits ────────────────────────────────────────────────────────────
      # - key: "|"
      #   name: "split right"
      #   command: "split-window -h -c '#{pane_current_path}'"
      # - key: "-"
      #   name: "split down"
      #   command: "split-window -v -c '#{pane_current_path}'"
      # - key: "c"
      #   name: "new window"
      #   command: "new-window -c '#{pane_current_path}'"

      # ── Pane focus ────────────────────────────────────────────────────────
      # - key: "h"
      #   name: "focus left"
      #   command: "select-pane -L"
      # - key: "j"
      #   name: "focus down"
      #   command: "select-pane -D"
      # - key: "k"
      #   name: "focus up"
      #   command: "select-pane -U"
      # - key: "l"
      #   name: "focus right"
      #   command: "select-pane -R"

      # ── Resize ────────────────────────────────────────────────────────────
      # - key: "r"
      #   name: "resize"
      #   items:
      #     - key: "h"
      #       name: "← shrink"
      #       command: "resize-pane -L 5"
      #     - key: "j"
      #       name: "↓ grow"
      #       command: "resize-pane -D 5"
      #     - key: "k"
      #       name: "↑ shrink"
      #       command: "resize-pane -U 5"
      #     - key: "l"
      #       name: "→ grow"
      #       command: "resize-pane -R 5"

      # ── Sessions ──────────────────────────────────────────────────────────
      # - key: "s"
      #   name: "sessions"
      #   command: "choose-tree -s"

      # ── Copy mode ─────────────────────────────────────────────────────────
      # - key: "["
      #   name: "copy mode"
      #   command: "copy-mode"

      # ── Config reload ─────────────────────────────────────────────────────
      # - key: "R"
      #   name: "reload config"
      #   command: "source-file ~/.config/tmux/tmux.conf"
  '';
}

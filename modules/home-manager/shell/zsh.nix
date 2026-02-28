{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";

    history = {
      size = 50000;
      save = 50000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    completionInit = ''
      autoload -U compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons --git";
      la = "eza -la --icons --git --all";
      lt = "eza --tree --icons --level=2";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";

      vim = "nvim";
      vi = "nvim";
      v = "nvim";

      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gpl = "git pull";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate";
      lg = "lazygit";

      lzd = "lazydocker";
      dc = "docker compose";
      dcu = "docker compose up -d";
      dcd = "docker compose down";
      dcl = "docker compose logs -f";

      uvx = "uv tool run";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "~" = "cd ~";

      nr = "nixos-rebuild switch --flake .";
      nd = "nix develop";
      ns = "nix shell";
      nb = "nix build";
      nf = "nix flake";

      ip = "ip --color=auto";
      df = "df -h";
      du = "dust";
    };

    initContent = ''
      eval "$(zoxide init zsh --cmd cd)"

      if command -v fzf &>/dev/null; then
        source <(fzf --zsh)
      fi

      function zle-keymap-select {
        if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
          echo -ne '\e[1 q'
        elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ $KEYMAP = \'\' ]] || [[ $1 = 'beam' ]]; then
          echo -ne '\e[5 q'
        fi
      }
      zle -N zle-keymap-select

      echo -ne '\e[5 q'
      preexec() { echo -ne '\e[5 q'; }

      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd '^e' edit-command-line
      bindkey -M viins '^e' edit-command-line

      bindkey '^l' clear-screen

      bindkey '^r' history-incremental-search-backward

      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_STATE_HOME="$HOME/.local/state"

      mkdir -p "$XDG_CACHE_HOME/zsh"
    '';
  };

  home.packages = with pkgs; [
    eza
    bat
    ripgrep
    fd
    fzf
    zoxide
    dust
    btop
    fastfetch
    jq
    gum
    imagemagick
  ];
}

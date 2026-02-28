{...}: {
  imports = [
    ./desktop/wlr-which-key.nix
    ./desktop/keybinds.nix
    ./desktop/hyprland.nix
    ./desktop/waybar.nix
    ./desktop/walker.nix
    ./desktop/hypridle.nix
    ./desktop/hyprlock.nix
    ./desktop/mako.nix
    ./desktop/swayosd.nix
    ./desktop/swww.nix
    ./shell/zsh.nix
    ./shell/starship.nix
    ./shell/tmux.nix
    ./apps/ghostty.nix
    ./apps/git.nix
    ./apps/direnv.nix
    ./apps/packages.nix
    ./neovim/default.nix
  ];
}

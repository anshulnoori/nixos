{config, ...}: {
  stylix.targets.ghostty.enable = true;

  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = false;
      window-padding-x = 12;
      window-padding-y = 10;
      background-opacity = 0.95;
      background-blur-radius = 0;
      cursor-style = "bar";
      cursor-style-blink = true;
      scrollback-limit = 10000;
      shell-integration = "zsh";
      shell-integration-features = "cursor,sudo,title";
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-trim-trailing-spaces = true;
      gtk-tabs-location = "hidden";
      font-size = config.stylix.fonts.sizes.terminal;
      bold-is-bright = false;
      mouse-hide-while-typing = true;
      focus-follows-mouse = false;
    };
  };
}

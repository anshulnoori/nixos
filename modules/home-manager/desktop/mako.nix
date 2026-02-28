{...}: {
  stylix.targets.mako.enable = true;

  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      default-timeout = 5000;
      width = 420;
      outer-margin = 20;
      padding = "10,15";
      border-size = 2;
      max-icon-size = 32;
      "[mode=do-not-disturb]" = {
        invisible = 1;
      };
      "[mode=do-not-disturb app-name=notify-send]" = {
        invisible = 0;
      };
      "[urgency=critical]" = {
        default-timeout = 0;
        layer = "overlay";
      };
      "[app-name=Spotify]" = {
        invisible = 1;
      };
    };
  };
}

{inputs, ...}: {
  imports = [
    inputs.self.homeModules.default
    inputs.nixvim.homeModules.nixvim
    inputs.walker.homeManagerModules.walker
  ];

  home = {
    username = "mvs";
    homeDirectory = "/home/mvs";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # https://nixos.org/manual/nixos/unstable/release-notes.html
  home.stateVersion = "25.11";
}

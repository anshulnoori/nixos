{pkgs, ...}: {
  users.users.mvs = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}

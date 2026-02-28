{...}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "anshulnoori";
        email = "anshulnoori@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      diff.colorMoved = "default";
      rerere.enabled = true;

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --oneline --graph --decorate --all";
        undo = "reset HEAD~1 --mixed";
        amend = "commit --amend --no-edit";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };
}

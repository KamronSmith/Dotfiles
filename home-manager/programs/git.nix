{ config, inputs, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Kamron";
    userEmail = "kamrosmith@gmail.com";
    extraConfig = {
      gpg = {
        "ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
      
      pull = {
        rebase = false;
      };
      
      color = {
        ui = "auto";
      };

      push = {
        default = "simple";
      };

      core = {
        whitespace = "trailing-space,space-before-tab";
      };

      init = {
        defaultBranch = "main";
      };
    };
  };
}

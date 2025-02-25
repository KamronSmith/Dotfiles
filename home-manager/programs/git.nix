{ config, inputs, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Kamron";
    userEmail = "kamrosmith@gmail.com";
    extraConfig = {
      gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      pull.rebase = false;
    };
  };
}

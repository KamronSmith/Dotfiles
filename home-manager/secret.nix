{ config, lib, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
        Host *
             IdentityAgent "~/.1password/agent.sock"
      '';
  };

  programs.git = {
    extraConfig = {
      gpg = {
        format = "ssh";
      };
      
      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };
      
      commit = {
        gpgsign = true;
      };
      
      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK87KQlTvH1gcGwsE0gW0wo7Er26Pgy3m7UDP+oTL7yC";
      };
    };
  };

  programs.awscli = {
    enable = true;
    credentials = {
      "default" = {
        "credential_process" = "${pkgs._1password}/bin/op";
      };
    };
  };
}

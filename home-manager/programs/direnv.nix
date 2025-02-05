{ pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      config = {
        hideEnvDiff = true;
        strictEnv = true;
      };
    };
  };
}

{ pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = with pkgs; (
      (emacsPackagesFor emacs).emacsWithPackages (
        epkgs: [ epkgs.jinx epkgs.vterm ]
      )
    );
    defaultEditor = true;
    socketActivation.enable = true;
    startWithUserSession = true;
    client.enable = true; 
  };
}

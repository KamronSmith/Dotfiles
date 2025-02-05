{ pkgs, ... }:

{
  programs.emacs = {
    package = pkgs.emacs30;
  };
}

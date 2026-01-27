{ pkgs, ... }:
{
  home.packages = [ pkgs.pfetch-rs ];
  home.sessionVariables = {
    PF_COL1 = 2;
    PF_INFO = "ascii title os kernel uptime pkgs palette";
  };
}

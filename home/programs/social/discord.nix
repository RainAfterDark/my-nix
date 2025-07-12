{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];
  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
  };
}

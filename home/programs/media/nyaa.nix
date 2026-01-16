{ pkgs, ... }:
{
  xdg.configFile."nyaa/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    download_client = "RunCommand";
    client.command = {
      cmd = "mpv {torrent}";
      shell_cmd = "sh -c";
    };
  };

  home.packages = with pkgs; [ nyaa ];
}

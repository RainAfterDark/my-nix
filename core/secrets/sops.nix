{
  inputs,
  pkgs,
  username,
  ...
}:
{
  # imports = [ inputs.sops-nix.nixosModules.sops ];
  # environment.systemPackages = with pkgs; [
  #   age # for keygen
  #   sops # for encyrption
  # ];

  # ## Secrets
  # sops = {
  #   age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  #   defaultSopsFile = ./secrets.yaml;
  #   secrets = {
  #     tailscale-authkey = {
  #       owner = "root";
  #       mode = "0400";
  #     };
  #     github-access-token = {
  #       owner = "root";
  #       mode = "0400";
  #     };
  #   };
  # };
}

{ ... }:
{
  security.rtkit.enable = true;
  security.sudo.enable = true;
  # unlock GPG keyring on login
  security.pam.services.greetd.enableGnomeKeyring = true;
}

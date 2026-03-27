{ username, ... }:
{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.alsa.enablePersistence = true;

  ## RT Audio Priority
  security.rtkit.enable = true;

  users.users.${username}.extraGroups = [
    "audio"
    "pipewire"
  ];
}

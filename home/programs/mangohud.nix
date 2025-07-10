{ pkgs, ... }:
{
  home.packages = [ pkgs.mangohud ];

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    gpu_temp
    cpu_temp
    gpu_core_clock
    gpu_memory_clock
    cpu_mhz
    vram
    ram
    fps
    frametime
  '';
}

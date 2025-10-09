{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  services.minecraft-servers =
    let
      fabric-1_21_9 = pkgs.vanillaServers.vanilla.overrideAttrs (oldAttrs: {
        src = ./fabric-server-mc.1.21.9-loader.0.17.2-launcher.1.1.0.jar;
      });
    in
    {
      enable = true;
      eula = true;
      openFirewall = true;
      dataDir = "/srv";
      managementSystem = {
        tmux.enable = true;
        systemd-socket.enable = false;
      };
      user = username;
      group = "users";
      servers.csmc = {
        enable = true;
        autoStart = false;
        restart = "no";
        package = fabric-1_21_9;
        symlinks = {
          mods = ./mods;
        };
        jvmOpts = "-Xms4096M -Xmx4096M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20";
      };
    };
}

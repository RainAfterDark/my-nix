{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/srv";
    managementSystem = {
      tmux.enable = true;
      systemd-socket.enable = false;
    };
    servers.csmc = {
      enable = true;
      autoStart = false;
      restart = "no";
      package = pkgs.fabricServers.fabric-1_21_8;
      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Appleskin = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/YAjCkZ29/appleskin-fabric-mc1.21.6-3.0.6.jar";
              sha512 = "e36c78b036676b3fac1ec3edefdcf014ccde8ce65fd3e9c1c2f9a7bbc7c94185168a2cd6c8c27564e9204cd892bfbaae9989830d1acea83e6f37187b7a43ad7d";
            };
            Crater-Lib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Nn8Wasaq/versions/o3hiSSue/CraterLib-Fabric-1.21.6-2.1.5.jar";
              sha512 = "b5600ddd724921fd9227e105131f67aca2d7e208e8e8d226ddcc4a3087f5edfced101d72a91dc8560f8af25cffe1e8ee69c123853612e9e987ea1134e7fecc40";
            };
            Entity-View-Distance = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ihnBJ6on/versions/6HImwLc1/entity-view-distance-1.5.0%2B1.21.6.jar";
              sha512 = "bce69873a07f3efd2feabd53ed802c358d30f6d21c3dbe692bf2073697cd05c96ddd8579c9e36c7632b792deebe40baa2f1efaddda589dad427b94a366db09cf";
            };
            Fabric-API = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/X2hTodix/fabric-api-0.129.0%2B1.21.8.jar";
              sha512 = "471babff84b36bd0f5051051bc192a97136ba733df6a49f222cb67a231d857eb4b1c5ec8dea605e146f49f75f800709f8836540a472fe8032f9fbd3f6690ec3d";
            };
            Fabric-Language-Kotlin = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/mccDBWqV/fabric-language-kotlin-1.13.4%2Bkotlin.2.2.0.jar";
              sha512 = "26b6b4499bf872ebc2c666227b2ed721ce0e33a8e8b19632971250e5cb6e0b9f35aef15a07ce53cf4755285d9d38c4e05a5f1357bad544d44b9e30b87c0a0055";
            };
            Ferrite-Core = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
              sha512 = "131b82d1d366f0966435bfcb38c362d604d68ecf30c106d31a6261bfc868ca3a82425bb3faebaa2e5ea17d8eed5c92843810eb2df4790f2f8b1e6c1bdc9b7745";
            };
            JLine = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9mnPo3ZV/versions/7oc0agle/jline4mcdsrv-0.6.4.jar";
              sha512 = "a2bcd1d1b597c499f93b2831e7cb53a8bb6e4ad2f0eaa1070f16616611feba3af980b50767f7b9b3beed0d889bc22698a4703f9f11e2784279ee0e0713276217";
            };
            Ledger = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/LVN9ygNV/versions/f3h7no4G/ledger-1.3.12.jar";
              sha512 = "f92e67f549abb7cd82f5cd2ade1830b50c312673b95ee4ae73bb455f9fe4b61442f90eb30b6515f16260945ca8f5dcf63a9728959bb5b454b3d59485a5ea29be";
            };
            Lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/pDfTqezk/lithium-fabric-0.18.0%2Bmc1.21.8.jar";
              sha512 = "6c69950760f48ef88f0c5871e61029b59af03ab5ed9b002b6a470d7adfdf26f0b875dcd360b664e897291002530981c20e0b2890fb889f29ecdaa007f885100f";
            };
            Servux = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/3LUmmXJf/servux-fabric-1.21.8-0.7.3.jar";
              sha512 = "63f49e81fc004305cfba9e1228e2129b2ac0423f56fd7a4b23f6f591f409d2d5986a7642bdc5ee262fa87c8cbb4f052dd55ddf8274219d9693b379059adf4bfa";
            };
            Simple-Discord-Link = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Sh0YauEf/versions/zX9ZfDNw/SimpleDiscordLink-Universal-3.3.2.jar";
              sha512 = "495d5c14cc5e38089bb842cb3e92d352c805573edea4d2c5bac5da4eedff3563768a6ce9f0dbbe9633c2086e0796ccb4dc922206568069ab0bf9591f52442ac9";
            };
            String-Duper-Fix-Remover = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/O9TFn6US/versions/jU0B1K0n/stringduperfix-1.4.jar";
              sha512 = "91fb259fc19edb0f055b8b5723675f6f70ff07b39a05e650d0381d8c4434b1e00f62218f0836b6c19cdf3dcdb9940b7225223166dc92b93aaa1f8ecb3e104ec4";
            };
            TabTPS = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/w0oIAEFo/tabtps-fabric-mc1.21.8-1.3.28.jar";
              sha512 = "b29e19114efdadeadf5fedbf5b743aa35f36ab6fa8c32a1cbaa6591106677a3163801ba8010142899822298fefebb9621aa5db54db49ecc58719b7ef5dcbde85";
            };
          }
        );
      };
      jvmOpts = "-Xms4096M -Xmx4096M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20";
    };
  };
}

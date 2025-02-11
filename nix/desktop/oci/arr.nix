{
  config,
  pkgs,
  image,
  secrets,
  ...
}: {
  #systemd requires gluetun-network
  systemd.services."docker-network-gluetun_network" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f gluetun_network";
    };
    script = ''
      docker network inspect gluetun_network || docker network create gluetun_network
    '';
    wantedBy = ["docker-gluetun.service"];
  };

  virtualisation.oci-containers.containers = {
    gluetun = {
      image = "${image.gluetun}";
      ports = [
        #Qbittorrent
        "${secrets.tsip}:8079:8079"
        "46764:46764"
      ];
      extraOptions = [
        "--network=gluetun_network"
        "--cap-add=NET_ADMIN"
      ];
      environment = {
        VPN_SERVICE_PROVIDER = "airvpn";
        VPN_TYPE = "wireguard";
        WIREGUARD_PRIVATE_KEY = "${secrets.gluetun.private_key}";
        WIREGUARD_PRESHARED_KEY = "${secrets.gluetun.preshared_key}";
        WIREGUARD_ADDRESSES = "${secrets.gluetun.ip}";
        SERVER_COUNTRIES = "Switzerland,Sweden";
        FIREWALL_VPN_INPUT_PORTS = "46764";
        #DOT_PROVIDERS = "quad9,quadrant,google,cloudflare";
        DOT = "off";
        DNS_ADDRESS = "10.128.0.1";
      };
      labels = {
        "wud.tag.include" = "v[0-9].*";
      };
    };

    qbittorrent = {
      dependsOn = ["gluetun"];
      image = "${image.qbittorrent}";
      extraOptions = ["--network=container:gluetun"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        QBT_WEBUI_PORT = "8079";
        TORRENTING_PORT = "46764";
        TZ = "${config.time.timeZone}";
      };
      volumes = [
        "/docker/arr/qbittorrent:/config"
        "/media/data/torrents:/data/torrents"
      ];
      labels = {
        "wud.tag.exclude" = "linux";
      };
    };
    gluetun2 = {
      image = "${image.gluetun}";
      ports = [
        #qbpt
        "${secrets.tsip}:8081:8081"
        "21276:21276"
      ];
      extraOptions = [
        "--network=gluetun_network"
        "--cap-add=NET_ADMIN"
      ];
      environment = {
        VPN_SERVICE_PROVIDER = "airvpn";
        VPN_TYPE = "wireguard";
        WIREGUARD_PRIVATE_KEY = "${secrets.gluetun2.private_key}";
        WIREGUARD_PRESHARED_KEY = "${secrets.gluetun2.preshared_key}";
        WIREGUARD_ADDRESSES = "${secrets.gluetun2.ip}";
        SERVER_COUNTRIES = "Switzerland,Sweden";
        FIREWALL_VPN_INPUT_PORTS = "21276";
        #DOT_PROVIDERS = "quad9,quadrant,google,cloudflare";
        DOT = "off";
        DNS_ADDRESS = "10.128.0.1";
      };
      labels = {
        "wud.tag.include" = "v[0-9].*";
      };
    };
    qbpt = {
      dependsOn = ["gluetun"];
      image = "${image.qbpt}";
      extraOptions = ["--network=container:gluetun2"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        QBT_WEBUI_PORT = "8081";
        TORRENTING_PORT = "21276";
        TZ = "${config.time.timeZone}";
      };
      volumes = [
        "/docker/arr/qbpt:/config"
        "/media/data/torrents:/data/torrents"
      ];
      labels = {
        "wud.tag.exclude" = "linux";
      };
    };

    radarr = {
      image = "${image.radarr}";
      #dependsOn = [ "gluetun" ];
      #extraOptions = ["--network=container:gluetun"];
      extraOptions = ["--network=gluetun_network"];
      ports = ["${secrets.tsip}:7878:7878"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "${config.time.timeZone}";
      };
      volumes = [
        "/docker/arr/radarr:/config"
        "/media/data:/data"
      ];
      labels = {
        "wud.tag.include" = "[0-9]\\.[0-9]";
        "wud.tag.exclude" = "(arm)|(amd)|(nightly)|(version)|(-)";
      };
    };

    sonarr = {
      image = "${image.sonarr}";
      extraOptions = ["--network=gluetun_network"];
      ports = ["${secrets.tsip}:8989:8989"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "${config.time.timeZone}";
      };
      volumes = [
        "/docker/arr/sonarr:/config"
        "/media/data:/data"
      ];
      labels = {
        "wud.tag.include" = "[0-9]\\.[0-9]";
        "wud.tag.exclude" = "(arm)|(amd)|(nightly)|(version)|(-)|(5\\.14)";
      };
    };

    prowlarr = {
      image = "${image.prowlarr}";
      #dependsOn = [ "gluetun" ];
      #extraOptions = ["--network=container:gluetun"];
      extraOptions = ["--network=gluetun_network"];
      ports = ["${secrets.tsip}:9696:9696"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "${config.time.timeZone}";
      };
      volumes = [
        "/docker/arr/prowlarr:/config"
      ];
      labels = {
        "wud.tag.exclude" = "(arm)|(amd)|(nightly)|develop";
      };
    };

    #jellyfin & jellyseer in tailscale

    jellyscale = {
      image = "${image.jellyscale}";
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--device=/dev/net/tun:/dev/net/tun:rwm"
        "--network=gluetun_network"
      ];
      environment = {
        TS_AUTHKEY = "${secrets.tskey}";
        TS_EXTRA_ARGS = "--advertise-tags=tag:docker";
        TS_STATE_DIR = "/var/lib/tailscale";
        TS_HOSTNAME = "swag";
      };
      volumes = [
        "/docker/jellyscale:/var/lib/tailscale"
      ];
      labels = {
        "wud.tag.exclude" = "unstable";
      };
    };

    jellyseerr = {
      image = "${image.jellyseerr}";
      dependsOn = ["jellyscale"];
      extraOptions = ["--network=container:jellyscale"];
      #extraOptions = [ "--network=gluetun_network" ];
      #ports = [ "5055:5055" ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "${config.time.timeZone}";
      };
      volumes = [
        "/docker/arr/jellyseerr:/app/config"
      ];
      labels = {
        "wud.tag.exclude" = "preview|arm";
      };
    };

    jellyfin = {
      image = "${image.jellyfin}";
      extraOptions = ["--network=container:jellyscale"];
      dependsOn = ["jellyscale"];
      #extraOptions = [ "--network=gluetun_network" ];
      #ports = [ "8096:8096/tcp" "8920:8920/tcp"
      #  "1900:1900/udp" "7359:7359/udp" ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "${config.time.timeZone}";
      };
      volumes = [
        "/docker/arr/jellyfin:/config"
        "/media/data/media:/media:rw"
      ];
      labels = {
        "wud.tag.include" = "[0-9]\\.[0-9]";
        "wud.tag.exclude" = "(arm)|(amd)|unstable";
      };
    };
  };
}

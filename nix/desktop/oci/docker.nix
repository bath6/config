{
  config,
  image,
  secrets,
  ...
}: {
  imports = [
    ./arr.nix
    ./hoarder.nix
    #../../../secrets/test.nix
  ];

  #future containers??
  #calibre web
  #linkwarden
  #prometheus+grafana?
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    homepage = {
      image = "${image.homepage}";
      ports = ["${secrets.tsip}:2999:3000"];
      extraOptions = [
        "--network=gluetun_network"
      ];
      environment = {
        TZ = "${config.time.timeZone}";
        HOMEPAGE_ALLOWED_HOSTS = "desktop:2999";
      };
      volumes = [
        "/docker/homepage:/app/config"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      labels = {
        "wud.tag.include" = "v[0-9]";
        "wud.tag.exclude" = "feature";
        "traefik.http.routers.homepage.rule" = "PathPrefix(`/homepage`)";
        "traefik.enable" = "true";
      };
    };
    pihole = {
      image = "${image.pihole}";
      extraOptions = [
        "--network=gluetun_network"
      ];
      ports = [
        "${secrets.tsip}:53:53/tcp"
        "${secrets.tsip}:53:53/udp"
        "${secrets.tsip}:67:67/udp"
        "${secrets.tsip}:80:80/tcp"
      ];
      volumes = [
        "/home/jacob/docker/pihole/pihole:/etc/pihole"
        "/home/jacob/docker/pihole/dnsmasq:/etc/dnsmasq.d"
      ];
    };
    mealie = {
      image = "${image.mealie}";
      ports = ["${secrets.tsip}:9000:9000"];
      #extraOptions = ["--network=host"];
      extraOptions = [
        "--network=gluetun_network"
      ];
      environment = {
        ALLOW_SIGNUP = "true";
        PUID = "1000";
        PGID = "100";
        TZ = "${config.time.timeZone}";
      };
      volumes = [
        "/home/jacob/docker/mealie:/app/data"
      ];
      labels = {
        "traefik.http.routers.mealie.rule" = "PathPrefix(`/mealie`)";
        "traefik.enable" = "true";
      };
    };

    wud = {
      image = "${image.wud}";
      ports = ["${secrets.tsip}:3001:3001"];
      extraOptions = [
        "--network=gluetun_network"
      ];
      environment = {
        WUD_SERVER_PORT = "3001";
      };
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      labels = {
        "wud.tag.include" = "[0-9]\\.[0-9]";
      };
    };

    scrutiny = {
      image = "${image.scrutiny}";
      extraOptions = [
        "--cap-add=SYS_RAWIO"
        "--cap-add=SYS_ADMIN"
        "--device=/dev/nvme0n1:/dev/nvme0n1:r"
        "--network=gluetun_network"
      ];
      ports = [
        "${secrets.tsip}:8078:8080"
        "${secrets.tsip}:8086:8086"
      ];
      volumes = [
        "/docker/scrutiny/config:/opt/scrutiny/config"
        "/docker/scrutiny/db:/opt/scrutiny/influxdb"
        "/run/udev:/run/udev:ro"
      ];
      labels = {
        "wud.tag.exclude" = "web|collector";
      };
    };

    uptime-kuma = {
      image = "${image.uptime-kuma}";
      ports = ["${secrets.tsip}:3002:3001"];
      extraOptions = [
        "--network=gluetun_network"
      ];
      volumes = [
        "/docker/uptime-kuma:/app/data"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      labels = {
        "wud.tag.include" = "debian";
        "wud.tag.exclude" = "nightly|base|node16|test|beta";
      };
    };
    lubelogger = {
      image = "${image.lubelogger}";
      ports = ["${secrets.tsip}:8077:8080"];
      volumes = [
        "/docker/lubelogger:/App/data"
      ];
    };
    kiwix = {
      image = "${image.kiwix}";
      ports = ["8000:8080"];
      volumes = [
        "/media/data/torrents/zim:/data"
      ];
      cmd = ["*.zim"];
    };
    #lichess nnue
    fishnet = {
      image = "${image.fishnet}";
      environment = {
        KEY = "${secrets.lichesskey}";
        CORES = "12";
      };
    };
  };
}

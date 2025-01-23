# Auto-generated using compose2nix v0.3.2-pre.
{
  pkgs,
  lib,
  image,
  secrets,
  ...
}: {
  # Runtime
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  # Containers
  virtualisation.oci-containers.containers."hoarder-chrome" = {
    image = "${image.hoarder-chrome}";
    ports = ["9222:9222"];
    cmd = ["--no-sandbox" "--disable-gpu" "--disable-dev-shm-usage" "--remote-debugging-address=0.0.0.0" "--remote-debugging-port=9222" "--hide-scrollbars"];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=chrome"
      "--network=hoarder_default"
    ];
    labels = {
      "wud.tag.exclude" = "[A-z]";
    };
  };

  virtualisation.oci-containers.containers."hoarder-meilisearch" = {
    image = "${image.hoarder-meilisearch}";
    ports = ["7700:7700"];
    environment = {
      "HOARDER_VERSION" = "release";
      "MEILI_MASTER_KEY" = "${secrets.hoarder.meili}";
      "NEXTAUTH_SECRET" = "${secrets.hoarder.nextauth}";
      "MEILI_NO_ANALYTICS" = "true";
      "NEXTAUTH_URL" = "http://desktop:3000";
    };
    volumes = [
      "/docker/hoarder/mellisearch:/meili_data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=meilisearch"
      "--network=hoarder_default"
    ];
    labels = {
      "wud.tag.include" = "v[0-9]";
    };
  };

  virtualisation.oci-containers.containers."hoarder-web" = {
    image = "${image.hoarder-web}";
    environment = {
      "BROWSER_WEB_URL" = "http://desktop:9222";
      "DATA_DIR" = "/data";
      "HOARDER_VERSION" = "release";
      "MEILI_ADDR" = "http://desktop:7700";
      "MEILI_MASTER_KEY" = "${secrets.hoarder.meili}";
      "NEXTAUTH_SECRET" = "${secrets.hoarder.nextauth}";
      "NEXTAUTH_URL" = "http://desktop:3000";
      "OLLAMA_BASE_URL" = "http://localhost:11434";
      "INFERENCE_TEXT_MODEL" = "phi3.5";
      "INFERENCE_IMAGE_MODEL" = "llava-llama3";
      "INFERENCE_CONTEXT_LENGTH" = "4096";
      "INFERENCE_JOB_TIMEOUT_SEC" = "300";
    };
    volumes = [
      "/docker/hoarder/hoarder:/data:rw"
    ];
    ports = [
      #"2999:2999/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      #"--add-host=host.docker.internal:host-gateway"
      #"--network-alias=web"
      "--network=host"
    ];
  };

  # Networks
  systemd.services."docker-network-hoarder_default" = {
    path = [pkgs.docker];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f hoarder_default";
    };
    script = ''
      docker network inspect hoarder_default || docker network create hoarder_default
    '';
    partOf = ["docker-compose-hoarder-root.target"];
    wantedBy = ["docker-compose-hoarder-root.target"];
  };

  # Systemd services
  systemd.services."docker-hoarder-chrome" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-hoarder_default.service"
    ];
    requires = [
      "docker-network-hoarder_default.service"
    ];
    partOf = [
      "docker-compose-hoarder-root.target"
    ];
    wantedBy = [
      "docker-compose-hoarder-root.target"
    ];
  };

  systemd.services."docker-hoarder-meilisearch" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-hoarder_default.service"
    ];
    requires = [
      "docker-network-hoarder_default.service"
    ];
    partOf = [
      "docker-compose-hoarder-root.target"
    ];
    wantedBy = [
      "docker-compose-hoarder-root.target"
    ];
  };

  systemd.services."docker-hoarder-web" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-hoarder_default.service"
    ];
    requires = [
      "docker-network-hoarder_default.service"
    ];
    partOf = [
      "docker-compose-hoarder-root.target"
    ];
    wantedBy = [
      "docker-compose-hoarder-root.target"
    ];
  };
  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-hoarder-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = ["multi-user.target"];
  };
}

{...}: {
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.enableNvidia = true;

  virtualisation.oci-containers.backend = "docker";
}

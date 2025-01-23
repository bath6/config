{...}: {
  imports = [
    ./configuration.nix
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.gvfs.enable = true;
}

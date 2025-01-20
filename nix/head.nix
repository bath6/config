{...}: {
  imports = [
    ./configuration.nix
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  services.gvfs.enable = true;
}

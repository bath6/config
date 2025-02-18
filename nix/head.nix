{
  pkgs,
  secrets,
  colors,
  config,
  ...
}: {
  imports = [
    ./configuration.nix
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.gvfs.enable = true;

  #for wayland and hyprland

  # use rofi-wayland for rofimoji
  nixpkgs.overlays = [
    (self: super: {
      rofi = pkgs.rofi-wayland;
    })
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  home-manager = {
    users.jacob = import ../hm/${config.networking.hostName}.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit secrets;
      inherit colors;
    };
  };
}

{secrets, ...}: {
  imports = [
    ../head.nix
    ./hardware-t440p.nix
    ./sty.nix
  ];

  home-manager = {
    users.jacob = import ../../hm/laptop.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit secrets;
    };
  };

  services.libinput.enable = true;

  hardware.acpilight.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.hostName = "t440p";

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      INTEL_GPU_MIN_FREQ_ON_AC = 700;
      INTEL_GPU_MIN_FREQ_ON_BAT = 200;

      INTEL_GPU_MAX_FREQ_ON_AC = 1300;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1300;

      INTEL_GPU_BOOST_FREQ_ON_AC = 1300;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1300;
    };
  };
}

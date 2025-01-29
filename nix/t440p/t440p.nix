{pkgs, ...}: {
  imports = [
    ../head.nix
    ./hardware-t440p.nix
    ./sty.nix
  ];

  #for wireguard
  services.resolved.enable = true;

  #autologin and launch hyprland
  services.getty = {
    autologinUser = "jacob";
    autologinOnce = true;
  };
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && Hyprland
  '';

  services.logind = {
    powerKey = "ignore";
    powerKeyLongPress = "ignore";
  };

  services.libinput.enable = true;

  hardware.acpilight.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.hostName = "t440p";

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    undervolt
  ];

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["jacob"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      INTEL_GPU_MIN_FREQ_ON_AC = 1300;
      INTEL_GPU_MIN_FREQ_ON_BAT = 200;

      INTEL_GPU_MAX_FREQ_ON_AC = 1300;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1300;

      INTEL_GPU_BOOST_FREQ_ON_AC = 1300;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1300;
    };
  };
}

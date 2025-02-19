{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../head.nix
    ./hardware-rog14.nix
    ../t440p/sty.nix
  ];

  #gpu
  #disable discrete gpu by default
  hardware.graphics.enable = true;
  hardware.nvidiaOptimus.disable = true;

  #specialisation that enables dgpu
  specialisation = {
    nvidia.configuration = {
      hardware.nvidiaOptimus.disable = lib.mkForce false;
      services.xserver.videoDrivers = ["amdgpu" "nvidia"];
      hardware.nvidia = {
        modesetting.enable = true;
        dynamicBoost.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        open = false;
        prime = {
          offload.enable = true;
          offload.enableOffloadCmd = true;
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:4:0:0";
        };
      };
    };
  };

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

  #power management
  #asusd manages platform profiles
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  powerManagement.powertop.enable = true;
  networking.networkmanager.wifi.powersave = true;
  networking.networkmanager.wifi.backend = "iwd";
  #steam
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = [pkgs.proton-ge-bin];
  services.libinput.enable = true;

  hardware.acpilight.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.hostName = "rog14";

  #ollama
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  environment.systemPackages = with pkgs; [
    powertop
    radeontop
    ryzenadj
    nvtopPackages.amd
    nvtopPackages.nvidia
  ];
}

{...}: {
  imports = [
    ../head.nix
    ./hardware-rog14.nix
    ../t440p/sty.nix
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

  environment.systemPackages = [
  ];
}

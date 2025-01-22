{...}: {
  imports = [
    ./hardware-sd.nix
    ../configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sd";

  jovian = {
    devices.steamdeck.enable = true;
    hardware.has.amd.gpu = true;
    steam = {
      enable = true;
      autoStart = true;
      updater.splash = "jovian";
      user = "jacob";
    };
  };
}

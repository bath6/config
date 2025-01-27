{
  pkgs,
  pkgs-freeimage,
  ...
}: {
  imports = [
    ./hardware-sd.nix
    ../configuration.nix
  ];

  boot.loader.timeout = 1;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "5";
  boot.loader.efi.canTouchEfiVariables = true;
  services.desktopManager.plasma6.enable = true;

  #use patched freeimage, less cves?
  nixpkgs.overlays = [
    (self: super: {
      freeimage = pkgs-freeimage.freeimage;
    })
  ];

  environment.systemPackages = with pkgs; [
    xivlauncher
    heroic
    steam-rom-manager
    #gc wii
    dolphin-emu
    #ps2
    pcsx2
    #ps3
    rpcs3

    emulationstation-de
  ];

  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
  };

  networking.hostName = "sd";

  jovian = {
    devices.steamdeck.enable = true;
    hardware.has.amd.gpu = true;
    steam = {
      enable = true;
      autoStart = true;
      user = "jacob";
      updater.splash = "steamos";
      desktopSession = "plasma";
    };
  };
}

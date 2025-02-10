{
  pkgs,
  pkgs-freeimage,
  pkgs-stable,
  secrets,
  colors,
  self,
  ...
}: let
  retroarchWithCores = pkgs.retroarch.withCores (cores:
    with cores; [
      opera
    ]);
in {
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
      libgit2 = pkgs-stable.libgit2;
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

    #retroarretroarchWithCores
    retroarchWithCores
    emulationstation-de
  ];

  programs.steam.extraCompatPackages = [pkgs.proton-ge-bin];

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

  home-manager = {
    users.jacob = import ./hm;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = builtins.toString self.lastModified;
    extraSpecialArgs = {
      inherit secrets;
      inherit colors;
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}${colors.sd.stylix}";
    polarity = "dark";

    image = ../../hm/wall/milk2.png;
    imageScalingMode = "center";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
    };
  };
}

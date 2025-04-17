{
  pkgs,
  pkgs-freeimage,
  secrets,
  colors,
  self,
  ...
}: let
  #add random buildInput to xivlauncher to force rebuild because bin doesn't work
  xivbuild = pkgs.xivlauncher.overrideAttrs (finalAttrs: previousAttrs: {
    buildInputs = previousAttrs.buildInputs ++ [pkgs.hello];
  });
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

  networking.networkmanager.wifi.powersave = false;

  #use patched freeimage, less cves?
  nixpkgs.overlays = [
    (self: super: {
      #freeimage = pkgs-freeimage.freeimage;
      #emulationstation-de = pkgs-freeimage.emulationstation-de;
    })
  ];

  environment.systemPackages = [
    xivbuild
    #pkgs.firefox
    #pkgs-freeimage.emulationstation-de
  ];

  #programs.steam.extraCompatPackages = [pkgs.proton-ge-bin];

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
    #backupFileExtension = "test";
    extraSpecialArgs = {
      inherit secrets;
      inherit colors;
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}${colors.sd.stylix}";
    polarity = "dark";

    targets.qt.platform = "qtct";

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

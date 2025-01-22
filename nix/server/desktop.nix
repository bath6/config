{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-desktop.nix
    ./oci/docker.nix
    ./llm.nix
    ../configuration.nix
  ];
  services.xserver.enable = false;
  programs.fuse.userAllowOther = true;

  # use kitten ssh colors in vim
  programs.nixvim.opts = {
    termguicolors = false;
  };
  # stylix.enable = true;
  # stylix.base16Scheme = "${pkgs.base16-schemes}${serverScheme}";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop"; # Define your hostname.

  environment.systemPackages = [
    pkgs.gocryptfs
  ];
}

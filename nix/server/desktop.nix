{
  pkgs,
  pkgs-ollama,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-desktop.nix
    ./oci/docker.nix
    ./llm.nix
    ../configuration.nix
  ];
  services.xserver.enable = false;
  programs.fuse.userAllowOther = true;

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/greenscreen.yaml";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop"; # Define your hostname.

  environment.systemPackages = [
    pkgs.gocryptfs
    pkgs-ollama.ollama-rocm
  ];
}

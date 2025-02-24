{pkgs, ...}: let
  retroarchWithCores = pkgs.retroarch.withCores (cores:
    with cores; [
      opera
    ]);
in {
  imports = [
    ./wm/hypr.nix
    ../../../hm/app/kitty.nix
  ];

  home.stateVersion = "25.05";
  home.username = "jacob";
  home.homeDirectory = "/home/jacob";

  wayland.windowManager.hyprland.enable = true;

  programs.firefox.enable = true;
  programs.zathura.enable = true;
  programs.bash.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    mpv

    protonup-ng

    heroic
    steam-rom-manager
    #gc wii
    dolphin-emu
    #ps2
    pcsx2
    #ps3
    rpcs3

    emulationstation-de
    #retroarretroarchWithCores
    retroarchWithCores
    # (writeShellScriptBin "obs" ''
    #   obsidian --enable-features=UseOzonePlatform --ozone-platform-hint=wayland --ozone-platform=wayland
    # '')
  ];
}

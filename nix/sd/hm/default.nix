{pkgs, ...}: {
  home.stateVersion = "25.05";
  home.username = "jacob";
  home.homeDirectory = "/home/jacob";

  programs.firefox.enable = true;
  programs.zathura.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    mpv
    jellyfin-media-player
    nerd-fonts.symbols-only
    kdePackages.oxygen-icons

    # (writeShellScriptBin "obs" ''
    #   obsidian --enable-features=UseOzonePlatform --ozone-platform-hint=wayland --ozone-platform=wayland
    # '')
  ];
}

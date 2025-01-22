{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./wm/hypr.nix
    ./app
  ];

  home.shellAliases = {
  };

  home.stateVersion = "25.05";
  home.username = "jacob";
  home.homeDirectory = "/home/jacob";

  qt.enable = true;
  gtk.enable = true;
  gtk.iconTheme = {
    package = pkgs.pop-icon-theme;
    name = "Pop";
  };

  programs.bash.enable = true;

  home.file.".config/" = {
    source = ./config;
    recursive = true;
  };

  home.packages = with pkgs; [
    firefox
    baobab
    pcmanfm
    pulsemixer
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    mpv
    telegram-desktop
    jellyfin-media-player
    obsidian
    nerd-fonts.symbols-only

    # (writeShellScriptBin "obs" ''
    #   obsidian --enable-features=UseOzonePlatform --ozone-platform-hint=wayland --ozone-platform=wayland
    # '')
  ];

  # .desktop files for rofi
  xdg.desktopEntries = {
    obsidian = {
      name = "Obsidian";
      genericName = "Notes";
      exec = "obsidian --enable-features=UseOzonePlatform --ozone-platform-hint=wayland --ozone-platform=wayland";
      categories = ["Application"];
    };
  };

  fonts.fontconfig.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "kitty";
  };

  programs.btop.enable = true;

  programs.yazi.enable = true;

  programs.imv = {
    enable = true;
    settings = {
      options.background = "#${config.lib.stylix.colors.base00}";
    };
  };
}

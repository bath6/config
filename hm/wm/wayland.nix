{
  #secrets,
  pkgs,
  ...
}: {
  imports = [
    ./wlogout.nix
  ];
  #enable wayland stuff
  # wayland packages
  home.packages = with pkgs; [
    wl-clipboard
    wev
    grim
    rofimoji
  ];

  #notifications
  services.mako.enable = true;

  #changes K at night
  # services.wlsunset = {
  #   enable = true;
  #   #latitude = "${secrets.lat}";
  #   #longitude = "${secrets.long}";
  # };

  programs.rofi = {
    enable = true;
    #package = pkgs.rofi-wayland;
    terminal = "kitty";
  };

  programs.waybar.enable = true;
  programs.waybar.style = ''
    #workspaces button.active {
      border-bottom: 3px solid @base0D;
    }
    #window {
      color: @base0C;
    }
  '';
}

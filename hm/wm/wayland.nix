{
  secrets,
  pkgs,
  ...
}: {
  services.wlsunset = {
    enable = true;
    latitude = "${secrets.lat}";
    longitude = "${secrets.long}";
  };

  services.mako.enable = true;

  # wayland packages
  home.packages = with pkgs; [
    wl-clipboard
    wev
    grim
  ];
}

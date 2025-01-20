{...}: {
  imports = [
    ./hm.nix
  ];

  programs.git = {
    enable = true;
    userEmail = "jacob@t440.p";
    userName = "t440p";
  };

  wayland.windowManager.hyprland.extraConfig = ''
    bind = , XF86MonBrightnessDown, exec, xbacklight -5
    bind = , XF86MonBrightnessUp, exec, xbacklight +5
  '';
}

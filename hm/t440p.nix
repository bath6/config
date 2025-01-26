{...}: {
  imports = [
    ./hm.nix
  ];
  home.shellAliases = {
    light = "sudo nixos-rebuild switch --flake .#t440p --specialisation light";
    dark = "sudo nixos-rebuild switch --flake .#t440p";
  };

  programs.git = {
    enable = true;
    userEmail = "jacob@t440.p";
    userName = "t440p";
  };

  wayland.windowManager.hyprland.extraConfig = ''
    monitor = ,preferred,auto,1.2
    bind = , XF86MonBrightnessDown, exec, xbacklight -5
    bind = , XF86MonBrightnessUp, exec, xbacklight +5
  '';
}

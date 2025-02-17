{pkgs, ...}: {
  imports = [
    ./hm.nix
  ];
  home.shellAliases = {
    light = "sudo nixos-rebuild switch --flake .#rog14 --specialisation light";
    dark = "sudo nixos-rebuild switch --flake .#rog14";
  };

  home.packages = with pkgs; [
    moonlight-qt
  ];

  programs.git = {
    enable = true;
    userEmail = "jacob@rog.14";
    userName = "rog14";
  };

  wayland.windowManager.hyprland.extraConfig = ''
    monitor = ,preferred,auto,1.2
    bind = , XF86MonBrightnessDown, exec, xbacklight -5
    bind = , XF86MonBrightnessUp, exec, xbacklight +5
  '';
}

{pkgs, ...}: {
  imports = [
    ./hm.nix
  ];
  home.shellAliases = {
    light = "sudo nixos-rebuild switch --flake .#rog14 --specialisation light";
    dark = "sudo nixos-rebuild switch --flake .#rog14";
  };

  xdg.desktopEntries = {
    steam = {
      name = "Steam";
      exec = "steam -forcedesktopscaling 1.2";
      categories = ["Application"];
    };
    xivlauncher = {
      name = "XIVLauncher";
      exec = "env XL_SECRET_PROVIDER=file XIVLauncher.Core";
      categories = ["Application"];
    };
  };

  home.packages = with pkgs; [
    moonlight-qt
    xivlauncher
  ];

  programs.git = {
    enable = true;
    userEmail = "jacob@rog.14";
    userName = "rog14";
  };

  wayland.windowManager.hyprland = {
    settings = {
      misc = {
        vfr = true;
        vrr = true;
      };
    };
    extraConfig = ''
      monitor = ,preferred,auto,1.2
      bind = , XF86MonBrightnessDown, exec, xbacklight -5
      bind = , XF86MonBrightnessUp, exec, xbacklight +5
      bind = , XF86KbdBrightnessUp, exec, asusctl -n
      bind = , XF86KbdBrightnessDown, exec, asusctl -p
    '';
  };
}

{...}: {
  imports = [
    ./wayland.nix
    ./hyprutils.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      #"animation" = "global, 0";
      bezier = "test, 0.455, 0.03, 0.515, 0.955";
      animation = [
        "workspaces, 1, 3, test"
        "windows, 1, 1, test"
        "windowsMove, 1, 3, test"
      ];

      animations.first_launch_animation = false;
      dwindle.preserve_split = true;

      general = {
        no_border_on_floating = true;
        gaps_in = 2;
        gaps_out = 4;
      };

      misc = {
        disable_splash_rendering = true;
        vfr = true;
      };

      decoration = {
        rounding = 3;
        #rounding_power = 3.0;
        inactive_opacity = 0.9;
        blur.enabled = false;
        shadow.enabled = false;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      exec-once = "waybar";
      "$mod" = "SUPER";
      "$mainMod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, d, exec, rofi -show drun"
        "$mod$Shift_L, c, killactive,"
        ", XF86PowerOff, exec, wlogout"
      ];
    };

    extraConfig = ''
      #xf86 shortcuts
      bind = , XF86AudioMute, exec, pulsemixer --toggle-mute
      bind = , XF86AudioLowerVolume, exec, pulsemixer --unmute && pulsemixer --change-volume -5
      bind = , XF86AudioRaiseVolume, exec, pulsemixer --unmute && pulsemixer --change-volume +5

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod SHIFT, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod SHIFT, F, exec, firefox
      bind = $mainMod, Space, togglefloating,
      bind = $mainMod, D, exec, rofi -show run
      #bind = Alt_L, R, exec, rofi -show run
      bind = $mainMod, E, exec, rofimoji
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, V, togglesplit, # dwindle
      bind = $mainMod, F, fullscreen,

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      bind = $mainMod, h, movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, j, movefocus, u
      bind = $mainMod, k, movefocus, d
      #move maybe
      bind = $mainMod SHIFT, h, movewindow, l
      bind = $mainMod SHIFT, l, movewindow, r
      bind = $mainMod SHIFT, j, movewindow, u
      bind = $mainMod SHIFT, k, movewindow, d
      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

    '';
  };
}

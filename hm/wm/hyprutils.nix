{
  lib,
  config,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "hyprlock";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    # extraconfig for stylix compat
    settings = lib.mkForce {
      general = {
        disable_loading_bar = true;
        #grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          #path = "${config.stylix.image}";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, 80";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          check_color = "rgb(${config.lib.stylix.colors.base0A})";
          fail_color = "rgb(${config.lib.stylix.colors.base08})";
          font_color = "rgb(${config.lib.stylix.colors.base05})";
          inner_color = "rgb(${config.lib.stylix.colors.base00})";
          outer_color = "rgb(${config.lib.stylix.colors.base03})";
          outline_thickness = 2;
          placeholder_text = "";
          shadow_passes = 2;
        }
      ];
    };
  };
}

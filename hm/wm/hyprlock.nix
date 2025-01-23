{
  lib,
  config,
  ...
}: {
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
          path = "${config.stylix.image}";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          check_color = "rgb(${config.lib.stylix.colors.base0A})";
          fail_color = "rgb(${config.lib.stylix.colors.base08})";
          font_color = "rgb(${config.lib.stylix.colors.base05})";
          inner_color = "rgb(${config.lib.stylix.colors.base00})";
          outer_color = "rgb(${config.lib.stylix.colors.base03})";
          outline_thickness = 5;
          #placeholder_text = "'\'Password...'\'";
          shadow_passes = 2;
        }
      ];
    };
  };
}

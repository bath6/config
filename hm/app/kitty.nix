{
  config,
  colors,
  ...
}: {
  home.shellAliases = {
    s = "kitten ssh";
  };

  programs.kitty = {
    enable = true;
    settings = {
      touch_scroll_multiplier = 5.0;
      confirm_os_window_close = 0;
    };
  };

  home.file.".config/kitty/ssh.conf".text = ''
    hostname desktop
    color_scheme ${colors.server.kitty.${config.stylix.polarity}}

    hostname sd
    color_scheme ${colors.sd.${config.stylix.polarity}}
  '';
}

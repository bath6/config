{...}: {
  #enable wayland stuff
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

{pkgs, ...}: {
  #TODO
  # light & dark specialization
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
  stylix.polarity = "light";

  stylix.image = ../../hm/wall/milk2.png;
  stylix.imageScalingMode = "center";

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font Mono";
    };
  };
}

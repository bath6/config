{
  pkgs,
  lib,
  colors,
  ...
}: {
  #TODO
  # light & dark specialization

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}${colors.laptop.dark}";
    polarity = "dark";

    image = ../../hm/wall/milk2.png;
    imageScalingMode = "center";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
    };
    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 24;
    };
  };

  specialisation = {
    light.configuration = {
      stylix = lib.mkForce {
        base16Scheme = "${pkgs.base16-schemes}${colors.laptop.light}";
        polarity = "light";

        image = ../../hm/wall/test.jpg;
        imageScalingMode = "center";
      };
    };
  };
}

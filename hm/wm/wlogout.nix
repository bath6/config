{
  config,
  pkgs,
  ...
}: {
  programs.wlogout = {
    enable = true;
    style = ''
        * {
            box-shadow: none;
       }
        window {
            background-image: url("${config.stylix.image}");
            background-color: #${config.lib.stylix.colors.base00};
       }
        button {
            opacity: 0.5;
            border-radius: 0;
            border-color: black;
            text-decoration-color: #${config.lib.stylix.colors.base08};
            color: #${config.lib.stylix.colors.base02};
            background-color: #${config.lib.stylix.colors.base02};
            border-style: solid;
            border-width: 1px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
       }
       button:active, button:hover {
           background-color: #${config.lib.stylix.colors.base04};
           outline-style: none;
      }
      /*
        button:focus, button:active, button:hover {
            background-color: #3700B3;
            outline-style: none;
       }*/
       #lock {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
       }

        #logout {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
       }
        #suspend {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
       }
        #hibernate {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
       }
        #shutdown {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
       }
        #reboot {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
       }

    '';
  };
}

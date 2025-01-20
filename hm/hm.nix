{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hypr.nix
    ./wybr.nix
  ];

  home.stateVersion = "25.05";
  home.username = "jacob";
  home.homeDirectory = "/home/jacob";

  home.file.".config/" = {
    source = ./config;
    recursive = true;
  };

  home.packages = with pkgs; [
    firefox
    baobab
    wev
    pulsemixer
    waybar
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    wl-clipboard
  ];

  fonts.fontconfig.enable = true;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  programs.zed-editor = {
    enable = true;
    extensions = ["nix"];
    extraPackages = with pkgs; [
      nil
      alejandra
    ];
    userSettings = {
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
      languages = {
        Nix = {
          language_servers = ["!nixd" "nil"];
        };
      };
      lsp = {
        nil = {
          initialization_options = {
            formatting = {
              command = ["alejandra" "--quiet" "--"];
            };
          };
          nix.flake = {
            autoArchive = true;
          };
        };
      };
      assistant = {
        version = "2";
        default_model = {
          provider = "ollama";
          model = "phi3.5";
        };
      };
      language_models = {
        ollama = {
          api_url = "http://desktop:11434";
          available_models = [
            {
              name = "phi3.5";
              display_name = "phi3.5 8k";
              max_tokens = 8192;
            }
          ];
        };
      };
    };
  };

  programs.btop.enable = true;

  programs.waybar.enable = true;

  programs.yazi.enable = true;
  programs.imv = {
    enable = true;
    settings = {
      options.background = "#${config.lib.stylix.colors.base00}";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      touch_scroll_multiplier = 5.0;
      confirm_os_window_close = 0;
    };
  };
}

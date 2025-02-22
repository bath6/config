{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = ["nix"];
    extraPackages = with pkgs; [
      nil
      alejandra
      package-version-server
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
        package-version-server = {
          binary = {
            path = "package-version-server";
          };
        };
      };
      assistant = {
        version = "2";
        default_model = {
          provider = "ollama";
          model = "deepseek-r1:7b";
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
}

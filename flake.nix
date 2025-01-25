{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    # pinned Ollama 5.1
    nixpkgs-ollama.url = "nixpkgs/8f3e1f807051e32d8c95cd12b9b421623850a34d";
    #nixpkgs-ollama.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # jovian
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    #stylix
    stylix.url = "github:danth/stylix";
    stylix-stable = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    #nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-stable = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-ollama,
    home-manager,
    jovian,
    stylix,
    stylix-stable,
    nixvim,
    nixvim-stable,
    #base16,
    ...
  } @ inputs: let
    image = builtins.fromJSON (builtins.readFile "${self}/image.json");
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    system = "x86_64-linux";
    colors = {
      laptop = {
        #stylix tinted-theming base16
        dark = "/share/themes/atelier-plateau.yaml";
        light = "/share/themes/rose-pine-dawn.yaml";
      };
      server = {
        kitty = {
          #kitten themes
          light = "1984 Light";
          dark = "Brogrammer";
        };
      };
      sd = {
        light = "Man Page";
        dark = "Cyberpunk";
      };
    };
  in {
    #
    #stable server config
    nixosConfigurations.desktop = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit image;
        inherit secrets;
        inherit colors;

        pkgs-ollama = import nixpkgs-ollama {inherit system;};

        pkgs-unstable = import nixpkgs {inherit system;};
      };
      modules = [
        ./nix/desktop/desktop.nix
        ./nix/nvim.nix
        stylix-stable.nixosModules.stylix
        nixvim-stable.nixosModules.nixvim
      ];
    };

    # unstable t440p
    nixosConfigurations.t440p = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit secrets;
        inherit colors;
      };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./nix/t440p/t440p.nix
        ./nix/nvim.nix

        #base16.nixosModule
        stylix.nixosModules.stylix
        nixvim.nixosModules.nixvim
        home-manager.nixosModules.home-manager
      ];
    };
    nixosConfigurations.sd = nixpkgs.lib.nixosSystem {
      specialArgs = {
        pkgs-ollama = import nixpkgs-ollama {inherit system;};
      };
      modules = [
        ./nix/sd/sd.nix
        stylix.nixosModules.stylix
        jovian.nixosModules.jovian
      ];
    };
  };
}

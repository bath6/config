{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    # pinned Ollama 5.1
    nixpkgs-ollama.url = "nixpkgs/8f3e1f807051e32d8c95cd12b9b421623850a34d";
    #nixpkgs-ollama.url = "github:NixOS/nixpkgs/nixos-unstable";
    #patched free image
    freeimage.url = "github:usertam/nixpkgs/patch/freeimage";

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
    freeimage,
    home-manager,
    jovian,
    stylix,
    stylix-stable,
    nixvim,
    nixvim-stable,
    #base16,
    ...
  } @ inputs:
  #
  let
    image = builtins.fromJSON (builtins.readFile "${self}/version.json");
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    colors = import ./colors.nix;
    system = "x86_64-linux";
    defModules = [
      nixvim.nixosModules.nixvim
      home-manager.nixosModules.home-manager
      stylix.nixosModules.stylix
    ];
  in {
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
      modules =
        defModules
        ++ [
          ./nix/t440p/t440p.nix
        ];
    };

    #Steam deck jovian nixos
    nixosConfigurations.sd = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit colors;
        inherit secrets;
        pkgs-freeimage = import freeimage {
          inherit system;
          config.permittedInsecurePackages = [
            "freeimage-unstable-2024-04-18"
          ];
        };
      };
      modules =
        defModules
        ++ [
          ./nix/sd/sd.nix
          jovian.nixosModules.jovian
        ];
    };
  };
}

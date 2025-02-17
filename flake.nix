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
    stylix.url = "/home/jacob/stylix";
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
    image = builtins.fromJSON (builtins.readFile "${self}/image.json");
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
        {boot.binfmt.emulatedSystems = ["aarch64-linux"];}
      ];
    };
    # stable potato
    nixosConfigurations.potato = nixpkgs-stable.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {
        inherit secrets;
      };
      modules = [
        "${nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        nixvim-stable.nixosModules.nixvim
        ./nix/potato/potato.nix
      ];
    };

    # unstable t440p
    nixosConfigurations.t440p = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit secrets;
        pkgs-stable = import nixpkgs-stable {inherit system;};
        inherit colors;
      };
      modules =
        defModules
        ++ [
          ./nix/t440p/t440p.nix
          {boot.binfmt.emulatedSystems = ["aarch64-linux"];}
        ];
    };

    #rog g14
    nixosConfigurations.rog14 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit secrets;
        pkgs-stable = import nixpkgs-stable {inherit system;};
        inherit colors;
      };
      modules =
        defModules
        ++ [
          ./nix/rog14/rog14.nix
          {boot.binfmt.emulatedSystems = ["aarch64-linux"];}
        ];
    };

    #Steam deck jovian nixos
    nixosConfigurations.sd = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit colors;
        inherit secrets;
        inherit self;
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
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

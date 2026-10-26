{
  
  inputs = {
  	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	umbriel.url = "github:noctalia-dev/umbriel";
	nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
	nixcord.url = "github:4evy/nixcord";
	stylix = {
	  url = "github:nix-community/stylix";
	  inputs.nixpkgs.follows = "nixpkgs";
	};
	zen-browser = {
	  url = "github:0xc000022070/zen-browser-flake";
	  inputs = {
	    nixpkgs.follows = "nixpkgs";
	    home-manager.follows = "home-manager";
	  };
	};
	home-manager = {
	  url = "github:nix-community/home-manager/master";
	  inputs.nixpkgs.follows = "nixpkgs";
	};
	vicinae.url = "github:vicinaehq/vicinae";
  };

  outputs = { self, nixpkgs, umbriel, home-manager, vicinae, zen-browser, stylix, nixcord, nix-flatpak, ... }@inputs: {
    nixosConfigurations.nixlarp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	home-manager.nixosModules.home-manager
	vicinae.nixosModules.default
	stylix.nixosModules.stylix
	nix-flatpak.nixosModules.nix-flatpak
	{
	  nix.settings = {
	    extra-substituters = [ "https://vicinae.cachix.org" ];
            extra-trusted-public-keys = [ "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" ];
          };
	  home-manager = {
  	    useGlobalPkgs = true;
            useUserPackages = true;
            users.suika = {
	      imports = [
                ./home.nix
               	vicinae.homeManagerModules.default
		inputs.zen-browser.homeModules.beta
		inputs.nixcord.homeModules.nixcord
              ];
	    };
	    backupFileExtension = "backup";
	   };
        }
      ];
    };
  };
}

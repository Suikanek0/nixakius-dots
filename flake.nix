{
  
  inputs = {
  	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	umbriel.url = "github:noctalia-dev/umbriel";
	home-manager = {
	  url = "github:nix-community/home-manager/master";
	  inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { self, nixpkgs, umbriel, home-manager, ... }@inputs: {
    nixosConfigurations.nixlarp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	home-manager.nixosModules.home-manager
	{
	  home-manager = {
  	    useGlobalPkgs = true;
            useUserPackages = true;
            users.suika = import ./home.nix;
	    backupFileExtension = "backup";
	   };
        }
      ];
    };
  };
}

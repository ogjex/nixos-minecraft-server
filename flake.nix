{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nix-minecraft = {
		    url = "github:infinidoge/nix-minecraft";
		    inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs ... } @ inputs: 
	let
	    inherit (nixpkgs) lib;

	in {
		nixosConfigurations.nixos-minecraft = nixpkgs.lib.nixosSystem {
			specialArgs = { };
			modules = [
				inputs.nix-minecraft.nixosModules.nix-minecraft
				./configuration.nix
				# other imports
			];
		};
	};
}

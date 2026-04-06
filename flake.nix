{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nix-minecraft = {
		    url = "github:infinidoge/nix-minecraft";
		    inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, nix-minecraft, ... }@inputs: let
	    inherit (nixpkgs) lib;

	in {
		nixosConfigurations.nixos-minecraft = lib.nixosSystem {
			modules = [
				#inputs.nix-minecraft.nixosModules.nix-minecraft
				./configuration.nix
				./hardware-configuration.nix
				# other imports
			];
		};
	};
}

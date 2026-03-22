{
	description = "Nixos config flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		nix-minecraft.url = “github:Infinidoge/nix-minecraft”;
	
	};

	outputs = { self, nixpkgs, ... }@inputs: {
		nixosConfigurations.default = nixpkgs.lib.nixosSystem {

			specialArgs = {inherit inputs;};
			modules = [
				./configuration.nix
				./hardware-configuration.nix
				# other imports
			];
		};
	};
}

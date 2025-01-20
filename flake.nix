{
  description = "Kams NixOS Configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @inputs:
    let
      inherit (self) outputs;

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

    in {

      # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs; };
	        modules = [ ./nixos/configuration.nix ];
	      };
        
        overlays = import ./overlays {inherit inputs;};

        nixosModules = import ./modules/nixos;

        homeManagerModules = import ./modules/home-manager;
      };
    };
}

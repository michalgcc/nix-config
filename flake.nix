{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        mg-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/laptop/configuration.nix ];
        };
        mg-desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/desktop/configuration.nix ];
        };
        mg-t14gen1i = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./nixos/t14gen1i/configuration.nix ];
        };
      };

      homeConfigurations = {
        "mg@home-manager" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home-manager/home-gui.nix ];
        };
        "mg@home-manager-cli" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home-manager/home-cli.nix ];
        };
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.cocogitto
          pkgs.nixfmt
          pkgs.shfmt
        ];

        shellHook = ''
          yes | cog install-hook --all
        '';
      };

    };
}

{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # https://github.com/anshulnoori/nixos-apple-silicon
    apple-silicon = {
      url = "github:anshulnoori/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    hyprland.url = "github:hyprwm/Hyprland";

    stylix.url = "github:danth/stylix";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    home-manager,
    apple-silicon,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = [
        "aarch64-linux"
        # "x86_64-linux"
      ];

      perSystem = {pkgs, ...}: {
        packages = import ./pkgs pkgs;
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            alejandra
            git
          ];
        };
      };

      flake = {
        overlays = import ./overlays {inherit inputs;};
        nixosModules = import ./modules/nixos;

        homeModules.default = import ./modules/home-manager;

        templates = import ./templates;

        nixosConfigurations = {
          macbook = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = {inherit inputs;};
            modules = [
              apple-silicon.nixosModules.apple-silicon-support
              ./hosts/macbook/configuration.nix

              inputs.self.nixosModules.boot
              inputs.self.nixosModules.core
              inputs.self.nixosModules.desktop

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit inputs;};
                home-manager.users.mvs = import ./users/mvs/home.nix;
              }
            ];
          };

          # desktop = nixpkgs.lib.nixosSystem {
          #   system = "x86_64-linux";
          #   specialArgs = { inherit inputs; };
          #   modules = [
          #     ./hosts/desktop/configuration.nix
          #   ];
          # };
        };
      };
    };
}

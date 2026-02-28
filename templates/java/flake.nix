{
  description = "Java development environment";

  inputs = {
    nixpkgs.url   = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {pkgs, ...}: let
        java = pkgs.jdk21;
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            java
            gradle
            mvnd
            jbang
            just
            jdt-language-server
            google-java-format
          ];

          JAVA_HOME = "${java}";
        };
      };
    };
}

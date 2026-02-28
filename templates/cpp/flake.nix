{
  description = "C/C++ development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          clang
          llvm
          mold
          ccache
          clang-tools
          cmake
          ninja
          gnumake
          just
          pkg-config
          lldb
        ];

        env = {
          CMAKE_GENERATOR = "ninja";
          CMAKE_EXPORT_COMPILE_COMMANDS = "1";
          LDFLAGS = "-fuse-ld=mold";
        };
      };
    });
}

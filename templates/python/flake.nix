{
  description = "Python development environment";

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
      python = pkgs.python3;
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          python
          just
          uv
          # pyx
          ty
          ruff
        ];

        env = {
          UV_PROJECT_ENVIRONMENT = ".venv";
        };

        shellHook = ''
          export VIRTUAL_ENV=$PWD/.venv
          export PATH=$VIRTUAL_ENV/bin:$PATH

          if [ -f pyproject.toml ]; then
            uv sync --quiet
          fi
        '';
      };
    });
}

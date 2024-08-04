{
  description = "Python Hatch (jupyter) development environment";

  #inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-parts = {
    url = "github:hercules-ci/flake-parts";
    inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      mkFHSEnvShell = pkgs: fhsEnvAttrs: (pkgs.buildFHSEnv fhsEnvAttrs).env;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem =
        { pkgs, ... }:
        let
          pypkgs = pkgs.python312Packages;
        in
        rec {
          #devShells.default = devShells.jupyterlab;
          #devShells.default = devShells.jupyter-server;
          devShells.default = devShells.fhs;

          devShells.jupyterlab = pkgs.mkShell {
            name = "venv4jupyter";
            venvDir = ".venv";
            packages =
              (with pkgs; [
                python312
                zeromq
                nodejs_20
                ruff
                pre-commit
                which
                hatch
                node2nix
                yarn
              ])
              ++ (with pypkgs; [
                pip
                venvShellHook
                hatch-jupyter-builder
              ])
              ++ pypkgs.jupyterlab.dependencies;
          };

          devShells.jupyter-server = pkgs.mkShell {
            name = "venv4jupyter";
            venvDir = ".venv";
            packages =
              (with pkgs; [
                python312
                zeromq
                nodejs_22
                pre-commit
                which
              ])
              ++ (with pypkgs; [
                pip
                venvShellHook
              ])
              ++ pypkgs.jupyter-server.propagatedBuildInputs;
          };

          # uses FHS so hatch can work with linux filesystem hierarchy standard
          devShells.fhs = mkFHSEnvShell pkgs {
            name = "fhs4jupyter";
            targetPkgs =
              pkgs:
              (with pkgs; [
                udev
                #stdenv
                gccStdenv
                gcc
                which
                nodejs_20
                hatch
                zeromq
                pre-commit
                zsh
                yarn
                python311
              ])
              ++ (with pkgs.python311Packages; [
                pip
                setuptools
              ]);
            runScript = "bash";
            profile = ''
              #unset PS1
              #export PROMPT="%B%F{cyan}%1~%f%b %F{green}%!%f%% "
            '';
          };
        };
    };
}

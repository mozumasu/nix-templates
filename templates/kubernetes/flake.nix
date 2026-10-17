{
  description = "Kubernetes tooling devShell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.kubectl
            pkgs.k9s
            pkgs.kubectx # kubectx + kubens
            pkgs.kubernetes-helm
            pkgs.cilium-cli
            pkgs.cri-tools # crictl
          ]
          # runc は Linux 専用
          ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.runc ];
        };
      }
    );
}

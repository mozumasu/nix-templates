{
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      systems = import systems;

      perSystem =
        {
          config,
          system,
          ...
        }:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [
              # nixpkgs-unstable の nodejs デフォルト = 現行 Active LTS
              pkgs.nodejs
              # バージョン固定は package.json の packageManager に任せる
              # (pnpm が自動でそのバージョンに切り替える)。nixpkgs の pnpm は
              # cargo vendor を伴うビルドのため overrideAttrs で src だけ差し替えられない
              pkgs.pnpm
            ];

            shellHook = ''
              echo "🎨 Slidev theme/addon dev environment ready"
              echo "  - node version: $(node --version)"
              echo "  - pnpm version: $(pnpm --version)"
            '';
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              prettier.enable = true;
              actionlint.enable = true;
            };
          };
        };
    };
}

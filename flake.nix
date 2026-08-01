{
  description = "moontide.ink";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      systems = nixpkgs.lib.systems.flakeExposed;

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f (
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            {
              inherit system pkgs;
              inherit (pkgs) treefmt;
              selfPackages = self.packages.${system};
            }
          )
        );
    in
    {
      devShells = forAllSystems (
        {
          pkgs,
          treefmt,
          selfPackages,
          ...
        }:
        {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.just
              pkgs.fish
              pkgs.rsync
              pkgs.miniserve

              # Formatters
              treefmt
              pkgs.nixfmt
              pkgs.prettier
              pkgs.taplo
            ];

            env.FONT_IBM_PLEX_MONO = "${selfPackages.ibm-plex-mono}/share/fonts/woff2";

            shellHook = ''
              just assets
            '';
          };
        }
      );

      packages = forAllSystems (
        { pkgs, ... }:
        {
          ibm-plex-mono = pkgs.callPackage ./ibm-plex-mono.nix { };
        }
      );

      formatter = forAllSystems ({ treefmt, ... }: treefmt);
    };
}

{
  description = "static blog";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      pkgsForSystem =
        system:
        import nixpkgs {
          inherit system;
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:

      let
        pkgs = pkgsForSystem system;
        lib = pkgs.lib;
      in
      rec {
        packages = rec {
          blog = pkgs.stdenv.mkDerivation rec {
            pname = "static-website";
            version = "0.1.0";
            src = lib.fileset.toSource {
              root = ./.;
              fileset = lib.fileset.unions [
                ./config.toml
                ./content
                ./templates
                ./sass
                ./static
              ];
            };
            nativeBuildInputs = with pkgs; [
              zola
            ];
            buildPhase = ''
              zola build -o $out
            '';
            dontInstall = true;
          };
          default = blog;

        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ zola ];
        };
      }
    );
}

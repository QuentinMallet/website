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
      latex_build = texfile: ''
        lualatex $src/${texfile}.tex
        mkdir -p $out/
        mv ${texfile}.pdf $out/
      '';
      mk_cv = filename: pkgs: pkgs.stdenv.mkDerivation {
            name = "cv";
            src = ./cv;
            dontUnpack = true;
            dontInstall = true;
            #nativeBuildInputs =  [pkgs.breakpointHook];
            buildInputs = [
              (pkgs.texlive.withPackages (
                ps: with ps; [
                  babel-french
                  etoolbox
                  hyperref
                  koma-script
                  marginnote
                  marvosym
                  ragged2e
                  scheme-full
                  tools
                ]
              ))
            ];

            TEXMFHOME = "$TMPDIR";
            TEXMFVAR = "$TMPDIR";
            TEXMFCONFIG = "$TMPDIR";
            buildPhase = latex_build filename;

          };


    in
    flake-utils.lib.eachDefaultSystem (
      system:

      let
        pkgs = pkgsForSystem system;
      in
      rec {
        packages = rec {
          blog = pkgs.stdenv.mkDerivation rec {
            pname = "static-website";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = with pkgs; [
              hugo
              pandoc
            ];
          };
          cv = mk_cv "cv" pkgs;
          cv_en = mk_cv "cv_en" pkgs;
          lettre = pkgs.stdenv.mkDerivation {
            name = "lettre";
            src = ./lettre;
            dontUnpack = true;
            dontInstall = true;

            buildInputs = [
              (pkgs.texlive.withPackages (
                ps: with ps; [
                  babel-french
                  lettre
                  scheme-full
                  toolbox
                ]
              ))
            ];
            TEXMFHOME = "$TMPDIR";
            TEXMFVAR = "$TMPDIR";
            TEXMFCONFIG = "$TMPDIR";

            buildPhase = latex_build "lettre_de_motivation";
          };

          default = self.packages.${system}.cv;

        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ hugo ];
        };
      }
    );
}

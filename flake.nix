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
      mkCv =
        filename: pkgs:
        pkgs.stdenv.mkDerivation {
          name = filename;
          src = ./cv;
          dontUnpack = true;
          dontInstall = true;
          buildInputs = [
            (pkgs.texlive.withPackages (
              ps: with ps; [
                babel-french
                carlisle
                etoolbox
                hyperref
                koma-script
                latex-bin
                luahbtex
                luaotfload
                marginnote
                marvosym
                ragged2e
                tools
              ]
            ))
          ];
          TEXMFHOME = "$TMPDIR";
          TEXMFVAR = "$TMPDIR";
          TEXMFCONFIG = "$TMPDIR";
          buildPhase = ''
            lualatex $src/${filename}.tex
            mkdir -p $out/
            mv ${filename}.pdf $out/
          '';
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:

      let
        pkgs = pkgsForSystem system;
        inherit (pkgs) lib;
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
          cv = mkCv "cv" pkgs;
          cv_en = mkCv "cv_en" pkgs;
          site = pkgs.runCommand "site" { } ''
            cp -r ${blog} $out
            chmod -R u+w $out
            cp ${cv}/cv.pdf $out/cv.pdf
            cp ${cv_en}/cv_en.pdf $out/cv_en.pdf
          '';
          default = site;

        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ zola ];
        };
      }
    );
}

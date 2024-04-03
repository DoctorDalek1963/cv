{
  description = "Dyson's CV";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      perSystem = {pkgs, ...}: let
        # NOTE: A list of all available pkgs.texlive.* packages is available here:
        # https://raw.githubusercontent.com/NixOS/nixpkgs/nixos-23.11/pkgs/tools/typesetting/tex/texlive/tlpdb.nix
        texlive = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-basic latexmk sectsty;
        };

        buildInputs = [pkgs.coreutils texlive];
      in {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;
        };

        packages = rec {
          default = cv;

          cv = pkgs.callPackage (
            {stdenvNoCC}:
              stdenvNoCC.mkDerivation rec {
                name = "dysons-cv";
                src = self;

                inherit buildInputs;

                buildPhase = ''
                  mkdir -p .cache/texmf-var
                  env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
                    SOURCE_DATE_EPOCH=${toString self.lastModified} \
                    latexmk -pdf -lualatex -usepretex \
                    -pretex="\pdfvariable suppressoptionalinfo 512\relax" \
                    -interaction=nonstopmode -file-line-error -halt-on-error -shell-escape \
                    main.tex
                '';

                installPhase = ''
                  mkdir $out
                  cp main.pdf $out/cv.pdf
                '';
              }
          ) {};
        };
      };
    };
}

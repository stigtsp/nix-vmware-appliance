{ pkgs ? import <nixpkgs> {} }:
let perlEnv = pkgs.perl.withPackages(p: with p; [ Mojolicious ]);
in {
  mojo-app  = pkgs.stdenv.mkDerivation {
    name = "Mojo-App";
    propagatedBuildInputs = [ perlEnv ];
    src = ./mojo-app;
    postPath = ''
        patchShebangs app.pl
    '';
    installPhase = ''
        mkdir -p $out/bin
        cp app.pl $out/bin/app.pl
        chmod +x $out/bin/app.pl
    '';
  };

}

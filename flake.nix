{
  description = "Komga with desktop launcher";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = nixpkgs.lib;

        komgaJar = pkgs.fetchurl {
          url = "https://sourceforge.net/projects/komga.mirror/files/1.21.3/komga-1.21.3.jar/download";
          sha256 = "sha256-NFj/C1oNRh9PzAi5TUv+4vVea1Nsn/frxf4aZjuYfvA=";
        };

        startScript = pkgs.writeShellScriptBin "komga-start" ''
          exec ${pkgs.jdk17}/bin/java -jar ${komgaJar} &
          sleep 3
          ${pkgs.xdg-utils}/bin/xdg-open http://localhost:25600
        '';

        desktopFile = pkgs.writeTextFile {
          name = "komga.desktop";
          destination = "/share/applications/komga.desktop";
          text = ''
            [Desktop Entry]
            Name=Komga
            Comment=Launch Komga server and open web UI
            Exec=${startScript}/bin/komga-start
            Icon=komga
            Terminal=false
            Type=Application
            Categories=Office;
          '';
        };

        iconFile = pkgs.stdenv.mkDerivation {
          name = "komga-icon";
          src = builtins.path {
            name = "komga-assets";
            path = ./assets;
          };
          installPhase = ''
            mkdir -p $out/share/icons
            cp $src/komga.png $out/share/icons/
          '';
        };


        komgaPkg = pkgs.buildEnv {
          name = "komga-with-launcher";
          paths = [ startScript desktopFile iconFile ];
        };

      in {
        packages.default = komgaPkg;

        apps.default = flake-utils.lib.mkApp {
          drv = komgaPkg;
          name = "komga-start";
        };
      });
}

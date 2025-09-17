{
  description = "Interactive Brokers TWS derivation (installer-free extraction)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in {
      packages = forAll (pkgs:
        let
          pname = "ib-tws";
          version = "latest";
        in {
          ${pname} = pkgs.stdenvNoCC.mkDerivation {
            inherit pname version;

            src = pkgs.fetchurl {
              url = "https://download2.interactivebrokers.com/installers/tws/latest-standalone/tws-latest-standalone-linux-x64.sh";
              sha256 = "";
            };

            nativeBuildInputs = [
              pkgs.gnutar
              pkgs.gzip
              pkgs.findutils
              pkgs.coreutils
              pkgs.makeWrapper
              pkgs.bash
            ];

            dontUnpack = true;

            buildPhase = ''
              set -e
              mkdir work
              cp $src work/installer.sh
              chmod +x work/installer.sh
              cd work
              ./installer.sh __i4j_extract_and_exit
              tar xf sfx_archive.tar
              if [ -f jre.tar.gz ]; then
                gunzip jre.tar.gz
                mkdir jre
                tar xf jre.tar -C jre
              fi
            '';

            installPhase = ''
              set -e
              install -d $out/share/ib-tws
              cp -r work/* $out/share/ib-tws
              rm -f $out/share/ib-tws/sfx_archive.tar
              install -d $out/bin
              cat > $out/bin/tws <<EOF
              #!${pkgs.bash}/bin/bash
              set -euo pipefail
              app_root="$out/share/ib-tws"
              if [ -x "$app_root/tws" ]; then
                exec "$app_root/tws" "\$@"
              fi
              if [ -x "$app_root/bin/tws" ]; then
                exec "$app_root/bin/tws" "\$@"
              fi
              if [ -x "$app_root/jre/bin/java" ] && [ -f "$app_root/launcher0.jar" ] && [ -f "$app_root/i4jruntime.jar" ]; then
                exec "$app_root/jre/bin/java" "--add-opens" "java.desktop/java.awt=ALL-UNNAMED" -classpath "$app_root/i4jruntime.jar:$app_root/launcher0.jar" install4j.RuntimeLauncher "\$@"
              fi
              if command -v java >/dev/null 2>&1 && [ -f "$app_root/launcher0.jar" ] && [ -f "$app_root/i4jruntime.jar" ]; then
                exec java "--add-opens" "java.desktop/java.awt=ALL-UNNAMED" -classpath "$app_root/i4jruntime.jar:$app_root/launcher0.jar" install4j.RuntimeLauncher "\$@"
              fi
              echo "Unable to find a TWS launcher. Inspect \$out/share/ib-tws to pick the right entrypoint." >&2
              exit 1
              EOF
              chmod +x $out/bin/tws

              install -d $out/share/applications
              cat > $out/share/applications/ib-tws.desktop <<EOF
              [Desktop Entry]
              Name=IB TWS
              Exec=$out/bin/tws
              Type=Application
              Categories=Finance;Office;
              Terminal=false
              EOF
            '';

            meta = with pkgs.lib; {
              homepage = "https://www.interactivebrokers.com/";
              platforms = [ "x86_64-linux" ];
              license = licenses.unfreeRedistributable;
              description = "Interactive Brokers Trader Workstation, extracted from install4j payload";
              mainProgram = "tws";
            };
          };
        });

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.ib-tws;
      defaultApp.x86_64-linux = {
        type = "app";
        program = "${self.packages.x86_64-linux.ib-tws}/bin/tws";
      };
    };
}

{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  twsWrap = builtins.toFile "tws-wrap.sh" ''
    #!/bin/sh
    export INSTALL4J_JAVA_HOME_OVERRIDE='__JAVAHOME__'
    mkdir -p $HOME/.tws
    VMOPTIONS=$HOME/.tws/tws.vmoptions
    if [ ! -e "$VMOPTIONS" ]; then
        cp __OUT__/libexec/tws.vmoptions $HOME/.tws/ 2>/dev/null || true
    fi
    # The vm options file should always refer to itself
    if [ -f "$VMOPTIONS" ]; then
        sed -i -e "s#-DvmOptionsPath=.*#-DvmOptionsPath=$VMOPTIONS#" "$VMOPTIONS"
    fi
    export LD_LIBRARY_PATH=__GTK__/lib:__CCLIBS__/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    exec "__OUT__/libexec/tws" \
      -J-DjtsConfigDir=$HOME/.tws \
      -J-Djxbrowser.chromium.dir=/tmp/jxbrowser \
      -J-Dawt.useSystemAAFontSettings=lcd \
      -J-Dswing.aatext=true \
      "$@"
  '';

  ibDerivation = stdenv.mkDerivation rec {
    version = "latest";
    pname = "ib-tws-native";

    src = fetchurl {
      url = "https://download2.interactivebrokers.com/installers/tws/latest-standalone/tws-latest-standalone-linux-x64.sh";
      sha256 = "sha256-hdPlahml3BHEyBnMW2IMXy0cHFgnu7e83zIyYBg1+8w=";
      executable = true;
    };

    nativeBuildInputs = [ 
      makeWrapper
      gnutar
      gzip
    ];

    buildInputs = [
      openjdk17
    ];

    # Only build locally for license reasons
    preferLocalBuild = true;
    allowSubstitutes = false;

    phases = [ "installPhase" ];

    installPhase = ''
      echo "Extracting TWS installer manually..."
      
      mkdir -p $out/libexec
      cd $out/libexec
      
      # The installer script shows it uses this exact command to extract the archive:
      # tail -c 95489020 "$prg_dir/$progname" > sfx_archive.tar.gz
      echo "Extracting archive using method from installer script..."
      
      # First try the exact method from the installer script
      tail -c 95489020 ${src} > sfx_archive.tar.gz 2>/dev/null || \
        tail -95489020c ${src} > sfx_archive.tar.gz 2>/dev/null
      
      # Check if we got a valid gzip file
      if ! gunzip -t sfx_archive.tar.gz 2>/dev/null; then
        echo "First extraction attempt failed, trying to find archive boundary..."
        
        # Look for the binary data marker or try to find where the shell script ends
        script_end=$(grep -a -b -o "^exit.*" ${src} | tail -1 | cut -d: -f1 2>/dev/null || echo "0")
        if [ "$script_end" != "0" ]; then
          echo "Found script end at offset $script_end, extracting from there..."
          tail -c +$((script_end + 50)) ${src} > sfx_archive.tar.gz
        else
          echo "Trying to find gzip magic bytes..."
          # Look for gzip magic bytes (1f 8b)
          offset=$(hexdump -C ${src} | grep -m1 "1f 8b" | cut -d' ' -f1 | head -1)
          if [ -n "$offset" ]; then
            decimal_offset=$((0x$offset))
            echo "Found gzip signature at offset $decimal_offset"
            tail -c +$decimal_offset ${src} > sfx_archive.tar.gz
          else
            echo "Could not find archive, listing file structure..."
            file ${src}
            hexdump -C ${src} | head -20
            exit 1
          fi
        fi
      fi
      
      echo "Decompressing and extracting..."
      if ! gunzip sfx_archive.tar.gz; then
        echo "Failed to decompress archive"
        file sfx_archive.tar.gz
        exit 1
      fi
      
      if ! tar xf sfx_archive.tar; then
        echo "Failed to extract tar archive"
        file sfx_archive.tar
        exit 1
      fi
      
      rm -f sfx_archive.tar
      
      # Look for the main TWS executable/script
      if [ -f tws ]; then
        echo "Found tws launcher"
        chmod +x tws
      else
        # Find tws in subdirectories
        tws_path=$(find . -name "tws" -type f | head -1)
        if [ -n "$tws_path" ]; then
          echo "Found tws launcher at: $tws_path"
          cp "$tws_path" ./tws
          chmod +x tws
        else
          echo "TWS launcher not found, listing contents:"
          find . -name "*tws*" -o -name "*.sh" | head -10
          echo "Directory structure:"
          ls -la
        fi
      fi

      # Patch the tws script to use our Java and disable JVM compatibility check
      if [ -f $out/libexec/tws ]; then
        echo "Patching tws launcher script..."
        
        # Disable JRE compatibility check - force use our Java
        sed -i 's#test_jvm "$INSTALL4J_JAVA_HOME_OVERRIDE"#app_java_home="$INSTALL4J_JAVA_HOME_OVERRIDE"#' $out/libexec/tws
        
        # Make the launcher read vmoptions from ~/.tws instead of the store
        sed -i -e 's#read_vmoptions "$prg_dir/$progname.vmoptions"#read_vmoptions "$HOME/.tws/$progname.vmoptions"#' $out/libexec/tws
        
        # Update Java version check to accept our Java 17+
        sed -i 's#if \[ "$ver_major" -lt "17" \]; then#if [ "$ver_major" -lt "17" ] \&\& [ "$INSTALL4J_JAVA_HOME_OVERRIDE" = "" ]; then#' $out/libexec/tws
        
        echo "TWS script patched successfully"
      else
        echo "Warning: tws script not found at expected location"
        ls -la $out/libexec/
      fi

      # Create wrapper script
      mkdir -p $out/bin
      sed -e "s#__OUT__#$out#g" \
          -e "s#__JAVAHOME__#${openjdk17.home}#g" \
          -e "s#__GTK__#${gtk3}#g" \
          -e "s#__CCLIBS__#${stdenv.cc.cc.lib}#g" \
          ${twsWrap} > $out/bin/ib-tws-native

      chmod +x $out/bin/ib-tws-native

      # Copy vmoptions template if it exists
      if [ -f $out/libexec/tws.vmoptions ]; then
        echo "Found tws.vmoptions template"
      else
        echo "Creating default tws.vmoptions"
        cat > $out/libexec/tws.vmoptions << EOF
-Xmx4g
-XX:MaxPermSize=256m
-Dsun.java2d.d3d=false
-Dsun.java2d.noddraw=true
-Dswing.aatext=true
-Dawt.useSystemAAFontSettings=lcd
EOF
      fi
    '';

    meta = with lib; {
      description = "Interactive Brokers Trader Workstation";
      longDescription = ''
        Trader Workstation (TWS) is Interactive Brokers' flagship trading platform.
        This package wraps the official Linux installer to work on NixOS.
      '';
      homepage = "https://www.interactivebrokers.com/en/trading/tws.php";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = [ ];
    };
  };

in buildFHSEnv {
  name = "ib-tws";
  
  targetPkgs = pkgs: with pkgs; [
    ibDerivation
    openjdk17

    # GUI dependencies
    gtk3
    glib
    cairo
    pango
    gdk-pixbuf
    atk

    # X11 dependencies  
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXtst
    xorg.libXrender
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXrandr
    xorg.libxcb
    xorg.libxshmfence
    libxkbcommon

    # Chromium/JxBrowser dependencies
    alsa-lib
    nspr
    nss
    cups
    mesa
    expat
    dbus
    libdrm
    
    # Standard libraries
    zlib
    libgcc
    glibc
    stdenv.cc.cc.lib
    
    # Font rendering
    fontconfig
    freetype
  ];

  multiPkgs = pkgs: with pkgs; [
    # 32-bit support might be needed
  ];

  runScript = "/bin/ib-tws-native";

  # Set up environment
  extraBuildCommands = ''
    # Ensure proper library paths
    mkdir -p usr/lib
    ln -s ${pkgs.stdenv.cc.cc.lib}/lib/* usr/lib/
  '';

  profile = ''
    # Font configuration
    export FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf
    export FONTCONFIG_PATH=${pkgs.fontconfig.out}/etc/fonts
    
    # Java configuration  
    export JAVA_HOME=${pkgs.openjdk17.home}
    export PATH=${pkgs.openjdk17}/bin:$PATH
  '';
}
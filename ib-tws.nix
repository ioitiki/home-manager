{ pkgs }:

let
  # Download the installer
  twsInstaller = pkgs.fetchurl {
    url = "https://download2.interactivebrokers.com/installers/tws/latest-standalone/tws-latest-standalone-linux-x64.sh";
    sha256 = "sha256-n//oR6nI/OORd8JFL4tuR4NAq8TVNCoVa1HD2S1bIVo=";
  };
  
  # Create an FHS environment for TWS
  twsFHS = pkgs.buildFHSEnv {
    name = "ib-tws";
    
    targetPkgs = pkgs: with pkgs; [
      # Java runtime requirements
      jdk17
      zlib
      freetype
      fontconfig
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
      xorg.libXrandr
      alsa-lib
      # GTK and desktop integration
      gtk3
      glib
      pango
      cairo
      gdk-pixbuf
      atk
      # Additional libraries that might be needed
      libGL
      libglvnd
      nspr
      nss
      libdrm
      mesa
      expat
      libxkbcommon
      # System utilities
      coreutils
      bash
      which
      procps
    ];
    
    multiPkgs = pkgs: with pkgs; [
      # 32-bit libraries if needed
      zlib
      freetype
      fontconfig
    ];
    
    runScript = pkgs.writeScript "tws-launcher" ''
      #!${pkgs.bash}/bin/bash
      set -e
      
      TWS_HOME="$HOME/.local/share/ib-tws"
      TWS_INSTALLER="${twsInstaller}"
      
      # Check if TWS is installed
      if [ ! -d "$TWS_HOME" ]; then
        echo "TWS not found at $TWS_HOME"
        echo "First time setup - running installer..."
        echo ""
        echo "Please follow the installer prompts."
        echo "Default installation directory: $TWS_HOME"
        echo ""
        mkdir -p "$TWS_HOME"
        
        # Copy installer to temp location
        TEMP_INSTALLER="/tmp/tws-installer-$$.sh"
        cp "$TWS_INSTALLER" "$TEMP_INSTALLER"
        chmod +x "$TEMP_INSTALLER"
        
        # Run installer
        "$TEMP_INSTALLER"
        rm -f "$TEMP_INSTALLER"
        
        echo ""
        echo "Installation complete. You can now run 'tws' to start TWS."
        exit 0
      fi
      
      # Find and run TWS
      if [ -x "$TWS_HOME/tws" ]; then
        cd "$TWS_HOME"
        exec "$TWS_HOME/tws" "$@"
      elif [ -d "$TWS_HOME/Trader Workstation 10.40" ] && [ -x "$TWS_HOME/Trader Workstation 10.40/tws" ]; then
        cd "$TWS_HOME/Trader Workstation 10.40"
        exec "./tws" "$@"
      else
        echo "TWS executable not found in $TWS_HOME"
        echo "You may need to reinstall. Delete $TWS_HOME and run this command again."
        exit 1
      fi
    '';
    
    profile = ''
      export JAVA_HOME="${pkgs.jdk17}"
      export PATH="$JAVA_HOME/bin:$PATH"
    '';
  };
  
in twsFHS
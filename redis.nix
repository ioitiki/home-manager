{ pkgs, lib, config, ... }:

let
  # Build RedisJSON from source
  redisJSON = pkgs.stdenv.mkDerivation rec {
    pname = "redisjson";
    version = "unstable-2024-09-18";

    src = pkgs.fetchFromGitHub {
      owner = "RedisJSON";
      repo = "RedisJSON";
      rev = "master";
      sha256 = "0p8qr0irc49sg6za9cyir9gn4k7740xxv2ys0gh54yj8kj9kch0p";
    };

    nativeBuildInputs = with pkgs; [
      cargo
      rustc
      rustfmt
      pkg-config
      clang
    ];

    buildInputs = with pkgs; [
      openssl
    ];

    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

    buildPhase = ''
      export HOME=$(mktemp -d)
      cargo build --release
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp target/release/librejson.so $out/lib/
    '';
  };

  # Redis configuration
  redisPort = 6379;
  redisDataDir = "${config.home.homeDirectory}/.local/share/redis";
  redisLogDir = "${config.home.homeDirectory}/.local/share/redis/logs";
  redisPidFile = "${config.home.homeDirectory}/.local/share/redis/redis.pid";
  
  # ACL configuration
  redisAcl = pkgs.writeText "redis.acl" ''
    user default off
    user andy on >passw0rd ~* &* +@all
  '';

  # Main Redis configuration
  redisConf = pkgs.writeText "redis.conf" ''
    # Network
    bind 127.0.0.1
    port ${toString redisPort}
    protected-mode yes
    tcp-keepalive 300
    timeout 0

    # General
    daemonize no
    supervised no
    pidfile ${redisPidFile}
    loglevel notice
    logfile ${redisLogDir}/redis.log

    # Persistence
    dir ${redisDataDir}
    save 900 1
    save 300 10
    save 60 10000

    # Memory
    maxmemory 256mb
    maxmemory-policy allkeys-lru

    # ACL
    aclfile ${redisAcl}

    # Modules
    loadmodule ${redisJSON}/lib/librejson.so
  '';

in {
  # Install Redis package
  home.packages = with pkgs; [
    redis
  ];

  # Create necessary directories
  home.activation.redisSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${redisDataDir}
    mkdir -p ${redisLogDir}
  '';

  # Systemd user service for Redis
  systemd.user.services.redis = {
    Unit = {
      Description = "Redis Server with RedisJSON";
      After = [ "default.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.redis}/bin/redis-server ${redisConf}";
      Restart = "on-failure";
      RestartSec = "5s";
      
      # Hardening
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      ReadWritePaths = [ redisDataDir redisLogDir ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Convenience script to interact with Redis
  home.file.".local/bin/redis-local" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} "$@"
    '';
  };
}

{ pkgs, lib, config, ... }:

let
  redisPort = 6379;
  redisDataDir = "${config.home.homeDirectory}/.local/share/redis-docker";
  
  # Docker compose file for Redis with RedisJSON
  dockerComposeFile = pkgs.writeText "docker-compose.yml" ''
    services:
      redis:
        image: redis/redis-stack-server:latest
        container_name: redis-rejson
        ports:
          - "${toString redisPort}:6379"
        volumes:
          - ${redisDataDir}/data:/data
        environment:
          - REDIS_ARGS=--requirepass passw0rd
        restart: unless-stopped
        healthcheck:
          test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
          interval: 1s
          timeout: 3s
          retries: 5
  '';

  # Redis configuration file for Docker
  redisConf = pkgs.writeText "redis.conf" ''
    # Network
    bind 0.0.0.0
    port 6379
    protected-mode yes
    tcp-keepalive 300
    timeout 0

    # General
    daemonize no
    loglevel notice
    logfile ""

    # Persistence
    dir /data
    save 900 1
    save 300 10
    save 60 10000
    
    # Snapshots
    dbfilename dump.rdb
    rdbcompression yes
    rdbchecksum yes

    # Memory
    maxmemory 256mb
    maxmemory-policy allkeys-lru

    # Security
    requirepass passw0rd

    # RedisJSON is built into redis-stack-server image
  '';

in {
  # Install required packages
  home.packages = with pkgs; [
    redis # For redis-cli
    docker-compose
  ];

  # Enable systemd user service linger
  home.activation.enableLinger = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.systemd}/bin/loginctl enable-linger $(whoami)
  '';

  # Create necessary directories and files
  home.activation.redisDockerSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${redisDataDir}/data
    mkdir -p ${redisDataDir}/conf
    
    # Copy configuration file
    cp ${redisConf} ${redisDataDir}/conf/redis.conf
    
    # Copy docker-compose file
    cp ${dockerComposeFile} ${redisDataDir}/docker-compose.yml
    
    # Set proper permissions
    chmod 700 ${redisDataDir}
    chmod 644 ${redisDataDir}/conf/redis.conf
    chmod 644 ${redisDataDir}/docker-compose.yml
  '';

  # Systemd user service for Redis using Docker
  systemd.user.services.redis = {
    Unit = {
      Description = "Redis Server with RedisJSON (Docker)";
      After = [ "default.target" ];
      Requires = [ "docker.service" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = redisDataDir;
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      ExecReload = "${pkgs.docker-compose}/bin/docker-compose restart";
      Restart = "on-failure";
      RestartSec = "10s";
      TimeoutStartSec = "60s";
      TimeoutStopSec = "30s";
      
      # Environment
      Environment = [
        "HOME=${config.home.homeDirectory}"
        "PATH=${lib.makeBinPath [ pkgs.docker pkgs.docker-compose ]}"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Convenience scripts
  home.file.".local/bin/redis-local" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd "$@"
    '';
  };

  home.file.".local/bin/redis-status" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      echo "=== Docker Container Status ==="
      cd ${redisDataDir}
      ${pkgs.docker-compose}/bin/docker-compose ps
      
      echo -e "\n=== Redis Server Info ==="
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd info server 2>/dev/null || echo "Redis not responding"
      
      echo -e "\n=== Loaded Modules ==="
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd MODULE LIST 2>/dev/null || echo "Redis not responding"
    '';
  };

  home.file.".local/bin/redis-test-json" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      echo "Testing RedisJSON functionality..."
      
      echo "1. Checking loaded modules:"
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd MODULE LIST
      
      echo -e "\n2. Setting JSON data:"
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd JSON.SET test:user $ '{"name":"Andy","role":"CTO","skills":["trading","kubernetes","nixos"]}'
      
      echo -e "\n3. Getting JSON data:"
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd JSON.GET test:user
      
      echo -e "\n4. Getting specific path:"
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd JSON.GET test:user $.name
      
      echo -e "\n5. Getting array elements:"
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd JSON.GET test:user $.skills[0]
    '';
  };

  home.file.".local/bin/redis-docker-logs" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      cd ${redisDataDir}
      ${pkgs.docker-compose}/bin/docker-compose logs -f redis
    '';
  };

  home.file.".local/bin/redis-docker-restart" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      cd ${redisDataDir}
      ${pkgs.docker-compose}/bin/docker-compose restart redis
      echo "Redis container restarted"
    '';
  };
}
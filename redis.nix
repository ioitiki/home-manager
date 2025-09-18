{ pkgs, lib, config, ... }:

let
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

  # Redis configuration - using only built-in features
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
    
    # Snapshots
    dbfilename dump.rdb
    rdbcompression yes
    rdbchecksum yes

    # Memory
    maxmemory 256mb
    maxmemory-policy allkeys-lru

    # Security
    aclfile ${redisAcl}
    requirepass passw0rd

    # Enable all built-in data structures
    # Hash max entries optimizations
    hash-max-ziplist-entries 512
    hash-max-ziplist-value 64
    
    # List optimizations
    list-max-ziplist-size -2
    list-compress-depth 0
    
    # Set optimizations
    set-max-intset-entries 512
    
    # Sorted set optimizations
    zset-max-ziplist-entries 128
    zset-max-ziplist-value 64
    
    # HyperLogLog optimizations
    hll-sparse-max-bytes 3000
  '';

in {
  # Install Redis package (uses pre-built binary from nixpkgs)
  home.packages = with pkgs; [
    redis
    # Optional: Redis tools
    # redis-commander  # Web UI for Redis (if available)
  ];

  # Enable systemd user service linger to start services on boot
  # This allows user services to start without logging in
  home.activation.enableLinger = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.systemd}/bin/loginctl enable-linger $(whoami)
  '';

  # Create necessary directories
  home.activation.redisSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${redisDataDir}
    mkdir -p ${redisLogDir}
    
    # Set proper permissions
    chmod 700 ${redisDataDir}
    chmod 700 ${redisLogDir}
    
    # Create initial ACL file if it doesn't exist
    if [ ! -f ${redisDataDir}/redis.acl ]; then
      cp ${redisAcl} ${redisDataDir}/redis.acl
      chmod 600 ${redisDataDir}/redis.acl
    fi
  '';

  # Systemd user service for Redis
  systemd.user.services.redis = {
    Unit = {
      Description = "Redis Server";
      After = [ "default.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.redis}/bin/redis-server ${redisConf}";
      ExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStopSec = "10s";
      
      # Environment
      Environment = [
        "HOME=${config.home.homeDirectory}"
      ];
      
      # Hardening
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = "read-only";
      ReadWritePaths = [ 
        redisDataDir 
        redisLogDir 
        "${config.home.homeDirectory}/.local/share/redis"
      ];
      
      # Additional hardening
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = false; # Redis needs this for some operations
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      PrivateDevices = true;
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
      exec ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd "$@"
    '';
  };

  # Redis status and monitoring script
  home.file.".local/bin/redis-status" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      echo "=== Redis System Status ==="
      systemctl --user status redis --no-pager
      
      echo -e "\n=== Redis Server Info ==="
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd info server 2>/dev/null || echo "Redis not responding"
      
      echo -e "\n=== Redis Memory Info ==="
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd info memory 2>/dev/null || echo "Redis not responding"
      
      echo -e "\n=== Redis Stats ==="
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd info stats 2>/dev/null || echo "Redis not responding"
      
      echo -e "\n=== Connected Clients ==="
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd client list 2>/dev/null || echo "Redis not responding"
    '';
  };

  # Redis benchmark script
  home.file.".local/bin/redis-benchmark-local" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      echo "Running Redis benchmark on local instance..."
      ${pkgs.redis}/bin/redis-benchmark -p ${toString redisPort} -a passw0rd "$@"
    '';
  };

  # Redis backup script
  home.file.".local/bin/redis-backup" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      BACKUP_DIR="${config.home.homeDirectory}/.local/share/redis/backups"
      TIMESTAMP=$(date +%Y%m%d_%H%M%S)
      
      mkdir -p "$BACKUP_DIR"
      
      echo "Creating Redis backup..."
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd BGSAVE
      
      # Wait for background save to complete
      while [ "$(${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd LASTSAVE)" = "$(${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd LASTSAVE)" ]; do
        sleep 1
      done
      
      # Copy the dump file
      if [ -f "${redisDataDir}/dump.rdb" ]; then
        cp "${redisDataDir}/dump.rdb" "$BACKUP_DIR/dump_$TIMESTAMP.rdb"
        echo "Backup created: $BACKUP_DIR/dump_$TIMESTAMP.rdb"
        
        # Keep only last 10 backups
        ls -t "$BACKUP_DIR"/dump_*.rdb | tail -n +11 | xargs -r rm
      else
        echo "Error: dump.rdb not found"
        exit 1
      fi
    '';
  };

  # Redis restore script
  home.file.".local/bin/redis-restore" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      if [ $# -ne 1 ]; then
        echo "Usage: $0 <backup_file>"
        echo "Available backups:"
        ls -la "${config.home.homeDirectory}/.local/share/redis/backups/"
        exit 1
      fi
      
      BACKUP_FILE="$1"
      
      if [ ! -f "$BACKUP_FILE" ]; then
        echo "Error: Backup file not found: $BACKUP_FILE"
        exit 1
      fi
      
      echo "Stopping Redis..."
      systemctl --user stop redis
      
      echo "Restoring from backup..."
      cp "$BACKUP_FILE" "${redisDataDir}/dump.rdb"
      
      echo "Starting Redis..."
      systemctl --user start redis
      
      echo "Restore complete"
    '';
  };

  # Development helper - Redis test data loader
  home.file.".local/bin/redis-load-test-data" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      echo "Loading test data into Redis..."
      
      # Sample key-value pairs
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd SET "user:1000:name" "Andy"
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd SET "user:1000:email" "andy@example.com"
      
      # Hash example
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd HMSET "user:1001" name "John" email "john@example.com" age 30
      
      # List example
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd LPUSH "tasks" "Deploy to production" "Update documentation" "Review pull request"
      
      # Set example
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd SADD "tags" "redis" "database" "cache" "nosql"
      
      # Sorted set example
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd ZADD "leaderboard" 100 "player1" 85 "player2" 95 "player3"
      
      # Set expiration
      ${pkgs.redis}/bin/redis-cli -p ${toString redisPort} -a passw0rd SET "temp:session:abc123" "session_data" EX 3600
      
      echo "Test data loaded successfully"
      echo "Try: redis-local KEYS '*' to see all keys"
    '';
  };
}
{ pkgs, ... }:

{
  # Ensure the mount directory exists
  home.activation.createNfsMountPoint = {
    before = [ ];
    after = [ "writeBoundary" ];
    data = ''
      mkdir -p /home/andy/trading/mfa-trading/trading-bots/datasets
    '';
  };

  # Create a systemd user service to mount the NFS share
  systemd.user.services.nfs-mount-trading-datasets = {
    Unit = {
      Description = "Mount NFS share for trading datasets";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/andy/trading/mfa-trading/trading-bots/datasets";
      ExecStart = "${pkgs.util-linux}/bin/mount -t nfs 161.35.242.80:/ /home/andy/trading/mfa-trading/trading-bots/datasets";
      ExecStop = "${pkgs.util-linux}/bin/umount /home/andy/trading/mfa-trading/trading-bots/datasets";
      # Restart on failure
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}


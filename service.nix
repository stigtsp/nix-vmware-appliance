{ config, lib, pkgs, ... }:

  let
    localpkgs = pkgs.callPackage ./default.nix {};
    cfg = config.services.mojo-app;

in {

  options.services.mojo-app = {
    enable = lib.mkEnableOption "mojo-app";
    host = lib.mkOption {
        type = lib.types.str;
        default = "*";
        example = "127.0.0.1";
    };
    port = lib.mkOption {
        type = lib.types.int;
        default = 4000;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];
    systemd.services.mojo-app = {
      description = "A mojo-app test";
      environment = {
      };
      after = [ "network-online.target" ];
      wantedBy = [ "network-online.target" ];
      serviceConfig = {
        DynamicUser = "true";
        PrivateDevices = "true";
        ProtectKernelTunables = "true";
        ProtectKernelModules = "true";
        ProtectControlGroups = "true";
        RestrictAddressFamilies = "AF_INET AF_INET6";
        LockPersonality = "true";
        RestrictRealtime = "true";
        SystemCallFilter = "@system-service @network-io @signal";
        SystemCallErrorNumber = "EPERM";
        ExecStart = "${localpkgs.mojo-app}/bin/app.pl daemon --listen=http://${cfg.host}:${toString cfg.port}";
        Restart = "always";
        RestartSec = "5";
      };
        };
    };
}

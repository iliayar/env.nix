{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.postgres;
in {
  options = {
    services.postgres = {
      enable = mkEnableOption { default = false; };
      serve = mkOption {
        default = "local";
        type = types.enum [ "local" ];
      };
      defaultDatabase = mkOption { default = "postgres"; };
      autoStart = mkOption { default = false; };
    };
  };
  config = mkMerge [
    (mkIf cfg.enable {
      denv.packages = with pkgs; [
        postgresql_14

        (writeScriptBin "start_pg" ''
          pg_ctl start -l $LOG_PATH -o "-c listen_addresses= -c unix_socket_directories=$PGHOST"
          createdb 2>/dev/null|| echo "Database already exists"
        '')

        (writeScriptBin "stop_pg" ''
          pg_ctl stop
        '')
        (writeScriptBin "init_pg" ''
          if [ ! -d $PGHOST ]; then
            mkdir -p $PGHOST
          fi

          if [ ! -d $PGDATA ]; then
            echo "Initializing postgresql database..."
            initdb $PGDATA --auth=trust
          fi

        '')
      ];
    })
    (mkIf (cfg.enable && cfg.serve == "local") {
      denv.env = let
        pgRoot = "$PWD/.postgres";
        db = cfg.defaultDatabase;
      in rec {
        PGDATA = "${pgRoot}/postgres_data";
        PGHOST = "${pgRoot}/postgres";
        LOG_PATH = "${pgRoot}/postgres/LOG";
        PGDATABASE = db;
        DATABASE_URL = "postgresql://${db}?host=${PGHOST}";
      };

      denv.init = ''
        init_pg

        ${if cfg.autoStart then "start_pg" else ""}

        function end_pg() {
          stop_pg
        }

        trap end_pg EXIT
      '';
    })
  ];
}

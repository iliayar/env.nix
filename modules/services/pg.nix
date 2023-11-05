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
      denv.packages = with pkgs; [ postgresql_14 ];

      denv.scripts = {
        start_pg.text = ''
          pg_ctl start -l $LOG_PATH -o "-c listen_addresses= -c unix_socket_directories=$PGHOST"
          createdb 2>/dev/null|| echo "Database already exists"
        '';

        stop_pg.text = ''
          pg_ctl stop
        '';

        init_pg.text = ''
          if [ ! -d $PGHOST ]; then
            mkdir -p $PGHOST
          fi

          if [ ! -d $PGDATA ]; then
            echo "Initializing postgresql database..."
            initdb $PGDATA --auth=trust
          fi
        '';
      };
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

      denv.init = let
        autoStartStop = ''
          start_pg

          function end_pg() {
            stop_pg
          }

          trap end_pg EXIT
        '';
      in ''
        init_pg

        ${if cfg.autoStart then autoStartStop else ""}
      '';
    })
  ];
}

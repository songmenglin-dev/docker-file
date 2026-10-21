#!/bin/bash
# Export MySQL data via docker exec into the mysql8 container.
# All mysqldump arguments are passed through unchanged.
#
# Usage:
#   mysql8-export.sh <db>                              # whole database
#   mysql8-export.sh <db> <table>                      # single table
#   mysql8-export.sh <db>.<table>                      # same, dotted form
#   mysql8-export.sh --all-databases                   # every database
#   mysql8-export.sh <db> <table> --where="id>100"     # row filter
#   mysql8-export.sh <db> --no-data                    # schema only
#   mysql8-export.sh <db> --no-create-info             # data only
#   mysql8-export.sh -o backup.sql <db> <table>        # explicit output
#
# Default output filename: mysql8_<target>_<YYYYMMDD_HHMMSS>.sql

show_help() {
    cat <<'EOF'
Usage:
  mysql8-export.sh [options] <target> [mysqldump args...]

Targets (pick one as the first non-option argument):
  <db>                dump an entire database
  <db> <table>        dump a single table
  <db>.<table>        same as above, dotted form
  --all-databases     dump every database on the server

Options:
  -o, --output <file> write to <file> instead of the auto-generated name
  -h, --help          show this help and exit

mysqldump passthrough:
  Any argument not consumed above is forwarded to mysqldump inside the
  container. Common ones:

    --no-data               schema only, no rows
    --no-create-info        rows only, no CREATE TABLE
    --add-drop-table        prepend DROP TABLE before each CREATE
    --single-transaction    consistent snapshot for InnoDB
    --routines              include stored procedures and functions
    --triggers              include triggers (default: on)
    --events                include scheduled events
    --where="<expr>"        row filter when targeting a single table
    --default-character-set=utf8mb4

Default output filename:
  mysql8_<target>_<YYYYMMDD_HHMMSS>.sql
  where <target> is:
    "all"        for --all-databases
    "db_table"   for db.table
    "db"         for whole-database dumps

Examples:
  mysql8-export.sh appdb
  mysql8-export.sh appdb users
  mysql8-export.sh appdb.users
  mysql8-export.sh --all-databases
  mysql8-export.sh appdb -o /tmp/appdb.sql
  mysql8-export.sh appdb users --where="id > 100" --single-transaction
  mysql8-export.sh appdb --no-data --routines
  mysql8-export.sh appdb --no-create-info --where="created_at > '2026-01-01'"

Notes:
  - Runs `docker exec -i mysql8 mysqldump ...` against the running
    container named `mysql8`.
  - Root credentials are hardcoded inside this script. Run `mysql8-shell.sh
    bash` and `cat /root/docker-file/mysql8-docker-compose/mysql8-export.sh`
    to inspect them — never paste script output containing secrets into
    tickets / wikis / chat.
  - Requires the mysql8 container to be running. Start it with:
      cd /root/docker-file/mysql8-docker-compose && docker-compose up -d
EOF
}

OUT=""
ARGS=()
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)    show_help; exit 0 ;;
        -o|--output)  OUT="$2"; shift 2 ;;
        *)            ARGS+=("$1"); shift ;;
    esac
done

[ "${#ARGS[@]}" -gt 0 ] || {
    show_help >&2
    exit 1
}

FIRST="${ARGS[0]}"
case "$FIRST" in
    --all-databases) TARGET="all" ;;
    *.*)             TARGET="${FIRST//./_}" ;;
    *)               TARGET="$FIRST" ;;
esac

: "${OUT:=mysql8_${TARGET}_$(date +%Y%m%d_%H%M%S).sql}"

echo ">>> exporting ${ARGS[*]} -> $OUT"
docker exec -i mysql8 mysqldump -uroot -p'18162161837Xiner' "${ARGS[@]}" > "$OUT"
echo ">>> done: $(wc -l < "$OUT") lines, $(du -h "$OUT" | awk '{print $1}')"
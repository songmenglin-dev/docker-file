#!/bin/bash
# Import a SQL file from the host into the mysql8 container.
# The SQL file lives on the host; mysql client runs inside the container.
# All additional mysql client arguments are passed through.
#
# Usage:
#   mysql8-import.sh /path/to/file.sql                   # use SQL file's own USE statements
#   mysql8-import.sh /path/to/file.sql --database=appdb   # force a target database
#   mysql8-import.sh file.sql appdb                      # shorthand for --database=appdb

show_help() {
    cat <<'EOF'
Usage:
  mysql8-import.sh <sql-file> [mysql client args...]

Required:
  <sql-file>              path to a .sql file on the host (any location)

Common mysql client passthrough args:
  --database=<db>         target database (overrides USE statements in the file)
  --force                 continue on SQL errors
  --show-warnings         echo warnings to stdout
  --default-character-set=<cs>   e.g. utf8mb4
  --comments              preserve SQL comments in the stream (default)
  --skip-comments         strip SQL comments before execution

Tuning for big files:
  Combine with shell tools for progress / compression. The script only
  passes arguments to `docker exec` — piping is the host's responsibility:

    pv bigdump.sql | docker exec -i mysql8 mysql -uroot -p...

  Inside this script, `docker exec -i mysql8 mysql ... < "$FILE"` streams
  the file as stdin to the in-container client.

Examples:
  mysql8-import.sh ./backup.sql                          # honor SQL file's USE
  mysql8-import.sh ./backup.sql --database=appdb         # force target DB
  mysql8-import.sh ./appdb.sql appdb                     # shorthand
  mysql8-import.sh ./all-dbs.sql --force --show-warnings # full server dump
  mysql8-import.sh ./backup.sql --default-character-set=utf8mb4

Notes:
  - Runs `docker exec -i mysql8 mysql ... < <sql-file>`. The file is read
    from the host and streamed into the container's stdin.
  - Root credentials are hardcoded inside this script. Inspect with
    `mysql8-shell.sh bash -c 'cat ...'` — never paste script output that
    may include secrets into tickets / wikis / chat.
  - If the target database does not exist, you'll see
    `ERROR 1049 (42000): Unknown database '<db>'`. Create it first via
    `mysql8-shell.sh mysql -e "CREATE DATABASE <db> DEFAULT CHARACTER SET utf8mb4"`.
  - Requires the mysql8 container to be running. Start it with:
      cd /root/docker-file/mysql8-docker-compose && docker-compose up -d
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            show_help; exit 0 ;;
        *)
            # first non-option argument is the SQL file
            if [ -z "${FILE:-}" ]; then
                FILE="$1"
            else
                # any later arguments are passed to mysql client
                EXTRA_ARGS+=("$1")
            fi
            shift ;;
    esac
done

[ "${FILE:-}" ] || { show_help >&2; exit 1; }
[ -f "$FILE" ] || { echo "ERROR: file not found: $FILE" >&2; exit 1; }

SIZE=$(du -h "$FILE" | awk '{print $1}')
echo ">>> importing $FILE ($SIZE) into mysql8"
docker exec -i mysql8 mysql -uroot -p'18162161837Xiner' "${EXTRA_ARGS[@]}" < "$FILE"
echo ">>> done"
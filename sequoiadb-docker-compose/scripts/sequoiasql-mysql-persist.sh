#!/usr/bin/env bash
# sequoiasql-mysql-persist.sh — placeholder wrapper.
#
# Why this is just a passthrough: the SequoiaSQL-MySQL v5.0.1 image's instance
# registration lives on the container's local filesystem (NOT under
# /opt/sequoiasql/mysql/database, despite the entrypoint writing data there).
# A naive "copy data dir in/out" wrapper restores the data but the entrypoint
# still fails with `instance MySQLInstance3306 does not exist`, because the
# registration record is on the container's overlay filesystem, not the data
# dir, and not on any shared volume.
#
# The pragmatic persistence workflow is therefore:
#   1. `bash scripts/backup-catalog.sh`     (dumps MySQL catalog via mysqldump)
#   2. recreate container
#   3. `bash scripts/restore-catalog.sh <dump.sql>`   (restores the dump)
#
# This wrapper just runs the image's entrypoint unchanged.
set -uo pipefail

# Run the image's own entrypoint via bash (the entrypoint file has mode 0644
# and a broken shebang — it can only be invoked via bash, not exec'd).
exec bash /opt/docker-entrypoint.sh

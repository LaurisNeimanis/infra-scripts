#!/usr/bin/env bash
# backup.sh - Performs database and file backups with timestamped archives.
# Edit the variables below to configure paths, credentials, and retention policy.

set -euo pipefail

#### Configuration ####
# Directory where backups will be stored
BACKUP_DIR="/var/backups"
# Number of days to keep backups
RETENTION_DAYS=7

# Database settings (MySQL example)
DB_HOST="localhost"
DB_USER="backup_user"
DB_PASS="secret_password"
DB_NAME="my_database"

# Paths to include in file backup (space-separated list)
FILES_TO_BACKUP=("/etc/nginx" "/var/www/html")

# Optional email for notifications
EMAIL="admin@example.com"

#### Script ####
# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Timestamp for filenames
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Database dump
DB_DUMP="$BACKUP_DIR/${DB_NAME}_$TIMESTAMP.sql.gz"
if mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" | gzip > "$DB_DUMP"; then
    echo "[$TIMESTAMP] Database backup succeeded: $DB_DUMP"
else
    echo "[$TIMESTAMP] ERROR: Database backup failed!" | mail -s "Backup Failure: Database" "$EMAIL"
    exit 1
fi

# Files backup
ARCHIVE="$BACKUP_DIR/files_backup_$TIMESTAMP.tar.gz"
tar -czf "$ARCHIVE" "${FILES_TO_BACKUP[@]}" && \
    echo "[$TIMESTAMP] Files backup succeeded: $ARCHIVE" || \
    { echo "[$TIMESTAMP] ERROR: Files backup failed!" | mail -s "Backup Failure: Files" "$EMAIL"; exit 1; }

# Cleanup old backups
find "$BACKUP_DIR" -type f -mtime +$RETENTION_DAYS -name "*.gz" -exec rm -f {} +
echo "[$TIMESTAMP] Old backups older than $RETENTION_DAYS days have been removed."
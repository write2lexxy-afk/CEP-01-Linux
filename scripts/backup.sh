#!/bin/bash

# ==========================================
# CEP Enterprise Backup Script
# Project 02 - Secure OpenEMR Deployment
# Author: Alex Anyaehie
# Version: 2.0
# ==========================================

# ========= VARIABLES =========

DATE=$(date +%F_%H-%M-%S)

BACKUP_DIR="/home/lexxy/backups"

LOG_FILE="$BACKUP_DIR/backup.log"

DB_NAME="openemr"

DB_USER="openemruser"

WEB_DIR="/var/www/openemr"

APACHE_DIR="/etc/apache2"

SSL_DIR="/etc/apache2/ssl"

LOG_FILE="$BACKUP_DIR/backup.log"

RETENTION_DAYS=7
# ========= FUNCTIONS =========

# Displays the script banner
show_banner() {

    echo "==========================================="
    echo "      CEP Enterprise Backup Script"
    echo "     Project 02 - Secure OpenEMR"
    echo "==========================================="
    echo ""

}

# Writes messages to the backup log
write_log() {

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"

}

# Creates the backup directory if it does not exist
create_backup_directory() {

    echo "Creating backup directory..."

    mkdir -p "$BACKUP_DIR"

    echo "Backup directory ready."
    echo ""

}

# Creates a backup of the OpenEMR database
backup_database() {

    echo "Backing up OpenEMR database..."

    mysqldump -u "$DB_USER"  "$DB_NAME" \
    > "$BACKUP_DIR/openemr_$DATE.sql"

    if [ $? -eq 0 ]; then

        if [ -s "$BACKUP_DIR/openemr_$DATE.sql" ]; then

            echo "✓ Database backup completed successfully."

             write_log "Database backup completed successfully."


        else

            echo "✗ Database backup failed (backup file is empty)."

            write_log "ERROR: Database backup failed (backup file is empty)."

        fi

    else

        echo "✗ Database backup failed."

         write_log "ERROR: Database backup failed."


    fi

    echo ""



}

# Creates a compressed backup of the OpenEMR application files
backup_openemr_files() {

    echo "Backing up OpenEMR application files..."

    tar -czf "$BACKUP_DIR/openemr_files_$DATE.tar.gz" "$WEB_DIR"

    if [ $? -eq 0 ]; then

        if [ -s "$BACKUP_DIR/openemr_files_$DATE.tar.gz" ]; then

            echo "✓ OpenEMR files backup completed successfully."

            write_log "OpenEMR files backup completed successfully."

        else

            echo "✗ OpenEMR files backup failed (archive is empty)."

                write_log "ERROR: OpenEMR file backup failed (archive is empty)."

        fi

    else

        echo "✗ OpenEMR files backup failed."

         write_log "ERROR: OpenEMR file backup failed."

    fi

    echo ""

}

# Creates a compressed backup of the Apache configuration
backup_apache_config() {

    echo "Backing up Apache configuration..."

    tar -czf "$BACKUP_DIR/apache_config_$DATE.tar.gz" "$APACHE_DIR"

    if [ $? -eq 0 ]; then

        if [ -s "$BACKUP_DIR/apache_config_$DATE.tar.gz" ]; then

            echo "✓ Apache configuration backup completed successfully."

            write_log "Apache configuration backup completed successfully."

        else

            echo "✗ Apache configuration backup failed (archive is empty)."

          write_log "ERROR: Apache configuration backup failed (archive is empty)."

        fi

    else

        echo "✗ Apache configuration backup failed."

              write_log "ERROR: Apache configuration backup failed."

    fi

    echo ""

}

# Creates a compressed backup of the SSL certificates
backup_ssl() {

    echo "Backing up SSL certificates..."

    tar -czf "$BACKUP_DIR/ssl_$DATE.tar.gz" "$SSL_DIR"

    if [ $? -eq 0 ]; then

        if [ -s "$BACKUP_DIR/ssl_$DATE.tar.gz" ]; then

            echo "✓ SSL certificates backup completed successfully."
            write_log "SSL certificates backup completed successfully."

        else

            echo "✗ SSL certificates backup failed (archive is empty)."
             write_log "ERROR: SSL certificates backup failed (archive is empty)."

        fi

    else

        echo "✗ SSL certificates backup failed."
         write_log "ERROR: SSL certificates backup failed."

    fi

    echo ""

}



# Removes backup files older than the retention period
cleanup_old_backups() {

    echo "Cleaning up old backups..."

    find "$BACKUP_DIR" -type f -mtime +"$RETENTION_DAYS" -delete

    if [ $? -eq 0 ]; then

        echo "✓ Old backups cleaned successfully."

        write_log "Old backups cleaned successfully."

    else

        echo "✗ Failed to clean old backups."

        write_log "ERROR: Failed to clean old backups."

    fi

    echo ""

}


# Checks whether Apache service is running
check_apache_service() {

    echo "Checking Apache service..."

    if systemctl is-active --quiet apache2; then

        echo "✓ Apache service is running."

        write_log "Apache service is running."

    else

        echo "✗ Apache service is NOT running."

        write_log "ERROR: Apache service is NOT running."

    fi

    echo ""

}

# Checks whether MariaDB service is running
check_database_service() {

    echo "Checking MariaDB service..."

    if systemctl is-active --quiet mariadb; then

        echo "✓ MariaDB service is running."

        write_log "MariaDB service is running."

    else

        echo "✗ MariaDB service is NOT running."

        write_log "ERROR: MariaDB service is NOT running."

    fi

    echo ""

}

# Checks disk space usage
check_disk_space() {

echo "Checking disk space..."

DISK_USAGE=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')

if [ "$DISK_USAGE" -lt 70 ]; then

    echo "✓ Disk usage is healthy (${DISK_USAGE}%)."

    write_log "Disk usage is healthy (${DISK_USAGE}%)."

elif [ "$DISK_USAGE" -lt 90 ]; then

    echo "⚠ Warning: Disk usage is high (${DISK_USAGE}%)."

    write_log "WARNING: Disk usage is high (${DISK_USAGE}%)."

else

    echo "✗ CRITICAL: Disk usage is critically high (${DISK_USAGE}%)."

    write_log "CRITICAL: Disk usage is critically high (${DISK_USAGE}%)."

fi

}

# Verifies the latest database backup
verify_database_backup() {

    echo "Verifying database backup..."

    LATEST_DB_BACKUP=$(ls -t "$BACKUP_DIR"/openemr_*.sql | head -1)

    if [ -s "$LATEST_DB_BACKUP" ]; then

        echo "✓ Database backup verification passed."

        write_log "Database backup verification passed."

    else

        echo "✗ Database backup verification failed."

        write_log "ERROR: Database backup verification failed."

    fi

    echo ""

}

# ========= MAIN PROGRAM =========

show_banner

write_log "Backup job started."

check_apache_service

check_database_service

check_disk_space

create_backup_directory

backup_database

verify_database_backup

backup_openemr_files

backup_apache_config

backup_ssl

cleanup_old_backups

write_log "Backup job completed successfully."


#!/bin/bash


# ===========================================
# CEP Enterprise Restore Script
# Project 02 - Secure OpenEMR
# Version: 1.0
# Author: Alex Anyaehie
# ===========================================

# ========= GLOBAL VARIABLES =========

BACKUP_DIR="/home/lexxy/backups"

OPENEMR_DIR="/var/www/openemr"

APACHE_CONFIG="/etc/apache2"

SSL_DIR="/etc/apache2/ssl"

DATABASE_NAME="openemr"

LOG_FILE="$BACKUP_DIR/backup.log"


show_banner() {

    echo "==========================================="
    echo "     CEP Enterprise Restore Script"
    echo "    Project 02 - Secure OpenEMR"
    echo "==========================================="
    echo ""

}

write_log() {

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"

}

# Restores the OpenEMR database
restore_database() {

    echo "Restoring OpenEMR database..."
    LATEST_DB_BACKUP=$(ls -t "$BACKUP_DIR"/openemr_*.sql | head -1)

if [ -f "$LATEST_DB_BACKUP" ]; then

    echo "Latest database backup found."

     mysql "$DATABASE_NAME" < "$LATEST_DB_BACKUP"
        if [ $? -eq 0 ]; then

            echo "✓ Database restored successfully."

        else

            echo "✗ Database restore failed."

            exit 1

        fi
else

    echo "ERROR: No database backup found."

    exit 1

fi

}

# Restores the OpenEMR application files
restore_openemr_files() {

    echo "Restoring OpenEMR application files..."

    LATEST_OPENEMR_BACKUP=$(ls -t "$BACKUP_DIR"/openemr_files_*.tar.gz | head -1)
    if [ -f "$LATEST_OPENEMR_BACKUP" ]; then

        echo "Latest OpenEMR backup found."

        tar -xzf "$LATEST_OPENEMR_BACKUP" -C /

        if [ $? -eq 0 ]; then

            echo "✓ OpenEMR application files restored successfully."

        else

            echo "✗ OpenEMR application file restore failed."

            exit 1

        fi
    else

        echo "ERROR: No OpenEMR backup found."

        exit 1

    fi

}

# Restores the Apache configuration
restore_apache_config() {

    echo "Restoring Apache configuration..."
LATEST_APACHE_BACKUP=$(ls -t "$BACKUP_DIR"/apache_config_*.tar.gz | head -1)

if [ -f "$LATEST_APACHE_BACKUP" ]; then

    echo "Latest Apache configuration backup found."

    tar -xzf "$LATEST_APACHE_BACKUP" -C /

    if [ $? -eq 0 ]; then

        echo "✓ Apache configuration restored successfully."

    else

        echo "✗ Apache configuration restore failed."

        exit 1

    fi

else

    echo "ERROR: No Apache configuration backup found."

    exit 1

fi

}

# Restores SSL certificates
restore_ssl() {

    echo "Restoring SSL certificates..."

    LATEST_SSL_BACKUP=$(ls -t "$BACKUP_DIR"/ssl_*.tar.gz | head -1)

    if [ -f "$LATEST_SSL_BACKUP" ]; then

        echo "Latest SSL backup found."

        tar -xzf "$LATEST_SSL_BACKUP" -C /

        if [ $? -eq 0 ]; then

            echo "✓ SSL certificates restored successfully."

        else

            echo "✗ SSL certificate restore failed."

            exit 1

        fi

    else

        echo "ERROR: No SSL backup found."

        exit 1

    fi

}

# Restarts the Apache service
restart_apache() {

    echo "Restarting Apache..."

    systemctl restart apache2

    if [ $? -eq 0 ]; then

        echo "✓ Apache restarted successfully."

        if systemctl is-active --quiet apache2; then

            echo "✓ Apache service is running."

        else

            echo "✗ Apache service is not running."

            exit 1

        fi

    else

        echo "✗ Failed to restart Apache."

        exit 1

    fi

}

# ========= MAIN PROGRAM =========

show_banner

write_log "Restore job started."

restore_database

restore_openemr_files

restore_apache_config

restore_ssl

restart_apache

write_log "Restore job completed successfully."

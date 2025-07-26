# deploy.sh - Automates deployment of applications by pulling updates, installing dependencies, and restarting services.
# Edit variables below.

# Application directory and Git settings
APP_DIR="/var/www/html/myapp"
GIT_BRANCH="main"

# Command to install dependencies (uncomment the appropriate line)
#DEPENDENCY_CMD="npm install"
#DEPENDENCY_CMD="pip3 install -r requirements.txt"
#DEPENDENCY_CMD="composer install"

# Service name to restart (systemctl)
SERVICE_NAME="myapp.service"

#### Script ####
#!/usr/bin/env bash
set -euo pipefail

echo "Starting deployment at $(date +'%Y-%m-%d %H:%M:%S')"
cd "$APP_DIR"

echo "Fetching latest changes from Git..."
git fetch origin "$GIT_BRANCH"
git checkout "$GIT_BRANCH"
git pull origin "$GIT_BRANCH"

echo "Installing dependencies..."
if [[ -n "${DEPENDENCY_CMD}" ]]; then
    eval "$DEPENDENCY_CMD"
fi

echo "Restarting service: $SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"
echo "Deployment completed successfully."
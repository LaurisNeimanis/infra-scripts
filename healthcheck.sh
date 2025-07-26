# healthcheck.sh - Monitors server health (CPU, memory, disk usage) and sends alerts if thresholds are exceeded.
# Edit thresholds and notification settings below.

#!/usr/bin/env bash
set -euo pipefail

# Thresholds (percent)
CPU_THRESHOLD=80
MEM_THRESHOLD=75
DISK_THRESHOLD=90

# Email for alerts
EMAIL="admin@example.com"

#### Script ####
# Check CPU usage (average over 1 minute)
CPU_LOAD=$(awk '{print int($1 + 0.5)}' < <(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $1}' | awk '{print $2}'))

# Check memory usage
MEM_USED=$(free | awk '/Mem:/ {printf "%d", $3/$2 * 100}')

# Check disk usage on root
DISK_USED=$(df / | awk 'END{print +$5}')

ALERTS=()
[[ $CPU_LOAD -gt $CPU_THRESHOLD ]] && ALERTS+=("CPU usage is ${CPU_LOAD}% (threshold ${CPU_THRESHOLD}%)")
[[ $MEM_USED -gt $MEM_THRESHOLD ]] && ALERTS+=("Memory usage is ${MEM_USED}% (threshold ${MEM_THRESHOLD}%)")
[[ $DISK_USED -gt $DISK_THRESHOLD ]] && ALERTS+=("Disk usage is ${DISK_USED}% (threshold ${DISK_THRESHOLD}%)")

if [ ${#ALERTS[@]} -gt 0 ]; then
    SUBJECT="[ALERT] Server health issues on $(hostname)"
    BODY="$(hostname) healthcheck:\n${ALERTS[*]}"
    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
else
    echo "$(date +'%Y-%m-%d %H:%M:%S'): All metrics within thresholds."
fi

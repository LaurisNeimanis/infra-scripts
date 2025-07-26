# Infra-Scripts

A collection of Bash scripts for common infrastructure tasks: automated backups, deployments, and health checks.

## Scripts Overview

- **backup.sh**: Performs database and file backups with timestamped archives.
- **deploy.sh**: Automates deployment of applications by pulling updates, installing dependencies, and restarting services.
- **healthcheck.sh**: Monitors server health (CPU, memory, disk usage) and sends alerts if thresholds are exceeded.

## Prerequisites

- Linux-based server
- Bash shell
- `cron` for scheduling backups and health checks
- Optional: `mail` or `sendmail` for email notifications

## Usage

1. **Clone the repository**
   ```bash
   git clone https://github.com/LaurisNeimanis/infra-scripts.git
   cd infra-scripts
   ```

2. **Make scripts executable**
   ```bash
   chmod +x backup.sh deploy.sh healthcheck.sh
   ```

3. **Configure each script**
   - Edit variables at the top of each script to set paths, retention days, and notification settings.

4. **Run manually**
   ```bash
   ./backup.sh
   ./deploy.sh
   ./healthcheck.sh
   ```

5. **Schedule with cron**
   ```bash
   # Daily backup at 2am
   0 2 * * * /path/to/infra-scripts/backup.sh

   # Health check every hour
   0 * * * * /path/to/infra-scripts/healthcheck.sh
   ```

## Directory Structure

```
├── backup.sh        # Backup script
├── deploy.sh        # Deployment script
├── healthcheck.sh   # Monitoring script
└── README.md        # This documentation
```

## Contributing

Feel free to open issues or submit pull requests to add new scripts or improve existing ones.

## License

This project is open-source and available under the MIT License.

---

🔗 **Back to portfolio:** [My Portfolio](https://github.com/LaurisNeimanis/my-portfolio)



#!/bin/bash
set -e

# Update system packages
sudo apt-get update

# Install required utilities
sudo apt-get install -y curl wget gnupg ca-certificates

# Enable monitoring services
sudo systemctl enable prometheus
sudo systemctl enable grafana-server

# Start monitoring services
sudo systemctl start prometheus
sudo systemctl start grafana-server

# Display service status
echo "Checking monitoring services..."
sudo systemctl --no-pager --full status prometheus || true
sudo systemctl --no-pager --full status grafana-server || true

echo "Setup completed."
echo "Grafana: http://YOUR_EC2_PUBLIC_IP:3000"
echo "Prometheus: http://YOUR_EC2_PUBLIC_IP:9090"

# AWS System Monitoring and Alerting

## Overview
A system monitoring project deployed on AWS EC2 using Prometheus, Node Exporter, and Grafana to monitor server resources and send email alerts.

## Technologies
- AWS EC2 (Ubuntu)
- Prometheus
- Node Exporter
- Grafana
- Email notifications

## Features
- CPU usage monitoring
- RAM usage monitoring
- Grafana dashboards
- Configurable alert thresholds
- Alert firing and recovery email notifications

## Prometheus Configuration
Prometheus scrapes metrics every 15 seconds from:
- Prometheus: localhost:9090
- Node Exporter: localhost:9100

Configuration file: `prometheus/prometheus.yml`

## Alert Thresholds
CPU usage threshold: 80%
RAM usage threshold: 80%

## Prerequisites
- AWS EC2 instance running Ubuntu
- Prometheus and Node Exporter
- Grafana

## Start Services
```bash
sudo systemctl start prometheus
sudo systemctl start grafana-server
```

Check service status:
```bash
sudo systemctl status prometheus --no-pager
sudo systemctl status grafana-server --no-pager
```

## Access Grafana
Open `http://YOUR_EC2_PUBLIC_IP:3000` in your browser after checking the EC2 instance status and security group rules.

## Security
Never commit passwords, AWS access keys, private keys, or other secrets. Restrict access to monitoring ports to trusted IP addresses.

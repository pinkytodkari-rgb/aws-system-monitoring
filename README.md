# AWS System Monitoring and Alerting

A real-time system monitoring project built using **AWS EC2, Prometheus, Node Exporter, and Grafana** to monitor CPU and RAM usage and send email alerts when resource usage exceeds a configured threshold.

## 📌 Overview

This project monitors the performance of an Ubuntu server hosted on Amazon EC2. Prometheus collects system metrics, Node Exporter provides server performance data, and Grafana displays the metrics through dashboards and evaluates alert rules.

When CPU or RAM usage exceeds the configured threshold of **80%**, Grafana can send an email notification. When resource usage returns to normal, a recovery notification can also be sent.

This project helps administrators identify high resource usage and respond to potential performance issues.

## 🎯 Project Objectives

- Monitor CPU and RAM usage of an AWS EC2 instance.
- Collect system metrics at regular intervals.
- Visualize server performance using Grafana dashboards.
- Generate alerts when CPU or RAM usage exceeds 80%.
- Send email notifications for alert and recovery events.
- Learn practical server monitoring and alerting using open-source tools.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Amazon EC2 | Hosts the Ubuntu monitoring server |
| Ubuntu Linux | Operating system for the server |
| Prometheus | Collects and stores time-series metrics |
| Node Exporter | Exposes CPU, RAM, and system metrics |
| Grafana | Creates dashboards and manages alert rules |
| SMTP / Email | Delivers alert and recovery notifications |
| GitHub | Stores project configuration, documentation, and screenshots |

## 🏗️ Architecture

```text
        AWS EC2 - Ubuntu Server
                  |
                  v
            Node Exporter
             Port 9100
                  |
                  v
             Prometheus
             Port 9090
          Collects metrics
                  |
                  v
              Grafana
             Port 3000
          /             \
         v               v
   Dashboards        Alert Rules
                          |
                          v
                   Email Notification
```

### How the project works

1. **Node Exporter:** Collects information about the EC2 server, including CPU and memory statistics.
2. **Prometheus:** Scrapes metrics from Node Exporter every 15 seconds and stores them.
3. **Grafana:** Connects to Prometheus and displays CPU and RAM usage on dashboards.
4. **Alert rules:** Evaluate resource usage against the configured 80% threshold.
5. **Email notifications:** Notify the configured recipient when an alert fires and, if configured, when the alert recovers.

## ⚙️ Prerequisites

Before setting up the project, you need:

- An AWS account.
- An Ubuntu EC2 instance.
- Basic knowledge of Linux commands.
- Prometheus, Node Exporter, and Grafana installed and configured.
- A configured Grafana contact point for email notifications.
- Access to the required ports through the EC2 security group.

## 🚀 Installation and Setup

### Step 1: Launch an EC2 instance

1. Sign in to the AWS Management Console.
2. Open the EC2 service.
3. Launch an Ubuntu instance.
4. Configure a security group to allow SSH access from your IP address.
5. Connect to the instance using EC2 Instance Connect or SSH.

### Step 2: Install the monitoring tools

Install and configure the following components on the Ubuntu instance:

- Prometheus for collecting metrics.
- Node Exporter for exposing system metrics.
- Grafana for dashboards and alert management.

Follow the official installation documentation:

- [Prometheus documentation](https://prometheus.io/docs/introduction/overview/)
- [Node Exporter documentation](https://prometheus.io/docs/guides/node-exporter/)
- [Grafana documentation](https://grafana.com/docs/grafana/latest/)

### Step 3: Configure Prometheus

The repository contains a Prometheus configuration file at:

`prometheus/prometheus.yml`

The configuration uses a 15-second scrape interval and monitors Prometheus and Node Exporter.

Example configuration:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
```

Copy or adapt this configuration to `/etc/prometheus/prometheus.yml` on the EC2 instance. Then validate the configuration and restart Prometheus.

```bash
sudo systemctl restart prometheus
sudo systemctl status prometheus --no-pager
```

### Step 4: Configure Grafana

Open Grafana in your browser:

`http://YOUR_EC2_PUBLIC_IP:3000`

Replace `YOUR_EC2_PUBLIC_IP` with the public IPv4 address of your EC2 instance.

Then:

1. Sign in to Grafana.
2. Add Prometheus as a data source.
3. Configure the Prometheus URL as `http://localhost:9090` if Grafana and Prometheus run on the same EC2 instance.
4. Save and test the data source.
5. Create or import a dashboard to display CPU and RAM metrics.

### Step 5: Configure CPU and RAM alerts

Create Grafana-managed alert rules for CPU and RAM usage.

Set the threshold to **80%** for both rules.

Configure the evaluation interval and pending period according to your requirements. Select the appropriate contact point so that Grafana can send email notifications.

### Step 6: Configure email notifications

1. Open **Alerting → Notification configuration** in Grafana.
2. Create an email contact point.
3. Configure SMTP settings if required by your Grafana deployment.
4. Enter the recipient email address.
5. Test the contact point.
6. Configure notification policies and recovery notifications as needed.

Email alerts require valid SMTP settings and a working notification configuration.

## ▶️ Starting the Project

If the tools have already been installed and configured, connect to your EC2 instance and run:

```bash
sudo systemctl start prometheus grafana-server
```

Check their status:

```bash
sudo systemctl status prometheus --no-pager
sudo systemctl status grafana-server --no-pager
sudo systemctl status prometheus-node-exporter --no-pager
```

The Node Exporter service name may differ depending on how it was installed. In this project, it has also been observed running as `prometheus-node`.

Check the listening ports:

```bash
sudo ss -lntp | grep -E ':3000|:9090|:9100'
```

Open the Grafana dashboard using your EC2 public IPv4 address and port `3000`.

## 🔧 Setup Script

The repository includes `setup.sh` to help start the monitoring services.

If the script is present in the repository, download it using:

```bash
wget https://raw.githubusercontent.com/pinkytodkari-rgb/aws-system-monitoring/main/setup.sh
```

Make it executable:

```bash
chmod +x setup.sh
```

Run it:

```bash
./setup.sh
```

**Important:** The current setup script assumes Prometheus and Grafana are already installed. It does not perform a complete first-time installation of all monitoring tools or configure email delivery. Node Exporter must also be installed and configured separately.

## 🧪 Testing the Project

Use the following checks to verify the monitoring setup.

### 1. Check Prometheus targets

Open:

`http://YOUR_EC2_PUBLIC_IP:9090/targets`

Confirm that the Prometheus and Node Exporter targets are reported as **UP**.

### 2. Check Grafana dashboards

Open Grafana and confirm that CPU and RAM usage metrics appear on your dashboard.

### 3. Test CPU and RAM alert rules

Verify that both alert rules use the intended 80% threshold.

To test alerts, generate a controlled resource load or temporarily use a suitable test threshold. Confirm that the alert changes state and that the email notification is delivered.

Restore the intended 80% threshold after testing.

### 4. Test recovery notifications

Allow resource usage to return below the threshold. Confirm that the alert returns to normal and that a recovery email is delivered if recovery notifications are configured.

## 📸 Screenshots

The `screenshots/` folder contains project screenshots that demonstrate monitoring dashboards, resource usage, and alert notifications.

Examples of screenshots include:

- `devops_dashboard.jpg`
- `cpu_usage_graph.jpg`
- `cpu_usage_status.jpg`
- `cpu_alert.jpg`
- `cpu_resolved.jpg`
- `ram_usag_graph.jpg`
- `ram_usage_status.jpg`
- `ram_alert.jpg`
- `ram_resolved.jpg`

These screenshots help demonstrate the project's monitoring and alerting workflow.

## 🔐 Security Considerations

- Allow SSH access only from trusted IP addresses.
- Restrict Grafana and Prometheus access to trusted IPs or use a VPN/reverse proxy with authentication.
- Do not expose monitoring services publicly without appropriate access controls.
- Never upload passwords, SMTP credentials, API keys, private keys, or other secrets to GitHub.
- Use secure methods to store credentials and configure email notifications.
- Review AWS security group rules before making the project accessible over the internet.

## 📁 Project Structure

```text
aws-system-monitoring/
├── prometheus/
│   └── prometheus.yml
├── screenshots/
│   ├── cpu_alert.jpg
│   ├── cpu_resolved.jpg
│   ├── cpu_usage_graph.jpg
│   ├── cpu_usage_status.jpg
│   ├── devops_dashboard.jpg
│   ├── ram_alert.jpg
│   ├── ram_resolved.jpg
│   ├── ram_usag_graph.jpg
│   └── ram_usage_status.jpg
├── setup.sh
└── README.md
```

## 🌟 Key Features

- Real-time server monitoring.
- CPU and RAM usage tracking.
- Prometheus-based metrics collection.
- Grafana dashboard visualization.
- Configurable threshold-based alerts.
- Email alert and recovery notifications.
- AWS EC2 deployment.
- Documented setup and configuration.

## 🔮 Future Improvements

- Add monitoring for disk usage and network traffic.
- Monitor multiple EC2 instances.
- Add automated deployment using Ansible or Terraform.
- Configure HTTPS for secure dashboard access.
- Add centralized logging using Grafana Loki.
- Improve alert routing and escalation policies.

## 👩‍💻 Author

**Pinky Todkari**

GitHub: [pinkytodkari-rgb](https://github.com/pinkytodkari-rgb)

Project Repository: [aws-system-monitoring](https://github.com/pinkytodkari-rgb/aws-system-monitoring)

## 📄 License

This project is intended for educational and demonstration purposes. Add a license file if you want to specify the terms under which others may use, modify, and distribute the project.

# Add a user for Prometheus
sudo useradd -s /sbin/nologin prometheus

# Download Prometheus install archive
wget https://github.com/prometheus/prometheus/releases/download/v2.44.0/prometheus-2.44.0.linux-amd64.tar.gz

# Untar the Prometheus linux binaries 
tar xvf prometheus-2.44.0.linux-amd64.tar.gz

# Move to the extracted prometheus folder
cd prometheus-2.44.0.linux-amd64


# Copy prometheus binary to /usr/local/bin
sudo cp prometheus /usr/local/bin/

# Copy promtool cli to /usr/local/bin
sudo cp promtool /usr/local/bin/

# Create prometheus folders
# /etc/prometheus stores the prometheus configuration yaml files
sudo mkdir /etc/prometheus
# /var/lib/prometheus stores the tsdb for prometheus
sudo mkdir /var/lib/prometheus

# Grant prometheus user access to /etc/prometheus
sudo chown prometheus:prometheus /etc/prometheus
# Grant prometheus user access to /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# Allow prometheus user access to prometheus binaries
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Copy consoles folder to /etc/prometheus
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus


# Permissions for the /etc/prometheus folders
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

# Copy configuration file
sudo cp prometheus.yml /etc/prometheus/prometheus.yml

# Set permissions on configuration file
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Command to startup prometheus
# sudo -u prometheus /usr/local/bin/prometheus \
#     --config.file /etc/prometheus/prometheus.yaml \
#     --storage.tsdb.path /var/lib/prometheus/ \
#     --web.console.templates=/etc/prometheus/consoles \
#     --web.console.libraries=/etc/prometheus/console_libraries

# The service configuration is available in ../prometheus.service
# move to the default location
cd ../

# Copy the service file to /etc/systemd/system/prometheus.service
cp prometheus.service /etc/systemd/system/prometheus.service

# Perform systemctl daemon-reload
sudo systemctl daemon-reload


# Start and enable prometheus
sudo systemctl start prometheus
sudo systemctl enable prometheus



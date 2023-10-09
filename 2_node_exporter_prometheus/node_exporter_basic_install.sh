# Create a noshell user for node exporter
sudo useradd -s /sbin/nologin prometheus_node_exporter

# Download the node exporter install package
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

# Untar the node exporter package
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz

# move to the extracted package directory
cd node_exporter-1.6.1.linux-amd64

# Copy the node exporter to /usr/local/bin
sudo cp node_exporter /usr/local/bin

# Grant the prometheus_node_exporter user access to node_exporter
sudo chown -r prometheus_node_exporter:prometheus_node_exporter /usr/local/bin/node_exporter

# Create the node exporter service and enable it
# Copy the service file to /etc/systemd/system/prometheus.service
cd ../
cp node_exporter.service /etc/systemd/system/node_exporter.service

# Perform systemctl daemon-reload
sudo systemctl daemon-reload


# Start and enable prometheus
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
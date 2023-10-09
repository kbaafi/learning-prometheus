# Create a noshell user for node exporter
sudo useradd -s /sbin/nologin prometheus_node_exporter

# Create an openssl credential for node exporter
openssl req -x509 -newkey rsa:2048 -nodes -out node_exporter.crt -keyout node_exporter.key -days 365 -config openssl.cnf

# Download the node exporter install package
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

# Untar the node exporter package
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz

# move to the extracted package directory
cd node_exporter-1.6.1.linux-amd64

# Copy the node exporter to /usr/local/bin
sudo cp node_exporter /usr/local/bin

# Grant the prometheus_node_exporter user access to node_exporter
sudo chown -R prometheus_node_exporter:prometheus_node_exporter /usr/local/bin/node_exporter

cd ../

# Create the /etc folder for node_exporter
sudo mkdir /etc/node_exporter

cp node_exporter.crt node_exporter.key /etc/node_exporter
cp ssl_config.yml /etc/node_exporter/config.yml

# Grant node_exporter user access to the /etc/node_exporter folder
sudo chown -R prometheus_node_exporter:prometheus_node_exporter /etc/node_exporter

# Create the node exporter service and enable it
# Copy the service file to /etc/systemd/system/node_exporter.service
cp node_exporter_ssl.service /etc/systemd/system/node_exporter.service

# Create 

# Perform systemctl daemon-reload
sudo systemctl daemon-reload


# Start and enable prometheus
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
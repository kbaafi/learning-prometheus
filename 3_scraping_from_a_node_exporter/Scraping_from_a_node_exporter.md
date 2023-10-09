# Scraping from a Node Exporter metrics endpoint

Prometheus needs to know where to scrape the metrics from. This is done by adding the metrics target to the scrape configuration in the prometheus configuration yaml file. This file is typically located in `/etc/prometheus/prometheus.yml`.

Add the following to the `srape_configs` section of the yaml configuration file

The scrape configuration section can have multiple scrape configurations.

```yaml
scrape_configs:
    - job_name: 'nodes'
      scrape_interval: 15s
      scrape_timeout: 5s
      sample_limit: 1000
      static_configs:
       - targets: ['192.168.56.104:9100']
```

After this is done, if the target node_exporter is up and running, you should see an **UP** status in the prometheus/status/targets endpoint.


# Scraping from an SSL encrypted endpoint (HTTPS)
Copy the node_exporter certificate file from the node_exporter and grant the prometheus user access to the node_exporter certificate file

Add the following scrape configs to `/etc/prometheus/prometheus.yml`. It is also possible to setup service discovery from a file. This will be discussed in later notes

```yaml
scrape_configs:
    - job_name: 'nodes'
      scrape_interval: 15s
      scrape_timeout: 5s
      sample_limit: 1000
      tls_config:
        ca_file: /etc/prometheus/node_exporter.crt
        insecure_skip_verify: true  # for when you only have a self signed certificate
      static_configs:
       - targets: ['192.168.56.104:9100']
```

The entire process could be scripted as follows:

```sh
$ scp username:password#node:/etc/node_exporter/node_exporter.crt

$ chown prometheus:prometheus node_exporter.crt

$ cp node_exporter.crt /etc/prometheus/node_exporter.crt

$ vi /etc/prometheus/prometheus.yml # add the scrape configs from above
```

# Scraping from an HTTPS endpoint with Basic Auth
In order to achieve this, we need to create an encrypted password using Bcrypt and store that password in webfiles config of the node_exporter

```sh
sudo apt install apache2-utils

htpasswd -nBC 12 "" | tr -d ':\n'

```

The resulting config will look like this
```yml
tls_server_config:
  cert_file: /etc/node_exporter/node_exporter.crt
  key_file: /etc/node_exporter/node_exporter.key
basic_auth_users:
  prometheus: $2y2$12.........
```

On the prometheus server, the following configuration is neeed:

In the /etc/prometheus/prometheus.yml file, set the scrape configs as follows:

```yaml
scrape_configs:
    - job_name: 'nodes'
      scrape_interval: 15s
      scrape_timeout: 5s
      sample_limit: 1000
      tls_config:
        ca_file: /etc/prometheus/node_exporter.crt
        insecure_skip_verify: true  # for when you only have a self signed certificate
      static_configs:
       - targets: ['192.168.56.104:9100']
      basic_auth:
        username: prometheus
        password: password
```

# Scraping from an HTTPS endpoint 
In this case the node_exporter certificate file is set to be the CA certificate of the Prometheus tls configuration. Prometheus will use its own certificate to authenticate against the node_exporter's metrics endpoint.

Copy the node_exporter certificate file from the node_exporter and grant the prometheus user access to the node_exporter certificate file

Create a new SSL keypair for the prometheus server and grant the prometheus user access to the keypair.

Copy both the keypair and the node_exporter's certificate to /etc/prometheus and use the following setting for the scraping

```yaml
scrape_configs:
    - job_name: 'nodes'
      scrape_interval: 15s
      scrape_timeout: 5s
      sample_limit: 1000
      tls_config:
        ca_file: /etc/prometheus/node_exporter.crt
        insecure_skip_verify: true  # for when you only have a self signed certificate
        cert_file: /etc/prometheus/prometheus.crt
        key_file: /etc/prometheus/prometheus.key
      static_configs:
       - targets: ['192.168.56.104:9100']
```

Remove basic auth settings from both prometheus and the node_exporter and restart both the prometheus and the node_exporter services

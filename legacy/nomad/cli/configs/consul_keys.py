import subprocess

DOCKER_IMAGES_SERVER_PORT = 8006

result = subprocess.run(['id', '-u'], stdout=subprocess.PIPE)
USER_ID = int(result.stdout)
result = subprocess.run(['id', '-g'], stdout=subprocess.PIPE)
GROUP_ID = int(result.stdout)

# USER_ID=$(id -u)
# GROUP_ID=$(id -g)

consul_keys = {
    'nomad-': {
        'USER_ID': f"{USER_ID}",
        'GROUP_ID': f"{GROUP_ID}",
        'GET_IDS_USING_CONSUL': "yes",
        'resources_register_host': f'http://0.0.0.0:{DOCKER_IMAGES_SERVER_PORT}',
        'postgres_pgdata': '/home/a/dockers-data/postgres',
        'postgres_conf': '/home/a/src/devOps/nomad/cli/configs/postgres/postgresql.conf',

        'loki_data_index': '/home/a/dockers-data/loki/loki-index',
        'loki_data_chunks': '/home/a/dockers-data/loki/loki-chunks',
        'loki_config': '/home/a/src/devOps/nomad/cli/configs/loki/loki-config.yml',

        'prometheus_config': '/home/a/src/devOps/nomad/cli/configs/prometheus/prometheus.yml',
        'prometheus_alerts': '/home/a/src/devOps/nomad/cli/configs/prometheus/alert_rules',
        'prometheus_data': '/home/a/dockers-data/prometheus',

        'grafana_config': '/home/a/src/devOps/nomad/cli/configs/grafana/custom.ini',
        'grafana_provisioning': '/home/a/src/devOps/nomad/cli/configs/grafana/provisioning',

        'tempo_config': '/home/a/src/devOps/nomad/cli/configs/tempo/etc/tempo-local.yaml',
        'tempo_wal': '/home/a/dockers-data/tempo/wal',
        'tempo_blocks': '/home/a/dockers-data/tempo/blocks',

        'alert_manager_config': '/home/a/src/devOps/nomad/cli/configs/alert_manager/alertmanager.yml',
        'alert_manager_volume': '/home/a/dockers-data/alert_manager',

        'mysql_orion_data': '/home/a/dockers-data/mysql-orion-mktplace',
        'mysql_data': '/home/a/dockers-data/mysql',
        'redis_data': '/home/a/dockers-data/redis',

        'grafana_data': '/home/a/dockers-data/grafana',

        'sonarqube_data': '/home/a/dockers-data/sonarqube',

        # 'files_service_app_data': '/home/a/src/a/sb/POCs/gateways-poc/services/files_service/priv/files',
        'files_service_app_data': '/home/a/src/a/sb/POCs/gateways-poc/services/fs/priv/static',
        # 'krakend_config_data': '/home/a/src/a/sb/POCs/gateways-poc/devOps/krakend',
        # 'krakend_config_data': '/home/a/src/POCs/krakend',

        # 'krakend_config_data': '/home/a/Desktop/poc/wiremock/krakend',

        'krakend_config_data': '/home/a/src/a/sb/POCs/gateways-poc/krakend',

        'files_and_mappings_root_wiremock': '/home/a/src/a/POCs/wiremock/working-dir',
        'files_and_mappings_root_wiremock_webhook': '/home/a/src/a/POCs/wiremock/working-dir-webhook',

        'dev_env_directory_e': '/home/a/src/a/sb/dev/paygate',
        'dev_env_directory_h': '/media/a/data/docs-files/Web/Testing/proxies/service-virtualization/wiremock/webhooks',
        'dev_env_direnv_alloweds': '/home/a/Desktop/poc/dev_env/.local/share/direnv/allow',

        'php_dev_env_directory': '/home/a/Downloads/src/php/',
        'dev_env_directory_elixir': '/home/a/src/POCs/distributed-computing/',

        'templates_webhook_transformer': '/home/a/src/ansible/src/micro/py/templates',
        'fluentd_etc': '/home/a/dockers-data/fluentd/td-agent',
        'elasticsearch_config': '/home/a/dockers-data/elasticsearch/config',
        'elasticsearch_data': '/home/a/dockers-data/elasticsearch/data',

        'rabbitmq_enabled_plugins': '/home/a/dockers-data/sb-rabbitmq_plugins/sb-enabled_plugins',
        'rabbitmq_data': '/home/a/dockers-data/sb-rabbitmq',
        'nexus_data': '/home/a/dockers-data/nexus-data2',

        'spark_apps': '/home/a/Downloads/course/spark_apps',

        'verdaccio_storage': '/home/a/dockers-data/npm/storage',
        'verdaccio_conf': '/home/a/dockers-data/npm/conf',
        'DOCKER_IMAGES_SERVER_PORT': f'{DOCKER_IMAGES_SERVER_PORT}',
    },

    'flask-common-': {
        'LOCAL': 'Yes',
        'FLASK_APP': 'app.py',
        'GENERATE_POSTMAN_COLLECTION': 'yes',
    },

    'mitmproxy-config-': {
        'MITMPROXY_PORT': '8082',
        'MITMPROXY_WEB_UI_PORT': '8083',
    },

    'mitmproxy2-config-': {
        'MITMPROXY_PORT': '8084',
        'MITMPROXY_WEB_UI_PORT': '8085',
    },

    'toxiproxy-config-': {
        'TOXIPROXY_SERVER_PORT': '8474',
    },
    'hoverfly-config-': {
        'HOVERFLY_PROXY_PORT': '8501',
        'HOVERFLY_ADMIN_PORT': '8888',
    },
    'gor-config-': {
        'GOR_INPUT_RAW_PORT': '8600',
        # 'GOR_INPUT_RAW_PORT': '80',
        # 'GOR_INPUT_RAW_PORT': '4000',
        # 'GOR_INPUT_RAW_PORT': '56299',
        'GOR_OUTPUT_PATH': '/home/a/src/a/sb/QA/gateway/payment-gateways/service-virtualization/gor/requests.gor',
    },
    'haproxy-config-': {
        'HAPROXY_CONFIG_PATH': '/media/a/data/docs/Web/High-Performance/LB/HA-Proxy/haproxy/',
    },
    'prometheus-config-': {
        'PROMETHEUS_HOME': '/home/a/appslnx/monitoring/prometheus-2.x/',
    },
    'grafana-config-': {
        'GRAFANA_HOME': '/home/a/appslnx/monitoring/grafana-6.x/bin/',
    },
    'node_exporter-config-': {
        'NODE_EXPORTER_HOME': '/home/a/appslnx/monitoring/node_exporter-0.x/',
    },
    'grok_exporter-config-': {
        'GROK_EXPORTER_HOME': '/home/a/appslnx/monitoring/grok_exporter-0.x/',
    },
    'ms_demos-config-': {
        'MSPROD_DATABASE_USER': 'safeboda_user',
        'MSPROD_DATABASE_PASS': '8GShwQeSMVULP0z1NcE+19QfYcYWKi',
        'MSPROD_DATABASE_NAME': 'janus_dev',
        'MSPROD_DATABASE_HOST': 'postgres.service.dc1.consul',
    },
    'devops_demos-config-': {
        'POSTGRES_DATABASE_HOST': 'postgres.service.dc1.consul',
        'POSTGRES_DATABASE_USER': 'postgres',
        'POSTGRES_DATABASE_PASS': '11qazxsw22',
    },

    'devops_user_node-config-': {
        'DATABASE_URL': 'ecto://root:mysecretpw@mysql.service.dc1.consul:3306/user-node-incubating',
    },

    'betika_user_node-config-': {
        'AMQP_USERNAME': 'rabbitmq',
        'AMQP_PASSWORD': 'rabbitmq',
        'AMQP_HOST': 'rabbitmq.service.dc1.consul',
        'AMQP_EXCHANGE': 'user_node',
        'MYSQL_USER': 'root',
        'MYSQL_ROOT_PASSWORD': 'mysecretpw',
        'MYSQL_HOST': 'mysql.service.dc1.consul',
    },

    # 'betika_wallet_node-config-': {
    #     'WALLET_NODE_GRAFANA_URL': 'http://grafana.service.dc1.consul:300',
    #     'WALLET_NODE_GRAFANA_TOKEN': 'eyJrIjoieUJ4NTFkY25rMFZlMVNPV0N3SkZtTG5nT1FYajkxNTIiLCJuIjoid2FsbGV0IiwiaWQiOjF9',
    #     'betika_wallet_node-config-WALLET_NODE_AMQP_URL': 'amqp://rabbitmq:rabbitmq@rabbitmq.service.dc1.consul:5672',
    #     'betika_wallet_node-config-WALLET_NODE_AMQP_EXCHANGE': 'wallet_node',
    #     'betika_wallet_node-config-WALLET_NODE_AMQP_COMMAND_EXCHANGE': 'pay_commands',
    #     # '': '',
    # },
    #
    # 'betika_wallet_node-dev-config-': {
    #     'WALLET_NODE_DATABASE_URL': 'ecto://root:mysecretpw@mysql.service.dc1.consul:3306/betika_wallet_dev',
    # },
    #
    # 'betika_wallet_node-test-config-': {
    #     'WALLET_NODE_DATABASE_URL': 'ecto://root:mysecretpw@mysql.service.dc1.consul:3306/betika_wallet_test',
    # },

    'betika_user_node-test-config-': {
        'MYSQL_DATABASE': 'user_node_test',
    },

    'betika_user_node-dev-config-': {
        'MYSQL_DATABASE': 'user_node_dev',
    },

    'ARCH': {
        'DB1_MYSQL_DATABASE': 'db1_dev',
        'DB1_MYSQL_USER': 'root',
        'DB1_MYSQL_ROOT_PASSWORD': 'mysecretpw',
        'DB1_MYSQL_HOST': 'mysql.service.dc1.consul',

        'APP_A_MYSQL_DATABASE': 'db1_dev',
        'APP_A_MYSQL_USER': 'root',
        'APP_A_MYSQL_ROOT_PASSWORD': 'mysecretpw',
        'APP_A_MYSQL_HOST': 'mysql.service.dc1.consul',

        'APP_B_MYSQL_DATABASE': 'db1_dev',
        'APP_B_MYSQL_USER': 'root',
        'APP_B_MYSQL_ROOT_PASSWORD': 'mysecretpw',
        'APP_B_MYSQL_HOST': 'mysql.service.dc1.consul',

    }

}

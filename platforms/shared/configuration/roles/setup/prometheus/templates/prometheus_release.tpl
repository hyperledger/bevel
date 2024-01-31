extraScrapeConfigs: |
    -   job_name: besu
        scrape_interval: 15s
        scrape_timeout: 10s
        metrics_path: /metrics
        scheme: http
        static_configs:
            -   targets: {{ targets }}
alertmanager:
    enabled: false
kube-state-metrics:
    enabled: false
prometheus-node-exporter:
    enabled: false
prometheus-pushgateway:
    enabled: false

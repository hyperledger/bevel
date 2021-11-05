apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
	name: {{ org.services.auth.name }}
	namespace: {{ component_ns }}
	annotations:
		fluxcd.io/automated: "false"
spec:
	releaseName: {{ component_name }}
	chart:
		git: {{ org.gitops.git_url }}
		ref: {{ org.gitops.branch }}
		path: {{ charts_dir }}/auth
	values:
		bashDebug: false
		prefix: cenm
		nodeName: auth
		authImage:
      repository: corda/enterprise-auth
      tag: 1.5.1-zulu-openjdk8u242
      pullPolicy: Always
    image:
      initContainerName: {{ network.docker.url }}/{{ init_image }}
      mainContainerName: {{ network.docker.url }}/{{ docker_image }}
      imagePullSecret: regcred
    config:
      volume:
        baseDir: /opt/cenm
        replicas: 1
		subjects:
			auth: "{{ services.auth.subject }}"
      
		vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: cordaent{{ org.type | lower }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.type | lower }}
      retries: 20
      sleepTimeAfterError: 20

		database:
			driverClassName: "org.h2.Driver"
			jdbcDriver: ""
			url: "jdbc:h2:file:./h2/auth-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0"
			user: "testuser"
			password: "password"
			runMigration: true
		volume:
			volumeSizeAuthEtc: 1Gi
			volumeSizeAuthH2: 5Gi
			volumeSizeAuthLogs: 5Gi
		storageClass: cordaentsc
		sleepTimeAfterError: 300
		logsContainerEnabled: true

    podSecurityContext:
      runAsUser: 1000
      runAsGroup: 1000
      fsGroup: 1000

    securityContext: {}
     
		nameOverride: ""
		fullnameOverride: ""

		service:
			type: ClusterIP
			port: 8081
		resources:
			limits: 2Gi
			requests: 2Gi
		livenessProbe:
			enabled: false
			failureThreshold: 3
			initialDelaySeconds: 10
			periodSeconds: 10
			successThreshold: 1
			timeoutSeconds: 1
		readinessProbe:
			enabled: false
			failureThreshold: 3
			initialDelaySeconds: 10
			periodSeconds: 10
			successThreshold: 1
			timeoutSeconds: 1

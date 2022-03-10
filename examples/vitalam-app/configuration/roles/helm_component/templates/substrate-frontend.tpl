apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name:############
  namespace:#######
  annotations:
    fluxcd.io/automated: "false"
spec:
  chart:
    path:
    git:
    ref:
  releaseName:
  values:
    metadata:
      namespace:
  ##replicaCount:##

          metadata:
            name: frontEnd

            namespace: frontend-ns

          config:
            port: 80
            logLevel: info
            enableLivenessProbe: true
            applicationConfig:
              authDomain: inteli.eu.auth0.com
              clientID: ##sensitive data to be stored in vault
              custAuthClientID: ##sensitive data to be stored in vault
              t1AuthClientID: ##sensitive data to be stored in vault
              authAudience: inteli-dev
              apiHost: localhost
              apiPort: 3000
              substrateHost: localhost
              substratePort: 9944
              vitalamDemoPersona: cust    ##can be any of your choice
          ingress:
            # annotations: {}
            # className: ""
            paths:
              - /

          image:
            repository: angelaalagbe/vitalam-frontend
            pullSecret: regcred
            pullPolicy: IfNotPresent
            tag: '1.0.0'

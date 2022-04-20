apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ component_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: {{ component_name }}
  chart:
    git: {{ org.gitops.git_url }}
    ref: {{ org.gitops.branch }}
    path: {{ charts_dir }}/certs-ambassador-quorum
  values:
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
      external_url: {{ name }}.{{ external_url }}
    image:
      initContainerName: ghcr.io/hyperledger/alpine-utils:1.0
      node: quorumengineering/quorum:{{ network.version }}
      pullPolicy: Always
      certsContainerName: ghcr.io/hyperledger/bevel-build:jdk8-latest
      imagePullSecret: regcred
      pullPolicy: Always
    vault:
      address: {{ vault.url }}
      role: vault-role
      authpath: quorum{{ org_name }}
      serviceaccountname: vault-auth
      certsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}-quo
      retries: 30
    subjects:
      rootca: "CN=DLT Root CA,OU=DLT,O=DLT,L=New York,C=US"
      ambassadortls: "C=US,L=New York,O=Lite,OU=DLT/CN=DLT ambassadortls CA"
    opensslVars:
      domain_name: "{{ node_name }}.{{ external_url }}"
      domain_name_api: "{{ node_name }}api.{{ external_url }}"
      domain_name_web: "{{ node_name }}web.{{ external_url }}"
      domain_name_tessera: "{{ node_name }}-tessera.{{ component_ns }}"
    vars:
      ambassadortls: "/home/bevel/DATA/ambassadortls"
      rootca: "/home/bevel/DATA/rootca" 
      kubernetes: "{{ item.k8s }}"
      node_name: "{{ item.name | lower }}"
      root_subject: "{{ network.config.subject }}"
      cert_subject: "{{ network.config.subject | regex_replace(',', '/') }}"
    
    metadata:
      name: {{ component_name }}
      namespace: {{ component_ns }}
      external_url: {{ name }}.{{ external_url }}
    acceptLicense: YES
    healthCheckNodePort: 0
    sleepTimeAfterError: 60
    sleepTime: 10
    healthcheck:
      readinesscheckinterval: 10
      readinessthreshold: 1

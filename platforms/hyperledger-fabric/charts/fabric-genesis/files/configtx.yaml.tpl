Capabilities:
{{- if or (eq $.Values.network.version "2.2.2") (eq $.Values.network.version "2.5.4") }}
  Channel: &ChannelCapabilities
    V2_0: true
  Orderer: &OrdererCapabilities
    V2_0: true
  Application: &ApplicationCapabilities
{{- if eq $.Values.network.version "2.5.4" }}
    V2_5: true
  {{- else }}
    V2_0: true
  {{- end }}
{{- end }}
{{- if eq $.Values.network.version "1.4.8" }}
{{- if eq $.Values.consensus.name "kafka"}}
  Global: &ChannelCapabilities
    V1_1: true
  Orderer: &OrdererCapabilities
    V1_1: true
  Application: &ApplicationCapabilities
    V1_1: true
{{- end }}
{{- if eq $.Values.consensus.name "raft"}}
  Global: &ChannelCapabilities
    V1_4_3: true
  Orderer: &OrdererCapabilities
    V1_4_2: true
  Application: &ApplicationCapabilities
    V1_4_2: true
{{- end }}
{{- end }}

Application: &ApplicationDefaults
  Organizations:
{{- if or (eq $.Values.network.version "2.2.2") (eq $.Values.network.version "2.5.4") }}
  Policies: &ApplicationDefaultPolicies
    LifecycleEndorsement:
        Type: ImplicitMeta
        Rule: "MAJORITY Endorsement"
    Endorsement:
        Type: ImplicitMeta
        Rule: "MAJORITY Endorsement"
    Readers:
        Type: ImplicitMeta
        Rule: "ANY Readers"
    Writers:
        Type: ImplicitMeta
        Rule: "ANY Writers"
    Admins:
        Type: ImplicitMeta
        Rule: "MAJORITY Admins"
{{- end }}
  Capabilities:
    <<: *ApplicationCapabilities

Channel: &ChannelDefaults
{{- if or (eq $.Values.network.version "2.2.2") (eq $.Values.network.version "2.5.4") }}
  Policies:
    Readers:
      Type: ImplicitMeta
      Rule: "ANY Readers"
    Writers:
      Type: ImplicitMeta
      Rule: "ANY Writers"
    Admins:
      Type: ImplicitMeta
      Rule: "MAJORITY Admins"
{{- end }}
  Capabilities:
    <<: *ChannelCapabilities

Organizations:
{{- range $org := $.Values.organizations }}
  - &{{ $org.name }}Org
    Name: {{ $org.name }}MSP
    ID: {{ $org.name }}MSP
    MSPDir: ./crypto-config/{{ $org.type }}Organizations/{{ $org.name }}-net/msp
    Policies:
      Readers:
        Type: Signature
        Rule: "OR('{{ $org.name }}MSP.member')"
      Writers:
        Type: Signature
        Rule: "OR('{{ $org.name }}MSP.member')"
      Admins:
        Type: Signature
        Rule: "OR('{{ $org.name }}MSP.admin')"
      Endorsement:
        Type: Signature
        Rule: "OR('{{ $org.name }}MSP.member')"
    {{- if and ($org.orderers) (eq $.Values.network.version "2.5.4")}}
    OrdererEndpoints:
    {{- range $orderer := $org.orderers }}
    {{- if eq $.Values.global.proxy.provider "none" }}
      - {{ $orderer.name }}.{{ $org.name }}-net:7050
    {{- else }}
      - {{ $orderer.ordererAddress }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- if and ($org.peers) (ne $.Values.network.version "2.5.4") }}
    AnchorPeers:
    {{- range $peer := $org.peers }}
    {{- if eq $.Values.global.proxy.provider "none" }}
      - Host: {{ $peer.name }}.{{ $org.name }}-net
        Port: 7051
    {{- else }}
    {{- $split := split ":" $peer.peerAddress }}
      - Host: {{ $split._0 }}
        Port: {{ $split._1 }}
    {{- end }}
    {{- end }}
    {{- end }}
  {{- printf "\n" }}
  {{- end }}
Orderer: &OrdererDefaults
{{- range $org := $.Values.organizations }}
{{- if eq $org.type "orderer"}}
{{- if eq $.Values.consensus.name "raft"}}
  OrdererType: etcdraft
{{- else }}
  OrdererType: {{ $.Values.consensus.name }}
{{- end }}
  Addresses:
{{- range $orderer := $org.orderers }}
{{- if eq $.Values.global.proxy.provider "none" }}
    - {{ $orderer.name }}.{{ $org.name | lower }}-net:7050
{{- else }}
    - {{ $orderer.ordererAddress }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
  BatchTimeout: 2s
  BatchSize:
    MaxMessageCount: 10
    AbsoluteMaxBytes: 98 MB
    PreferredMaxBytes: 1024 KB
{{- if eq $.Values.consensus.name "kafka"}}
    Kafka:
        Brokers:
{{- range $org := $.Values.organizations }}
{{- if and ($org.orderers) (gt (len .Values.miLista) 0)}} 
{{- $replicas := $.Values.consensus.replicas }}
{{- range $index, $element := until $replicas }}
      - {{  $.Values.consensus.name }}-{{ $index }}.{{ $.Values.consensus.type }}.{{ $org.name | lower }}-net.svc.cluster.local:{{ $.Values.consensus.grpc.port }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- if eq $.Values.consensus.name "raft"}}
  EtcdRaft:
    Consenters:
{{- range $org := $.Values.organizations }}
{{- range $orderer := $org.orderers }}
{{- $component_ns := printf "%s-net" (lower $org.name) }}
{{- if eq $.Values.global.proxy.provider "none" }}
      - Host: {{ $orderer.name}}.{{ $component_ns }}
        Port: 7050
{{- else }}
{{- $split := split ":" $orderer.ordererAddress }}
      - Host: {{ $split._0 }}
        Port: {{ $split._1 }}
{{- end }}
        ClientTLSCert: ./crypto-config/ordererOrganizations/{{ $component_ns }}/orderers/{{ $orderer.name }}.{{ $component_ns }}/tls/server.crt
        ServerTLSCert: ./crypto-config/ordererOrganizations/{{ $component_ns }}/orderers/{{ $orderer.name }}.{{ $component_ns }}/tls/server.crt
{{- end }}
{{- end }}
{{- end }}
  Organizations:
  Policies:
    Readers:
      Type: ImplicitMeta
      Rule: "ANY Readers"
    Writers:
      Type: ImplicitMeta
      Rule: "ANY Writers"
    Admins:
      Type: ImplicitMeta
      Rule: "MAJORITY Admins"
    BlockValidation:
      Type: ImplicitMeta
      Rule: "ANY Writers"
  Capabilities:
    <<: *OrdererCapabilities

Profiles:
{{- range $channel := $.Values.channels }}
  {{ $channel.genesis.name }}:
    <<: *ChannelDefaults
    Orderer:
      <<: *OrdererDefaults
{{- if eq $.Values.consensus.name "raft"}}
      OrdererType: etcdraft
      EtcdRaft:
        Consenters:
{{- range $org := $.Values.organizations }}
{{- range $orderer := $org.orderers }}
{{- $component_ns := printf "%s-net" (lower $org.name) }}
{{- if eq $.Values.global.proxy.provider "none" }}
        - Host: {{ $orderer.name}}.{{ $component_ns }}
          Port: 7050
{{- else }}
{{- $split := split ":" $orderer.ordererAddress }}
        - Host: {{ $split._0 }}
          Port: {{ $split._1 }}
{{- end }}
          ClientTLSCert: ./crypto-config/ordererOrganizations/{{ $component_ns }}/orderers/{{ $orderer.name }}.{{ $component_ns }}/tls/server.crt
          ServerTLSCert: ./crypto-config/ordererOrganizations/{{ $component_ns }}/orderers/{{ $orderer.name }}.{{ $component_ns }}/tls/server.crt
{{- end }}
{{- end }}
{{- end }}
      Organizations:
{{- range $orderer := $channel.orderers }}
        - *{{ $orderer }}Org
{{- end }}
{{- if ne $.Values.network.version "2.5.4" }}
    Consortiums:
      {{ $channel.consortium }}:
        Organizations:
{{- range $org := $.Values.organizations }}
{{- if ne $org.type "orderer"}}
          - *{{ $org.name }}Org
{{- end }}      
{{- end }} 
  {{ $channel.channel_name }}:
    <<: *ChannelDefaults
    Consortium: {{ $channel.consortium }}
{{- end }} 
    Application:
      <<: *ApplicationDefaults
      Organizations:
{{- range $org := $channel.participants }}
        - *{{ $org.name }}Org
{{- end }}
{{- if eq $.Values.network.version "2.5.4" }}
      Capabilities: *ApplicationCapabilities
{{- end }}
{{- end }}

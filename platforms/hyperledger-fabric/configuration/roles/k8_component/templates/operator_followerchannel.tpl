apiVersion: hlf.kungfusoftware.es/v1alpha1
kind: FabricFollowerChannel
metadata:
  name: {{ channel_name }}-{{ org_name }}
spec:
  anchorPeers:
{% for peer in anchor_peers %}
    - host: {{ peer.peerAddress.split(':')[0] }}
      port: {{ peer.peerAddress.split(':')[1] }}
{% endfor %}
  hlfIdentity:
    secretKey: user.yaml
    secretName: {{ org_name }}-admin
    secretNamespace: {{ org_ns }}
  mspId: {{ org_name }}MSP
  name: {{ channel_name }}
  externalPeersToJoin: []
  orderers:
{% for orderer in network.orderers %}
    - certificate: |-
        {{ lookup('file', orderer.certificate) | indent(width=8, first=False) }}
      url: grpcs://{{ orderer.uri }}
{% endfor %}
  peersToJoin:
{% for peer1 in participant.peers %}
    - name: {{ org_name }}-{{ peer1.name }}
      namespace: {{ org_ns }}
{% endfor %}

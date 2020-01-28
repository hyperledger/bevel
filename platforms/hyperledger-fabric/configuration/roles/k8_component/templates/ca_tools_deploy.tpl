apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: ca-tools
  namespace: {{ component_name }}
spec:
  replicas: 1
  template:
    metadata:
      labels:
        name: ca-tools
    spec:
      volumes:
      - name: ca-tools-pv
        persistentVolumeClaim:
          claimName: ca-tools-pvc
      - name: ca-tools-crypto-pv
        persistentVolumeClaim:
          claimName: ca-tools-crypto-pvc
      containers:
      - name: ca-tools
        image: hyperledger/fabric-ca-tools:1.2.0
        command: ["sh", "-c", "/bin/bash"]
        stdin: true
        tty: true
        volumeMounts:
        - mountPath: /root/ca-tools
          name: ca-tools-pv
        - mountPath: /crypto-config
          name: ca-tools-crypto-pv

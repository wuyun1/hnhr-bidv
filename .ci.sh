#!/usr/bin/env bash

# yarn

export CICD_EXECUTION_SEQUENCE=${BUILD_NUMBER:-1}

docker build . -t  harbor.hft.jajabjbj.top:30088/hft/hnhr:${CICD_EXECUTION_SEQUENCE}
docker push harbor.hft.jajabjbj.top:30088/hft/hnhr:${CICD_EXECUTION_SEQUENCE}

# envsubst '${CICD_EXECUTION_SEQUENCE}' < deployment.yaml > _deployment.yaml

cat > _deployment.yaml <<'EOF'
kind: Service
apiVersion: v1
metadata:
  name: hnhr
  namespace: hzero
spec:
  selector:
    app: hnhr
  type: ClusterIP
  ports:
    - protocol: TCP
      port: 8586
      targetPort: 8586
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hnhr
  namespace: hzero
  labels:
    app: hnhr
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hnhr
  template:
    metadata:
      labels:
        app: hnhr
    spec:
      imagePullSecrets:
      - name: harbor
      containers:
      - name: hnhr
        image: harbor.hft.jajabjbj.top:30088/hft/hnhr:${CICD_EXECUTION_SEQUENCE}
        ports:
        - containerPort: 8586
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  namespace: hzero
  generation: 1
  name: hnhr
spec:
  rules:
  - host: hnhr.jd1.jajabjbj.top
    http:
      paths:
      - backend:
          serviceName: hnhr
          servicePort: 8586
EOF

kubectl apply -f _deployment.yaml

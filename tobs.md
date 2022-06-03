Release "tobs" does not exist. Installing it now.
NAME: tobs
LAST DEPLOYED: Thu Jun  2 12:36:07 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
###############################################################################
👋🏽 Welcome to tobs, The Observability Stack for Kubernetes

✨ Auto-configured and deployed:
🔥 Kube-Prometheus
🐯 TimescaleDB
🤝 Promscale
🧐 PromLens
📈 Grafana
🚀 OpenTelemetry
🎯 Jaeger

###############################################################################
🔥 PROMETHEUS NOTES:
###############################################################################

Prometheus can be accessed via port 9090 on the following DNS name from within your cluster:
tobs-kube-prometheus-prometheus.default.svc

Get the Prometheus server URL by running these commands in the same shell:
export SERVICE_NAME=$(kubectl get services --namespace tobs -l "app=kube-prometheus-stack-prometheus,release=tobs" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace tobs port-forward service/$SERVICE_NAME 9090:9090


The Prometheus alertmanager can be accessed via port 9093 on the following DNS name from within your cluster:
tobs-kube-prometheus-alertmanager.default.svc


Get the Alertmanager URL by running these commands in the same shell:
export POD_NAME=$(kubectl get pods --namespace tobs -l "app=alertmanager,alertmanager=tobs-kube-prometheus-alertmanager" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace tobs port-forward $POD_NAME 9093
WARNING! Persistence is disabled on AlertManager.
You will lose your data when the AlertManager pod is terminated.

###############################################################################
🐯 TIMESCALEDB NOTES:
###############################################################################

TimescaleDB can be accessed via port 5432 on the following DNS name from within your cluster:
tobs.default.svc
To get your password for superuser run:
# superuser password
PGPASSWORD_POSTGRES=$(kubectl get secret --namespace tobs tobs-timescaledb-passwords -o jsonpath="{.data.postgres}" | base64 --decode)

    # admin password
    PGPASSWORD_ADMIN=$(kubectl get secret --namespace tobs tobs-timescaledb-passwords -o jsonpath="{.data.admin}" | base64 --decode)

To connect to your database, chose one of these options:

1. Run a postgres pod and connect using the psql cli:
   # login as superuser
   kubectl run -i --tty --rm psql --image=postgres \
   --env "PGPASSWORD=$PGPASSWORD_POSTGRES" \
   --command -- psql -U postgres \
   -h tobs.default.svc postgres

   # login as admin
   kubectl run -i --tty --rm psql --image=postgres \
   --env "PGPASSWORD=$PGPASSWORD_ADMIN" \
   --command -- psql -U admin \
   -h tobs.default.svc postgres

2. Directly execute a psql session on the master node
   MASTERPOD="$(kubectl get pod -o name --namespace tobs -l release=tobs,role=master)"
   kubectl exec -i --tty --namespace tobs ${MASTERPOD} -- psql -U postgres


###############################################################################
🧐 PROMLENS NOTES:
###############################################################################
PromLens is a PromQL query builder, analyzer, and visualizer.

You can access PromLens via a local browser by executing:
kubectl --namespace tobs port-forward service/tobs-promlens 8081:80
kubectl --namespace tobs port-forward service/tobs-promscale-connector 9201:
(Note: You have to port-forward both PromLens and Promscale at the same time)

Then you can point your browser to http://127.0.0.1:8081/.
###############################################################################
🚀  OPENTELEMETRY NOTES:
###############################################################################

    The OpenTelemetry collector is deployed to collect traces.

    OpenTelemetry collector can be accessed with the following DNS name from within your cluster:
    tobs-opentelemetry-collector.default.svc
###############################################################################
📈 GRAFANA NOTES:
###############################################################################

1. The Grafana server can be accessed via port 80 on
   the following DNS name from within your cluster:
   tobs-grafana.default.svc

   You can access grafana locally by executing:
   kubectl --namespace tobs port-forward service/tobs-grafana 8080:80

   Then you can point your browser to http://127.0.0.1:8080/.

2. The 'admin' user password can be retrieved by:
   kubectl get secret --namespace tobs tobs-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

3. You can reset the admin user password with grafana-cli from inside the pod.
   First attach yourself to the grafana container:
   GRAFANAPOD="$(kubectl get pod -o name --namespace tobs -l app.kubernetes.io/name=grafana)"
   kubectl exec -it ${GRAFANAPOD} -c grafana -- /bin/sh

   And then execute in the shell:
   grafana-cli admin reset-admin-password <password-you-want-to-set>

🚀 Happy observing!

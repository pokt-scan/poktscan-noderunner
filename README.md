## Poktscan Node Runner Deployment

This scripts will prepare a bare metal to handle a kubernetes cluster using [microk8s](https://microk8s.io/)
Will setup also a certificate provider using cert-manager and a cloud dns provider to generate dynamically certificates 
for domains that u want to register using poktscan-cli

  * Godaddy (require extra step)
  * Cloudflare

### Installed dependencies:
* [microk8s](https://microk8s.io/)
* [tobs](https://github.com/timescale/tobs)
* [cert-manager](https://artifacthub.io/packages/helm/cert-manager/cert-manager)
* [nginx-ingress](https://kubernetes.github.io/ingress-nginx)

### Clone this repository

    $ git clone git@github.com:pokt-scan/poktscan-noderunner.git

### Install microk8s

    $ ./setup.sh


### Install Godaddy Requirements (only if u will use that dns provider)

    $ ./setup-godaddy.sh

### Install all the tools
    
    $ ./complete-setup.sh
    $ ....
    $ "Setup has been successful!"

When all steps have been executed without errors, the script prints:

"Setup has been successful!"

The absence of this message means the script did not complete.

### Access Grafana - this script will print the password required for the "admin" user. Access grafana at http://localhost:8080

    $ ./forward-grafana.sh

### Access Prometheus

    $ ./forward-prometheus.sh

### Check tobs.md to see how to access databases and other resources.

### TODO:
* Add RBAC and HTTPS to the cluster.

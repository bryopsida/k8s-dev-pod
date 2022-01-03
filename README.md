# K8S-Dev-Pod

## What is this?

This chart deploys a container containing common dev tools. It uses a dropbear ssh server so users can connect Visual Studio Code or IntelliJ to the pod as a remote environment. This allows developers to work inside a cluster in a very similiar fashion to how they would work locally. The dropbear port is bound to 3022, it runs as the developer user, not root. On each start of the container the developer user password is changed randomly and logged with the intent that once initially accessed developers switch to public key authentication. `/home/developer` and `/etc/dropbear` use PVCs and will survive updates/restarts, other changes such as `apt-get` installs will not.

## How to deploy 

### Add helm Repo
First add the helm repo so you can install the chart.
`helm repo add k8s-dev-pod https://bryopsida.github.io/k8s-dev-pod` and fetch updates `helm repo update`

### Deploy
`helm upgrade --install --namespace <your-namespace> <your-release-name> k8s-dev-pod/k8s-dev-pod`

### Get Password
`kubectl -n <your-namespace> get pods` you should see a pod called dev-pod, fetch the logs.

``` shell
kubectl -n <your-namespace> logs <your-pod>
Your password is: <your-random-password-here>
[1] Jan 01 17:41:38 Not backgrounding
```

### Forward the SSH connection
While using the environment you will need to run a port forward. `kubectl -n <your-namespace> port-forward pod/<your-pod-name> 3022:3022`

### Connect
`ssh -p 3022 developer@localhost`, you will be prompted for a password, enter the password fetched earlier. From here you can setup a ssh configuration using public key authentication `ssh-copy-id` etc.

## Visual Studio Code Setup
Follow the directions [here](https://code.visualstudio.com/docs/remote/ssh) to setup your remote environment. From here you can develop much in the same way you would locally including hot reloading (nodemon etc) but with access to all of the kubernetes services deployed in your cluster.

## Connect without port-forward
If you wish to connect to the pod without port-forwarding you can use the following command to upgrade your helm deployment.

`helm upgrade --install --namespace <your-namespace> <your-release-name> k8s-dev-pod/k8s-dev-pod --set ingressEnabled=true --set ingressPort=3022`

This will create a service that exposes the pod on port 3022 using an external IP addresses. If you are running a bare metal cluster you may need to install something like [metallb](https://metallb.org) that can manage the external IP addresses.

You can lookup the external IP address by running `kubectl get svc -n <your-namespace> -o wide` and looking for the service called `<your-release-name>-external`.

## Disable password login
If you wish to disable password login you can use the following command to upgrade your helm deployment.

`helm upgrade --install --namespace <your-namespace> <your-release-name> k8s-dev-pod/k8s-dev-pod --set passwordLoginEnabled=false`

This will set the developer user account to a blank password and run dropbear with password logins disabled.

## Login with public key authentication
First generate a compatible ssh key pair.  `ssh-keygen -t ecdsa`. After generating the key pair you will need to copy the public key to the pod. This assumes you have already started port-forwarding or have enabled the service to expose the ssh port. Ensure you have the current password for the developer user.

`ssh-copy-id -i ~/.ssh/id_ecdsa  -p 3022 developer@<the-ip-address-or-hostname>` You will be prompted for the password go ahead and enter it and the authorized keys file will be populated with the public key from your key pair.

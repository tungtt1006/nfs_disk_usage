# NFS disk usage
An app runs on Kubernetes, gets persistent volume disk usage information then expose metrics to Prometheus. You can use this when you have a Kubernetes cluster running with NFS backend storage.

It is different from node exporter disk usage metrics. nfs-disk-usage uses `du` command instead of `df`.

# How to use
1. Mount exposed nfs folder on your node folder:

```
mount -t -nfs -v <nfs-ip>:<exposed-nfs-folder> <node-folder> -o ro,noexec,nouser
```

:warning: **I strongly recommend you also add config to the `/etc/fstab` file on your node for persistent purpose:**

  ```
  <nfs-ip>:<exposed-nfs-folder> <nfs-mount-path-on-node> nfs ro,noexec,nouser 0 0
  ```
<br/>

2. Open `k8s/deployment.yml` file then:

  - Configure 2 fields:
    ```
    nodeName: <node-you-run-mount-command>

    volumes.name.hostPath: <nfs-mount-path-on-node>
    ```
  - Configure ENV variable:
    ```
    env:
          - name: DIRECTORY                      # nfs folder path in container
            value: /root/nfs-storage
          - name: METRICS_FILE_PATH              # folder path to save metric file in container, file name is `metrics.txt`
            value: /usr/share/nginx/metrics
          - name: NGINX_SERVER_NAME              #  nfs-disk-usage pod dns
            value: nfs-disk-usage.cluster.local
    ```
<br/>

3. Deploy on Kubernetes:
   ```
   kubectl apply -f k8s/.
   ```

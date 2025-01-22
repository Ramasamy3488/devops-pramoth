# Kubernetes Probes: Monitoring Container Health and Readiness

Kubernetes provides three main types of probes to monitor the health and readiness of applications running in containers: **Liveness Probes**, **Readiness Probes**, and **Startup Probes**. Each probe type serves a distinct purpose and can utilize different methods for health checks, such as HTTP requests, TCP connections, or command execution.

## Types of Kubernetes Probes

### 1. Liveness Probe
A liveness probe checks if a container is running and functioning correctly. If the probe fails, Kubernetes will restart the container. This is particularly useful for applications that may encounter deadlocks or other runtime issues.

**Methods:**
- **HTTP Probe**: Sends an HTTP GET request to a specified endpoint. A successful response (status code 2xx or 3xx) indicates the container is healthy.
- **TCP Probe**: Attempts to establish a TCP connection to a specified port on the container. A successful connection indicates the container is healthy.
- **Exec Probe**: Executes a command inside the container. If the command exits with a status code of 0, the container is considered healthy.

### 2. Readiness Probe
A readiness probe determines if a container is ready to accept traffic. If it fails, Kubernetes removes the pod from the service endpoints until it passes again. This is useful for applications that require time to initialize before they can handle requests.

**Methods:** Similar to liveness probes, readiness probes can also use HTTP, TCP, or Exec methods.

### 3. Startup Probe
A startup probe checks whether an application within a container has started successfully. It is particularly useful for applications that take longer to start up than usual. If this probe fails, Kubernetes will not perform liveness checks until it succeeds.

## Example YAML Manifest

Below is an example YAML manifest that demonstrates how to configure all three types of probes in a Kubernetes deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: example-container
        image: registry.k8s.io/e2e-test-images/agnhost:2.40
        args:
        - serve
        ports:
        - containerPort: 8080
        
        # Liveness Probe
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
        
        # Readiness Probe
        readinessProbe:
          httpGet:
            path: /readyz
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
        
        # Startup Probe
        startupProbe:
          httpGet:
            path: /startz
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
```

### Explanation of the YAML Manifest

- **Deployment**: Defines a deployment named `example-app` with one replica.
- **Container**: Specifies the container image and arguments for running the application.
- **Liveness Probe**:
  - Uses an HTTP GET request to check the `/healthz` endpoint on port `8080`.
  - The probe starts checking after an initial delay of `5 seconds` and runs every `10 seconds`.
- **Readiness Probe**:
  - Checks the `/readyz` endpoint similarly.
- **Startup Probe**:
  - Checks the `/startz` endpoint to determine if the application has started successfully.

This configuration ensures that Kubernetes can effectively manage the lifecycle of your application by monitoring its health and readiness states appropriately, enabling better resilience and self-healing capabilities in your deployments.

## Citations

1. [Practical Guide to the Kubernetes Probes](https://www.civo.com/learn/practical-guide-to-the-kubernetes-probes)
2. [Kubernetes Deployment YAML](https://codefresh.io/learn/kubernetes-deployment/kubernetes-deployment-yaml/)
3. [Understanding Kubernetes Probes](https://kubeops.net/blog/kubernetes-probes)
4. [Kubernetes Documentation: Probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/)
5. [Best Practices for Kubernetes Liveness Probes](https://www.fairwinds.com/blog/a-guide-to-understanding-kubernetes-liveness-probes-best-practices)
6. [Kubernetes Configuration Tasks: Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)


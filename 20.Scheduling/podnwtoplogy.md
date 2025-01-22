# Scheduling Scenarios

## What are Topology Keys?
Topology keys in Kubernetes are labels that define the topology of nodes in a cluster. They are used by the Kubernetes scheduler to determine how to place pods based on the characteristics of the nodes. When scheduling pods, the scheduler considers these topology keys to optimize resource allocation and ensure that pods are distributed according to specified rules.

## Purpose of Topology Keys

### Pod Affinity and Anti-Affinity:
- Topology keys are used in pod affinity and anti-affinity rules to control where pods can be scheduled relative to other pods.
- For example, you might want certain pods to be scheduled on the same node (affinity) or to avoid being scheduled on the same node (anti-affinity).

### Service Traffic Routing:
- In services, topology keys can help route traffic based on geographical or network considerations, ensuring that requests are handled by the closest or most appropriate pod.

### Load Balancing:
- They allow for balanced distribution of pods across different zones or nodes, which can enhance performance and fault tolerance.

## Common Topology Keys
- **topology.kubernetes.io/zone**: Represents the availability zone of a node.
- **topology.kubernetes.io/region**: Represents the region where a node is located.
- **kubernetes.io/hostname**: Represents the unique hostname of a node, allowing for scheduling on specific nodes.

## Example Usage

### Pod Affinity Example
Here’s an example of how to use topology keys in pod affinity:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      affinity:
        podAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: app
                    operator: In
                    values:
                      - frontend
              topologyKey: "topology.kubernetes.io/zone"  # Pods should be co-located in the same zone.
      containers:
        - name: myapp-container
          image: myapp-image
```

### Pod Anti-Affinity Example
Here’s how to specify multiple topology keys in pod anti-affinity:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-anti-affinity
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: app
                    operator: In
                    values:
                      - frontend
              topologyKey: "topology.kubernetes.io/zone"  # First topology key for anti-affinity.
            - labelSelector:
                matchExpressions:
                  - key: env
                    operator: In
                    values:
                      - production
              topologyKey: "kubernetes.io/hostname"  # Second topology key for anti-affinity.
      containers:
        - name: myapp-container
          image: myapp-image
```

## Conclusion
Topology keys are essential for controlling how pods are scheduled based on node characteristics.
- They enable more efficient resource utilization and improved application performance through affinity and anti-affinity rules.
- Commonly used keys include **topology.kubernetes.io/zone**, **topology.kubernetes.io/region**, and **kubernetes.io/hostname**.

By understanding and utilizing topology keys effectively, you can optimize your Kubernetes deployments for better performance, availability, and resilience.


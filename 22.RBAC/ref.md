Kubernetes API groups are essential for organizing and managing the various resources within the Kubernetes ecosystem. They help in categorizing resources based on their functionality and purpose, allowing for a more modular and extensible architecture.

### Types of API Groups

1. **Core API Group**:
   - Represented by an empty string (`""`).
   - Includes fundamental resources such as:
     - Pods
     - Services
     - Namespaces
     - Nodes
     - Persistent Volumes

2. **Named API Groups**:
   - These groups cover specific functionalities not included in the core group.
   - Examples include:
     - `apps`: For application-related resources like Deployments and ReplicaSets.
     - `batch`: For batch processing tasks such as Jobs and CronJobs.
     - `networking.k8s.io`: For networking resources like Ingresses and Network Policies.

### Importance of API Groups in Manifests

- **Resource Organization**: API groups categorize related resources, making it easier to manage and discover them. For instance, all application-related resources are grouped under the `apps` API group, while core resources are accessed through the core group.

- **Versioning**: Each API group can have multiple versions, allowing for backward compatibility and gradual evolution of the API. This means that as Kubernetes evolves, new features can be added without breaking existing functionality.

- **Conflict Resolution**: Different API groups can have resources with similar names but may offer different functionalities. Specifying the correct API group in your manifests ensures that Kubernetes knows exactly which resource you are referring to.

### Example Usage in Manifests

In a Kubernetes manifest, you might see:

```yaml
apiVersion: v1  # Core API group for Pods
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
    - name: nginx
      image: nginx
```

```yaml
apiVersion: apps/v1  # Named API group for Deployments
kind: Deployment
metadata:
  name: example-deployment
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: nginx
          image: nginx
```

In these examples, `apiVersion: v1` specifies that the resource is part of the core group, while `apiVersion: apps/v1` indicates that it belongs to the named `apps` group. This distinction is crucial for Kubernetes to process requests correctly and apply the appropriate logic for each resource type.

Citations:
[1] https://overcast.blog/kubernetes-api-groups-and-versions-full-guide-c5e41c99cf14?gi=9992572c4a7f
[2] https://waytoeasylearn.com/learn/api-groups-in-kubernetes/
[3] https://k21academy.com/docker-kubernetes/k8s-api-resources-group-and-version/
[4] https://stackoverflow.com/questions/74780402/whats-apigroups-in-kubernetes
[5] https://kubernetes.io/docs/reference/using-api/
[6] https://book.kubebuilder.io/cronjob-tutorial/gvks


Here’s a comprehensive overview of the **Kubernetes API groups**, **resources**, and **verbs** used in Role-Based Access Control (RBAC):

## API Groups and Resources

### Core API Group
- **API Group:** `""` (empty string)
- **Resources:**
  - `pods`
  - `services`
  - `namespaces`
  - `nodes`
  - `persistentvolumes`
  - `resourcequotas`
  - `endpoints`
  - `events`
  - `componentstatuses`

### Extensions and Apps API Groups
- **API Groups:** 
  - `extensions`
  - `apps`
- **Resources:**
  - `deployments`
  - `replicasets`
  - `daemonsets`
  - `statefulsets`

### Other Common API Groups
- **API Group:** `networking.k8s.io`
  - **Resources:**
    - `ingresses`
    - `networkpolicies`
  
- **API Group:** `rbac.authorization.k8s.io`
  - **Resources:**
    - `roles`
    - `clusterroles`
    - `rolebindings`
    - `clusterrolebindings`

## Common Verbs

The verbs represent the actions that can be performed on the resources. Here are the most commonly used verbs:

- **get**: Retrieve a resource by name.
- **list**: Retrieve a list of resources.
- **watch**: Monitor changes to resources.
- **create**: Create a new resource.
- **update**: Update an existing resource.
- **delete**: Remove a resource.
- **patch**: Apply partial modifications to a resource.

## Example Role Definition

Here’s an example of a Role that grants permissions to manage pods, deployments, and namespaces:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-deployment-manager
rules:
- apiGroups: [""]
  resources: ["pods", "namespaces"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
```

This example includes permissions for managing both core resources (like pods and namespaces) and resources from the apps API group (like deployments and replica sets).

Citations:
[1] https://www.armosec.io/blog/a-guide-for-using-kubernetes-rbac/
[2] https://github.com/devopscube/kubenetes-rbac-resources-verbs
[3] https://www.strongdm.com/blog/kubernetes-rbac-role-based-access-control
[4] https://kubernetes.io/docs/reference/access-authn-authz/rbac/
[5] https://www.kubecost.com/kubernetes-best-practices/kubernetes-rbac-best-practices/
[6] https://learnk8s.io/rbac-kubernetes
# Role-Based Access Control (RBAC)

RBAC is a method of regulating access to computer or network resources based on the roles of individual users within an enterprise. It allows administrators to define what actions users can perform based on their roles.

## Key Concepts

### Role
A Role in Kubernetes is a collection of permissions. It defines what actions can be performed on which resources within a namespace.

### Role Binding
A Role Binding grants the permissions defined in a Role to a user or a set of users within a namespace.

### ClusterRole
A ClusterRole is similar to a Role, but it defines permissions cluster-wide. It can be used to grant access to resources across all namespaces.

### ClusterRoleBinding
A ClusterRoleBinding grants the permissions defined in a ClusterRole to a user or a set of users across the entire cluster.

### Service Account
A Service Account provides an identity for processes that run in a Pod. It is used to authenticate and authorize the actions of applications running within the cluster.

## Use Case

Consider a scenario where you have a development team that needs read-only access to resources in the `dev` namespace and a CI/CD pipeline that needs full access to deploy applications across the cluster.

1. **Create a Role for read-only access in the `dev` namespace:**
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      namespace: dev
      name: read-only
    rules:
    - apiGroups: [""]
      resources: ["pods", "services"]
      verbs: ["get", "list"]
    ```

2. **Create a RoleBinding to bind the Role to the development team:**
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: read-only-binding
      namespace: dev
    subjects:
    - kind: User
      name: dev-team
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: read-only
      apiGroup: rbac.authorization.k8s.io
    ```

3. **Create a ClusterRole for full access:**
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: full-access
    rules:
    - apiGroups: [""]
      resources: ["*"]
      verbs: ["*"]
    ```

4. **Create a ClusterRoleBinding to bind the ClusterRole to the CI/CD pipeline:**
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: full-access-binding
    subjects:
    - kind: User
      name: cicd-pipeline
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: full-access
      apiGroup: rbac.authorization.k8s.io
    ```

5. **Create a Service Account for the CI/CD pipeline:**
    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: cicd-service-account
      namespace: default
    ```

This setup ensures that the development team has limited access to the `dev` namespace, while the CI/CD pipeline has full access to deploy applications across the cluster.


# Next, we’ll define a k8s user called rbac-user, and map to its IAM user counterpart. Run the following to get the existing ConfigMap and save into a file called aws-auth.yaml:
```
kubectl get configmap -n kube-system aws-auth -o yaml | grep -v "creationTimestamp\|resourceVersion\|selfLink\|uid" | sed '/^  annotations:/,+2 d' > aws-auth.yaml

```

# Next append the rbac-user mapping to the existing configMap < update the account ID >

```
cat << EoF >> aws-auth.yaml
data:
  mapUsers: |
    - userarn: arn:aws:iam::${ACCOUNT_ID}:user/dev
      username: dev
EoF

```

# Some of the values may be dynamically populated when the file is created. To verify everything populated and was created correctly, run the following:

cat aws-auth.yaml

# Next, apply the ConfigMap to apply this mapping to the system:

kubectl apply -f aws-auth.yaml

aws eks update-kubeconfig --region us-east-1 --name eksdemo1
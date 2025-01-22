# EmptyDir in Kubernetes

An EmptyDir is a type of Kubernetes volume that is initially empty and is created when a Pod is assigned to a Node. Its primary purpose is to provide a storage space that can be shared between containers in the same Pod.

## Key Features

### Lifecycle
- The EmptyDir exists as long as the Pod is running on the Node.
- It is deleted when the Pod is removed.

### Storage Location
- By default, the EmptyDir's backing storage is the Node's filesystem.
- It can be backed by memory if specified (`emptyDir.medium: "Memory"`), making it suitable for storing sensitive or temporary data.
- It can be found on the location wher pod is scheduled /var/lib/kubelet/pods/<uid>/volumes/<volumenname>

## Use Cases
- Temporary scratch space for applications (e.g., processing files or intermediate data).
- Sharing files between containers in the same Pod.

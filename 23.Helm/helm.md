# Helm

## What is Helm?
Helm is a package manager for Kubernetes that helps you manage Kubernetes applications. It allows you to define, install, and upgrade even the most complex Kubernetes applications.

## Architecture
Helm has a client-server architecture:
- **Helm Client**: The command-line tool that users interact with.
- **Tiller Server**: (Helm v2) The server-side component that interacts with the Kubernetes API server to manage the release lifecycle of applications. Note: Tiller has been removed in Helm v3.
- **Helm Charts**: Collections of files that describe a related set of Kubernetes resources.

## Use Cases
- **Application Deployment**: Simplifies the deployment of applications on Kubernetes.
- **Version Management**: Manages different versions of applications.
- **Configuration Management**: Allows you to manage application configurations.
- **Release Management**: Facilitates the release and rollback of applications.

## Revision History
Helm maintains a history of releases, allowing you to track changes and roll back to previous versions if needed. Each release is given a revision number, and you can use the `helm history` command to view the history of a release.

### Example
To view the history of a release:
```sh
helm history <release-name>
```

## Dynamic Configurations
Helm allows you to manage dynamic configurations using the `values.yaml` file. This file contains configuration values that can be overridden during installation or upgrade using the `--set` flag or a custom values file.

### Example
To override a value during installation:
```sh
helm install <release-name> <chart-name> --set key1=value1,key2=value2
```

## Intelligent Deployment
Helm facilitates intelligent deployment strategies by allowing you to define custom deployment logic in your charts. This includes support for canary deployments, blue-green deployments, and other advanced deployment strategies.

## Lifecycle Hooks in Helm
Helm provides lifecycle hooks that allow you to run code at specific points in a release lifecycle. These hooks enable you to perform operations before, after, or during a release.

### Types of Hooks
- **pre-install**: Executes before any resources are installed.
- **post-install**: Executes after all resources are installed.
- **pre-delete**: Executes before any resources are deleted.
- **post-delete**: Executes after all resources are deleted.
- **pre-upgrade**: Executes before any resources are upgraded.
- **post-upgrade**: Executes after all resources are upgraded.
- **pre-rollback**: Executes before any resources are rolled back.
- **post-rollback**: Executes after all resources are rolled back.

## Repositories Available in Helm
Helm uses repositories to distribute charts. A repository is a collection of packaged charts that can be shared and consumed by others. Some popular Helm repositories include:

- **Helm Stable**: The default repository for stable charts.
- **Helm Incubator**: A repository for incubating charts that are not yet ready for the stable repository.
- **Bitnami**: A repository maintained by Bitnami, providing a wide range of applications.
- **Elastic**: A repository for Elastic's products, such as Elasticsearch and Kibana.
- **JFrog**: A repository for JFrog's products, including Artifactory and Xray.

### Adding a Repository
To add a repository to Helm:
```sh
helm repo add <repo-name> <repo-url>
```

### Example
To add the Bitnami repository:
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
```

### Listing Repositories
To list all added repositories:
```sh
helm repo list
```

### Updating Repositories
To update the information of all added repositories:
```sh
helm repo update
```
### Removing Repositories

``` sh 
helm repo remove bitnami

```




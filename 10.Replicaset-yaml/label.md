# Working with Labels in Kubernetes

## Show Labels
To display the labels of a specific pod:
```bash
kubectl get pod mypod --show-labels
```

##Remove a Label

```bash
kubectl label pod mypod env-
```

##Overwrite an Existing Label

``` bash
kubectl label pod mypod env=staging --overwrite
```

##Add a new Label

``` bash
kubectl label pod mypod env=production
```
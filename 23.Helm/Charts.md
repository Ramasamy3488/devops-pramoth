# Helm Charts

## What is a Helm Chart?
A Helm chart is a collection of files that describe a related set of Kubernetes resources. It is used to deploy applications and services onto a Kubernetes cluster.

## Chart Structure
A typical Helm chart has the following structure:
```
mychart/
  Chart.yaml          # A YAML file containing information about the chart
  values.yaml         # The default configuration values for the chart
  charts/             # A directory containing any dependencies for the chart
  templates/          # A directory containing Kubernetes manifest templates
  templates/NOTES.txt # A plain text file containing short usage notes
  templates/helpers.tpl # A file containing reusable template helpers
```

### Chart.yaml
This file contains metadata about the chart, such as its name, version, and description.

### values.yaml
This file contains the default configuration values for the chart. These values can be overridden by users during installation or upgrade.

### charts/
This directory contains any dependencies for the chart. Dependencies are also packaged as charts.

### templates/
This directory contains Kubernetes manifest templates that are combined with values to generate valid Kubernetes resource definitions.

### templates/NOTES.txt
This file contains usage notes that are displayed to the user after the chart is successfully deployed.

### templates/helpers.tpl
The `helpers.tpl` file is used to define reusable template helpers in a Helm chart. These helpers can be used throughout the chart to avoid repetition and simplify complex template logic.

#### Use Case
The `helpers.tpl` file is useful for defining common template functions, such as generating resource names, labels, or annotations. By using helpers, you can ensure consistency and reduce the risk of errors in your templates.

#### Example helpers.tpl
Here is an example of a `helpers.tpl` file:
```yaml
{{- define "mychart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mychart.labels" -}}
labels:
  app.kubernetes.io/name: {{ include "mychart.name" . }}
  helm.sh/chart: {{ include "mychart.chart" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
  app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}
```

#### Using Helpers in Templates
You can use the helpers defined in `helpers.tpl` in your templates as follows:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mychart.fullname" . }}
  {{ include "mychart.labels" . | indent 2 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: 80
```

## Example Chart.yaml
Here is an example of a `Chart.yaml` file:
```yaml
apiVersion: v2
name: mychart
description: A Helm chart for Kubernetes
version: 0.1.0
appVersion: 1.0.0
```

## Example values.yaml
Here is an example of a `values.yaml` file:
```yaml
replicaCount: 1
image:
  repository: myimage
  tag: latest
  pullPolicy: IfNotPresent
service:
  type: ClusterIP
  port: 80
```

## Creating a Chart
To create a new chart, use the following command:
```sh
helm create <chart-name>
```

## Installing a Chart
To install a chart, use the following command:
```sh
helm install <release-name> <chart-name>
```

## Upgrading a Chart
To upgrade a chart, use the following command:
```sh
helm upgrade <release-name> <chart-name>
```

## Uninstalling a Chart
To uninstall a chart, use the following command:
```sh
helm uninstall <release-name>
```

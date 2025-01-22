# Kubernetes Job Configuration Breakdown

This YAML configuration defines a Kubernetes Job that utilizes advanced features such as indexed completions and failure handling. Let’s break down each section for clarity.

## Breakdown of the YAML

### Metadata

```yaml
metadata:
  name: job-backoff-limit-per-index-example

  ``` 
# name: This specifies the name of the Job. In this case, it's job-backoff-limit-per-index-example.

### spec 

``` yaml 
spec:
  completions: 10
  parallelism: 3
  completionMode: Indexed
  backoffLimitPerIndex: 1
  maxFailedIndexes: 5
``` 
## Job Specification Fields

- **completions**: This field specifies the total number of successful completions required for the Job to be considered complete. Here, it is set to `10`, meaning that the Job must successfully complete 10 times.

- **parallelism**: This indicates how many pods can run in parallel at any given time. In this case, it is set to `3`, meaning up to three pods can execute simultaneously.

- **completionMode**: The value `Indexed` indicates that the Job will use indexed completions, which allows each completion to be uniquely identified by an index (from `0` to `9` in this case).

- **backoffLimitPerIndex**: This field sets the maximum number of retries allowed for each individual index before it is considered failed. Here, it is set to `1`, meaning each index can fail once before being marked as failed.

- **maxFailedIndexes**: This specifies the maximum number of failed indexes allowed before terminating the entire Job execution. In this example, it is set to `5`, so if more than five indexes fail, the Job will stop executing further.

## Template 

``` yaml 

template:
  spec:
    restartPolicy: Never
    containers:
    - name: example
      image: python
      command:
      - python3
      - -c
      - |
        import os, sys
        print("Hello world")
        if int(os.environ.get("JOB_COMPLETION_INDEX")) % 2 == 0:
          sys.exit(1)
``` 
## Job Template Specification

- **restartPolicy**: Set to `Never`, indicating that failed pods should not be restarted automatically.

- **containers**: This section defines the container that will run as part of the Job.
  - **name**: The name of the container is `example`.
  - **image**: The container uses the `python` image.
  - **command**: This specifies the command to run inside the container. The command executes a Python script that prints "Hello world". It checks if the environment variable `JOB_COMPLETION_INDEX` (which represents the index of the current completion) is even. If it is even, the script exits with a non-zero status (`sys.exit(1)`), indicating a failure.

## Summary of Behavior

- The Job aims to complete a total of 10 successful runs (indexed from 0 to 9).
- Up to three pods can run concurrently.
- Each index can fail once before it is marked as failed due to the `backoffLimitPerIndex`.
- If more than five distinct indexes fail, the entire Job will terminate.
- The logic in the Python script ensures that all even-indexed jobs will fail, leading to a failure condition if too many even-indexed jobs are executed.

This configuration effectively demonstrates how Kubernetes Jobs can manage parallel processing and handle failures on an indexed basis, allowing for fine-grained control over job execution and error handling.


---
title:  "Building Your First Argo Workflows Pipeline"
date: 2024-08-10T14:10:06+01:00
draft: false
---


As a Staff Software Engineer specializing in Site Reliability Engineering (SRE) and pipelines, I’ve found Argo Workflows to be an excellent tool for orchestrating complex, parallel workflows on Kubernetes. In this article, I’ll guide you through creating your first Argo Workflows pipeline, complete with code snippets and explanations.

## What is Argo Workflows?

Argo Workflows is a container-native workflow engine for orchestrating parallel jobs on Kubernetes. It allows you to define complex workflows as a series of steps, each running in its own container.

## Getting Started

First, ensure you have a Kubernetes cluster and Argo Workflows installed. Then, let’s create a simple pipeline that demonstrates some key features.

## Our First Pipeline

We’ll create a pipeline that does the following:

    Generates a random number
    Performs two parallel operations on that number
    Combines the results

Here’s the YAML definition for our workflow:

```
yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: my-first-workflow-
spec:
  entrypoint: my-pipeline
  templates:
  - name: my-pipeline
    steps:
      - name: generate-number
        template: generate
      - name: process-a
        template: process
        arguments:
          parameters:
          - name: input
            value: "{{steps.generate-number.outputs.result}}"
      - name: process-b
        template: process
        arguments:
          parameters:
          - name: input
            value: "{{steps.generate-number.outputs.result}}"
      - name: combine
        template: combine
        arguments:
          parameters:
          - name: a
            value: "{{steps.process-a.outputs.result}}"
          - name: b
            value: "{{steps.process-b.outputs.result}}"

  - name: generate
    script:
      image: python:alpine3.6
      command: [python]
      source: |
        import random
        print(random.randint(1, 100))

  - name: process
    inputs:
      parameters:
      - name: input
    script:
      image: python:alpine3.6
      command: [python]
      source: |
        import sys
        input = int(sys.argv[1])
        print(input * 2)

  - name: combine
    inputs:
      parameters:
      - name: a
      - name: b
    script:
      image: python:alpine3.6
      command: [python]
      source: |
        import sys
        a, b = int(sys.argv[1]), int(sys.argv[2])
        print(f"Result: {a + b}")
```

Let’s break down this pipeline:

1. Workflow Structure: The workflow is defined using Kubernetes-style YAML. It consists of a series of templates, each defining a step in our pipeline.
2. Entrypoint: The entrypoint field specifies which template to run first. In this case, it’s my-pipeline.
3. Steps: The my-pipeline template defines the sequence of steps. Steps at the same level (with the same number of dashes) run in parallel.
4. Generate Number: The first step uses the generate template to create a random number between 1 and 100.
5. Parallel Processing: The next step runs two processes in parallel (process-a and process-b), both using the process template. They take the generated number as input and double it.
6. Combine Results: The final step uses the combine template to add the results from the parallel processes.
7. Templates: Each template (generate, process, combine) specifies a container image and a Python script to run.
8. Passing Data: Data is passed between steps using the {{steps.step-name.outputs.result}} syntax.

## Running the Workflow

To run this workflow, save it as my-workflow.yaml and execute:

```
kubectl create -f my-workflow.yaml
```

You can then monitor the workflow’s progress using:

```
kubectl get workflows
kubectl get pods
```

## Conclusion

This simple example demonstrates several key features of Argo Workflows:

    Defining multi-step workflows
    Running steps in parallel
    Passing data between steps
    Using different containers for different tasks

As you become more comfortable with Argo Workflows, you can create more complex pipelines, incorporate conditional logic, use loops, and even nest workflows within each other.

Argo Workflows is a powerful tool for creating scalable, reproducible pipelines in Kubernetes environments. Whether you’re processing data, running CI/CD pipelines, or orchestrating complex analytical workflows, Argo Workflows provides the flexibility and power to meet your needs.

Would you like me to explain or break down any part of this code or article in more detail?

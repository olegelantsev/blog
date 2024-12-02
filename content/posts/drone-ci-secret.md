---
title:  "How to pass secret as build argument to Docker build in DroneCI"
date: 2024-04-15T17:51:06+01:00
draft: false
---

When it comes to building and deploying software, keeping secrets safe is crucial. I use DroneCI as a CI solution and sometimes need to pass secrets as build arguments to Docker build command in ECR DroneCI plugin. Documentation of ECR plugin (at least when I looked it up) didn't mention `build_args_from_env` parameter. This parameter lets you pass secrets from environment variables as build arguments.

## What is build_args_from_env?

Here's how it works:

- Define Your Secrets: First, you set up your secret values as environment variables either in DroneCI itself or in a separate secrets management system.

- Use build_args_from_env: Next, you use the `build_args_from_env` parameter in your DroneCI step to pass these environment variables as build arguments. This means your secrets stay hidden from prying eyes.

- Access Secrets Safely: Your build process can now access these secret values without actually having to include them in your configuration files or scripts.

## Example: Using build_args_from_env with the ECR Plugin

Let's walk through a practical example using the Amazon Elastic Container Registry (ECR) plugin in DroneCI. Imagine you have AWS access keys that you need to keep safe.

* Set Up Your Secrets: You define your AWS access key and secret key as secrets in DroneCI or your preferred secrets management system.

* Configure Your Build Step: In your DroneCI pipeline configuration, you use `build_args_from_env` to link your AWS access key and secret key environment variables to the ECR plugin's build arguments.

```yaml
steps:
  - name: build
    image: plugins/ecr
    environment:
      AWS_ACCESS_KEY_ID:
        from_secret: aws_access_key
      AWS_SECRET_ACCESS_KEY:
        from_secret: aws_secret_key
    settings:
      build_args_from_env:
        - AWS_ACCESS_KEY_ID
        - AWS_SECRET_ACCESS_KEY
      repo: your-ecr-repository
      tags:
        - latest
```

With this setup, your AWS secrets are kept safe, and your build process can run smoothly without exposing sensitive information.
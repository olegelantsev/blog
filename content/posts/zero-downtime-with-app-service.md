---
title:  "Zero downtime app deployment with Azure App Service"
date: 2022-05-02T09:07:00+01:00
draft: false
cover:
    image: "images/zero_downtime_with_azure_app_service.png"
    caption: "Zero donwtime app deployment with Azure App Service"
---

<!-- ![Design overview](/images/zero_downtime_with_azure_app_service.webp) -->

One of the problems in DevOps is deployment of an app seamless for the user, i.e. with zero cold starts and zero downtime.
This is how you can achieve zero-downtime deployment of a three tier application with frontend, API and a database, hosted in Azure cloud.

Azure App Service is a PaaS for running .NET, .NET Core, Java, Ruby, Node.JS, PHP or Python apps. It provides managed production environment, so no need to patch or maintain OS yourself, and no need to explicitly provision the underneath infrastructure such as VMs.
What is important for zero-downtime case, is the slots mechanism - the App Service way for continuous integration and deployment.

Deployment slots are the apps, having their own hostnames & settings. App service can have multiple slots, in this case - Production and staging. Deployment happens through a slot swap. This way application configuration can be validated together with the app in staging environment before it reaches production. App Service can warm up the slot before it is swapped into production. Slots can be swapped automatically if staging passes the validation. The traffic will be redirected to a new slot without any request being dropped.

In case you want to rollback the application to the previous version, the old slot remains available and previous good state can be restored easily with another swap.


Read more on [Azure App Service deployment with slots](https://docs.microsoft.com/en-us/azure/app-service/deploy-staging-slots)
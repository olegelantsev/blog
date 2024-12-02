---
title:  "Comparison of Telemetry Instrumentation: New Relic vs. OpenTelemetry"
date: 2024-07-20T17:51:06+01:00
draft: false
---

# Introduction to Telemetry Instrumentation

Telemetry instrumentation is the process of collecting, transmitting, and analyzing data from software applications to monitor their performance and behavior. This data, often referred to as telemetry data, includes metrics, logs, and traces that help developers and operations teams understand how applications are performing and identify any issues that may arise.

Effective telemetry instrumentation allows for proactive monitoring, faster troubleshooting, and improved system reliability. It is a crucial component in modern software development and operations, especially in environments that leverage microservices and distributed systems.

# What is OpenTelemetry?

OpenTelemetry is an open-source project that provides a set of APIs, libraries, agents, and instrumentation to enable observability in software applications. It is a part of the Cloud Native Computing Foundation (CNCF) and aims to provide a unified standard for collecting and transmitting telemetry data.

# Why Companies are Interested in OpenTelemetry

Vendor-Neutral: OpenTelemetry is vendor-neutral, allowing organizations to avoid vendor lock-in. This means that telemetry data collected using OpenTelemetry can be sent to any backend system, offering flexibility and choice.

Community-Driven: As an open-source project, OpenTelemetry benefits from contributions from a wide range of developers and organizations, leading to rapid innovation and a diverse set of features.

Comprehensive: OpenTelemetry supports multiple languages and frameworks, making it a comprehensive solution for organizations with diverse tech stacks.

Standardization: By adopting OpenTelemetry, organizations can standardize their observability practices across different teams and applications, simplifying the monitoring and debugging process.

# What is New Relic?

New Relic is a cloud-based observability platform that provides a comprehensive suite of tools for monitoring and managing application performance. It offers features such as real-time metrics, logs, traces, and dashboards to help organizations understand the health and performance of their applications.

# What does New Relic provide?

Full-Stack Observability: New Relic offers end-to-end monitoring across the entire technology stack, including applications, infrastructure, and user experience.

Powerful Dashboards and Alerts: New Relic provides intuitive dashboards and advanced alerting capabilities to help teams quickly identify and respond to issues.

Integrated APM: Application Performance Monitoring (APM) is a core feature of New Relic, providing deep insights into application performance and helping to pinpoint bottlenecks and errors.

Machine Learning and AI: New Relic leverages machine learning and artificial intelligence to provide predictive analytics and anomaly detection, enhancing proactive monitoring.

# Why Compare OpenTelemetry with New Relic?

As someone with experience using New Relic, I am interested in comparing it with OpenTelemetry to understand the re-instrumentation effort required at the engineering team level. This comparison will focus on a minimal application instrumentation scenario for a containerized .NET Core application running in a Debian environment, collecting R.E.D. (Rate, Errors, Duration) metrics at the application endpoint level.

# Instrumenting a .NET Core Application with New Relic

New Relic instrumentation for a .NET Core application is typically straightforward and involves setting up the New Relic agent in the application's Dockerfile. Here is a sample Dockerfile:

```
# Publish your application.
COPY INSERT_NAME_OF_APP_TO_BE_PUBLISHED /app

# Install the New Relic agent
RUN apt-get update && apt-get install -y wget ca-certificates gnupg \
    && echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
    && wget https://download.newrelic.com/548C16BF.gpg \
    && apt-key add 548C16BF.gpg \
    && apt-get update \
    && apt-get install -y newrelic-dotnet-agent \
    && rm -rf /var/lib/apt/lists/*

# Enable the New Relic agent
ENV CORECLR_ENABLE_PROFILING=1 \
    CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A} \
    CORECLR_NEWRELIC_HOME=/usr/local/newrelic-dotnet-agent \
    CORECLR_PROFILER_PATH=/usr/local/newrelic-dotnet-agent/libNewRelicProfiler.so \
    NEW_RELIC_LICENSE_KEY=INSERT_YOUR_LICENSE_KEY \
    NEW_RELIC_APP_NAME=INSERT_YOUR_APP_NAME

WORKDIR /app

ENTRYPOINT ["dotnet", "./YOUR_APP_NAME.dll"]
```

Instrumenting a .NET Core Application with OpenTelemetry

Instrumenting a .NET Core application with OpenTelemetry requires additional steps, including setting up the OpenTelemetry SDK, configuring exporters, and integrating the OpenTelemetry libraries into the application code. Here is an example Dockerfile and application setup:

Dockerfile

```
# Base image for .NET applications
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

# Copy the application files
COPY INSERT_NAME_OF_APP_TO_BE_PUBLISHED /app

# Install necessary dependencies
RUN apt-get update && apt-get install -y wget ca-certificates gnupg

# Install OpenTelemetry collector
RUN wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.24.0/otelcol_0.24.0_linux_amd64.tar.gz \
    && tar -xvf otelcol_0.24.0_linux_amd64.tar.gz -C /usr/local/bin/ \
    && rm otelcol_0.24.0_linux_amd64.tar.gz

WORKDIR /app

ENTRYPOINT ["dotnet", "./YOUR_APP_NAME.dll"]
```

## Application Code

In your .NET Core application, you need to add the OpenTelemetry libraries and configure them. Here's an example setup in Program.cs:


```
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using OpenTelemetry.Trace;
using OpenTelemetry.Resources;

public class Program
{
    public static void Main(string[] args)
    {
        CreateHostBuilder(args).Build().Run();
    }

    public static IHostBuilder CreateHostBuilder(string[] args) =>
        Host.CreateDefaultBuilder(args)
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<Startup>();
            })
            .ConfigureServices(services =>
            {
                services.AddOpenTelemetryTracing(builder =>
                {
                    builder.SetResourceBuilder(ResourceBuilder.CreateDefault().AddService("INSERT_YOUR_APP_NAME"))
                           .AddAspNetCoreInstrumentation()
                           .AddHttpClientInstrumentation()
                           .AddJaegerExporter(); // Or any other exporter of your choice
                });
            });
}
```

Comparison: New Relic vs. OpenTelemetry

# Setup Complexity

New Relic: Setting up New Relic for a .NET Core application involves minimal changes to the Dockerfile and environment variables. The process is straightforward and well-documented.

OpenTelemetry: Setting up OpenTelemetry requires additional steps, including configuring the SDK, adding instrumentation libraries, and setting up exporters. This adds complexity to the setup process.

# Flexibility and Vendor Lock-In

New Relic: As a proprietary solution, New Relic provides a tightly integrated platform but can lead to vendor lock-in.

OpenTelemetry: Being vendor-neutral, OpenTelemetry offers greater flexibility and avoids vendor lock-in, allowing data to be sent to various backends.

# Community and Support

New Relic: Offers dedicated support and comprehensive documentation, which can be beneficial for teams looking for reliable assistance.

OpenTelemetry: As an open-source project, it benefits from a large community of contributors but may require more effort to find specific support or solutions.

# Instrumentation Effort

New Relic: Minimal instrumentation effort is required, as the agent automatically collects R.E.D. metrics.

OpenTelemetry: Requires more effort to instrument the application code and configure exporters, but provides greater customization and control over the collected telemetry data.

# Conclusion

Both New Relic and Datadog provide out-of-the-box solutions that are easy to integrate and come with robust support and comprehensive features. These platforms offer a simplified setup, making them ideal for teams seeking a quick and efficient way to implement observability in their applications.

On the other hand, OpenTelemetry is an open standard that provides a flexible and vendor-neutral approach to observability. It allows engineering teams to switch observability providers seamlessly, as long as they support the OpenTelemetry standard. This flexibility enables organizations to avoid vendor lock-in and tailor their observability strategy to meet specific needs and preferences.

Choosing between these options depends on your specific requirements and long-term strategy. If you prioritize ease of integration and immediate out-of-the-box functionality, New Relic or Datadog may be the better choice. However, if you value flexibility and the ability to switch providers without re-instrumenting your applications, OpenTelemetry offers a compelling solution. By understanding the strengths and trade-offs of each approach, you can make an informed decision that aligns with your engineering goals and organizational needs.
---
title:  "Setting up the dev blog in Azure"
date: 2020-12-05T17:51:06+01:00
draft: false
---


Cloud technologies is sort of LEGO, I like to build the systems out of these blocks. That is why I decided to start my dev blog in the cloud and first article is about technical aspect of it.

For the blog I decided to use static website hosted on cloud storage with connected CDN. It has a few advantages compared to VPS solutions I used before:

- no need to pay a for VPS and maintain it
- high availability - at least 99.9% for Azure CDN (actual SLA is defined as the lowest from the chained components, and CloudFlare's free plan doesn't have an SLA :-( )
- low latency - thanks to CDN, the content is cached and served by worldwide CDN network.
- scale up automatically
- low costs

## Engine

Choosing the site-generator among popular ones is a tough task. My choice is Jekyll for now. There are plenty of plugins and themes available for it. Maybe later on I will switch over to something else.

## Hosting

My hosting solution for the blog is: 

- CloudFront for DNS and DDoS protection
- Azure for Storage & CDN
- LetsEncrypt for SSL certificate

## SSL

Many tutorials suggest to use Flexible encryption mode, where certificate is served by CloudFlare. I prefer to use my own certificate, and CloudFlare doesn't allow to bring your own SSL certificate in the free plan.

## www or not www

I noticed that many web sites I visit have no www subdomain. The problem is that domain's root can't be a CNAME (well, technically can - but may result in unexpected errors). Although CloudFlare has an RFC-compliant solution called CNAME flattening to set up a CNAME for the root domain, but this didn't work with Azure CDN custom domain verification. So I decided to stick to www and forward traffic from root domain.

## Setting up Azure

OK, now lets define the resources we need on Azure side for the blog.

- Storage account - resource holds containers of different kinds (blob, file, etc).
- CDN profile - to deliver the blog to the clients and not overload storage by client requests.
- Endpoint - connected to CDN profile.
- Key Vault - holds SSL certificate, required for HTTPS endpoint.

```bash
├── blog_rg               resource group
│   ├── blogabcdef        storage account
│   ├── blogabcdef-cdn    CDN profile
|   ├── blogabcdef        endpoint
│   └── blogabcdef        Key Vault
```

You can choose any names for the resources, not necessarily the same for all of them. What is important, names for these resources must be globally unique.

![Design overview](/images/design.webp)

## Setup steps

For now these steps are described for manual setup, later on it can be automated with ARM.

1. Create an Azure account.
1. Create resource group (I would choose the region where most of the traffic comes from).
![Creating resource group in Azure](/images/azure_create_rg.webp)
1. Create Blob Storage account.
![Creating Storage Account in Azure](/images/azure_create_storage_account.webp)
1. Enable static website functionality. This will create container called "$web", put the names of index and 404 files.
![Creating Storage Account in Azure](/images/azure_storage_enable_web.webp)
1. Upload site files to the "$web" container.
1. Create CDN pointing to the site URL.
1. Go to CloudFlare and create CNAME record for "www" subdomain pointing to Azure CDN (choose DNS-only, otherwise CNAME verification will fail).
1. Create custom domain name in Azure CDN. Verification should pass.
1. Enable SSL for custom domain in Azure
    1. Create Key Vault (you can use the same resource group).
    1. Add "Azure CDN" app to Azure Active directory by running the following command in Azure CLI.
    1. Add "Access policy" so that Azure CDN can access SSL certificate in the Key Vault. It may take 2 hours before Azure CDN can read cert.
    1. Generate LetsEncrypt SSL certificate.
    1. Convert to PFX with openssl tool.
    1. Upload PFX to Key Vault.
    1. Enable SSL in custom domain in Azure.
    1. Choose "own certificate", your Key Vault, certificate name and its version and press "Save". Don't panic if it cannot get an access to the vault - check if you created an access policy and 2 hours passed after Azure CDN is registered in AAD.
1. Create Page Rules in CloudFlare
    1. Create dummy A record for root domain and make sure its in proxy status, not direct.
    ![Dummy A record for domain root](/images/cf_root_a_record.webp)
    1. Create CNAME record for "www" pointing to Azure's DNS endpoint.
    ![CNAME record for www](/images/cf_cname.webp)
    1. In "page rules" create 2 rules:
        1. HTTPS only
        1. Forward "[example.com](http://example.com)/*" to "https://www.example.com"
        ![Dummy A record for domain root](/images/cf_page_rules.webp)
1. Done
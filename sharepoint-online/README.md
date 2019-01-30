# SharePoint Online Management

This folder contains management guides and scripts for SharePoint Online.

## Site-FileRestore

This is a guide to search and restore deleted files on a SharePoint site collection. There are examples on filtering by user, time window or date.
Use the snippet below to configure the required environment variables.


```
#Use a SharePoint Administrator credential

[Environment]::SetEnvironmentVariable("service_user", "samAccountName", "User")
[Environment]::SetEnvironmentVariable("service_pass", "PASSWORD HERE", "User")

```
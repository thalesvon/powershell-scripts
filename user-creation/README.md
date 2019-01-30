# User creation on exchange hybrid scenario

This folder contains scripts that will automate the creation process of users on a hybrid scenario. This README.md file goes over
the general instructions for both scenarios: users created on On-Premise Exchange Server and Office365 Exchange Online. 
For specific instruction, refer to README.md on each folder.

## Getting Started

These scripts are to be executed on a **Domain Controler** but before you can create your users with ease, use the PowerShell
snippet bellow to configure the required environment varibles, after configuring the varibles reopen PowerShell and check the variables with
``` Get-ChildItem env: ```.

```

#Use a service account with AD management rights and Exchage admin rights, i.e. Domain Admin

[Environment]::SetEnvironmentVariable("mail_smtp_server", "SMTP.SERVER.URI", "User")
[Environment]::SetEnvironmentVariable("mail_smtp_port", "SMTP_PORT [Defaults are 25 or 587(SSL binding)]", "User")
[Environment]::SetEnvironmentVariable("mail_user", "samAccountName", "User")
[Environment]::SetEnvironmentVariable("mail_pass", "PASSWORD HERE", "User")
[Environment]::SetEnvironmentVariable("mail_user_email", "EMAIL ADDRESS", "User")
[Environment]::SetEnvironmentVariable("mail_user_name", "DISPLAY NAME", "User")
[Environment]::SetEnvironmentVariable("exchange_server_uri", "http://EXCHANGE_SERVER_FQDN/PowerShell/", "User")
[Environment]::SetEnvironmentVariable("aad_connect_server", "AAD_CONNECT_SERVER_NAME", "User")

```

## Prerequiste

* PowerShell 4.5+;
* Server with [Azure AD Connected](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-hybrid-identity) installed;
* Domain Admin account.

## User creation confirmation

After the scripts are executed an confirmation e-mail (figure 1) is sent, this is very helpful for auditing reasons. If any user account is not created by an error, an failure e-mail is sent specifing only the users that were not created (figure 2).

![Figure 1 - Email Success](images/email_success.jpg)
![Figure 2 - Email Fail](images/email_fail.jpg)

## Contributing

This script needs a lot of improvements, if you have any suggestion fell free to contact me and create pull requests.
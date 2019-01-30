# Office365 User creation

## Instruction

The file **new_365.csv** and **Office365_new_user.ps1** should be in the same directory.

## Setup

Although most variables are [environment defined](/user-creation/README.md), there are some things that need to be changed before execution. These are mostly regarding exchange online properties.

````

    #Proxy Address x500, used for internal routing
    $x500_replace_entry = "/o=ExchangeLabs"
    $x500_domain_entry = "/o=contosco"

    #Default user password
    $PlainTextPassword="SOME_DEFAULT_PASSWORD_FOR_FIRST_TIME_LOGIN" 

    #Remote routing address of Office365 tenant
    $remote_routing_address="contosco.mail.onmicrosoft.com"

    #Default group for any created account. Example: Proxy Internet Profile
    $default_group = "AD GROUP NAME"

```

## Execution

```
    cd path/to/script
    .\Office365_new_user.ps1

```
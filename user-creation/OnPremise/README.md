# Office365 User creation

## Instruction

The file **new_exchange.csv** and **exchange_new_user.ps1** should be in the same directory.

## Setup

Although most variables are [environment defined](/user-creation/README.md), there are some things that need to be changed before execution. These are mostly regarding exchange online properties.

```

    #Define exchange database
    $maildb = "NAME OF EXCHANGE DATABASE"

    #Proxy Address x500
    $x500_replace_entry = "/o=ExchangeLabs"
    $x500_domain_entry = "/o=contosco"

    #Default user password
    $PlainTextPassword="SOME_DEFAULT_PASSWORD_FOR_FIRST_TIME_LOGIN" 

    #Default group for any created account. Example: Proxy Internet Profile
    $default_group = "AD GROUP NAME"

```

## Execution

```
    cd path/to/script
    .\exchange_new_user.ps1

```
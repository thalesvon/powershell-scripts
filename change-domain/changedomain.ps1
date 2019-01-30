# 1.  Specify the new computer name. 
$NewHostName = "$(hostname)" 
 
# 2.  Specify the domain to join. 
$DomainToJoin = "contosco.com" 
 
# 3.  Specify the OU where to put the computer account in the domain.  Use the OU's distinguished name. 
$OU = "OU=Path,DC=to,DC=OrganizationUnit" 
 
 
# Join the computer to the domain, rename it, and restart it. 
Add-Computer -DomainName $DomainToJoin -OUPath $OU -NewName $NewHostName -Restart
Install-Module SharePointPnPPowerShellOnline

#use sharepoint online admin credentials
$user = "$($env:service_user)"
$pass =  "$($env:service_pass)"
$securepass = $pass | ConvertTo-SecureString -AsPlainText -Force
$UserCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $securepass

$site_url='https://contoso.sharepoint.com/teams/team1'
Connect-PnPOnline -Url $site_url -Credentials $UserCredential

#count items on recycle bin
(Get-PnPRecycleBinItem).count


#set the restore date to yesterday
$today = (Get-Date)
$restoreDate = $today.date.AddDays(-1)
 
#get all items that are deleted yesterday or today, select the last 100 items and display a list with all properties
Get-PnPRecycleBinItem | ? DeletedDate -gt $restoreDate | select -last 100 | ft DeletedByEmail, Title

#filter on user
$user="johndoe@contosco.com"
(Get-PnPRecycleBinItem -FirstStage | ? {($_.DeletedDate -lt $restoreDate) -and ($_.DeletedByEmail -eq $user)}).count

#Get all files that will be restored
Get-PnPRecycleBinItem | ? {($_.DeletedDate -gt $restoreDate) -and ($_.DeletedByEmail -eq $user)}

Get-PnPRecycleBinItem -firststage | ? {($_.DeletedDate -gt $restoreDate) -and ($_.DeletedByEmail -eq $user)} | Restore-PnpRecycleBinItem -Force


#restore files deleted by some user in a given time window
$today = (Get-Date) 
$date1 = $today.date.addHours(-10)
$date3 = $today.date.AddHours(-11)
(Get-PnPRecycleBinItem | ? { ($_.DeletedDate -gt $date3) -and ($_.DeletedDate -lt $date1)}).count 

Get-PnPRecycleBinItem -firststage | ? { ($_.DeletedDate -gt $date3) -and ($_.DeletedDate -lt $date1) -and ($_.DeletedByEmail -eq $user)} | Restore-PnpRecycleBinItem -Force
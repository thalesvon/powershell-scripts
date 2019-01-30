
# Exchange Server Remote Session 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $($env:exchange_server_uri) -Authentication Kerberos
Import-PSSession $Session -AllowClobber

$INPUT_FILE=Get-ChildItem 'new_exchange.csv'
Write-Host Criação de usuários -ForegroundColor Yellow
$body_success = @("<p>On-Premise New User Account Details</p><br><br><table>
        <tr>
            <th>DisplayName    </th>
            <th>samAccountName    </th>
            <th>UserPrincipalName    </th>
            <th>Description    </th>
            <th>POBox    </th>
            <th>CRM REF    </th>
        </tr>")

$body_failure =@("<p style='color:red'>FAILED On-Premise New User Account Details</p><br><br><table>
        <tr>
            <th>DisplayName    </th>
            <th>samAccountName    </th>
            <th>UserPrincipalName    </th>
            <th>Description    </th>
            <th>POBox    </th>
            <th>CRM REF    </th>
        </tr>")

$failed_user=$false

Import-Csv $INPUT_FILE -Delimiter ";" |
foreach {
$name = $_.name
$given = $_.givenName
$sur = $_.surName
$sam = $_.samAccountName
$description = $_.description
$pobox = $_.pobox
$caso = $_.crmref
$upn = $_.UserPrincipalName
$empNUM = $_.employeeNumber
$office = $_.office
$title = $_.title
$department = $_.department
$gestor = $_.manager
$ou = $_.ou
   
    #Define exchange database
    $maildb = "NAME OF EXCHANGE DATABASE"

    #Proxy Address x500
    $x500_replace_entry = "/o=ExchangeLabs"
    $x500_domain_entry = "/o=contosco"

    #Default user password
    $PlainTextPassword="SOME_DEFAULT_PASSWORD_FOR_FIRST_TIME_LOGIN" 

    #Default group for any created account. Example: Proxy Internet Profile
    $default_group = "AD GROUP NAME"

    If($Session -eq $null -or $Session.State -eq 'Broken'){
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $($env:exchange_server_uri) -Authentication Kerberos
        Import-PSSession $Session -AllowClobber
    }
    Else{
        Write-Host -ForegroundColor Yellow 'Remote PSSession is active'
    }

    $PlainTextPassword="SOME_DEFAULT_PASSWORD_FOR_FIRST_TIME_LOGIN" 
    $pass=ConvertTo-SecureString -String $PlainTextPassword -AsPlainText -Force

    
    $user = $(try {Get-ADUser $sam} catch {$null})
    If($user -ne $null){
        $failed_user=$true
        Write-Host The user $sam already exists -ForegroundColor Red
        Write-Host Check the input data on $INPUT_FILE
        $body_failure += "<tr>"
            $body_failure += "<td>$($name)</td>"
            $body_failure += "<td>$($sam)</td>"
            $body_failure += "<td>$($upn)</td>"
            $body_failure += "<td>$($description)</td>"
            $body_failure += "<td>$($pobox)</td>"
            $body_failure += "<td>$($caso)</td>"
        $body_failure += "</tr>"
    }
    Else{
        Write-Host The user $name will be created -ForegroundColor Green
        if($gestor -eq ''){
            New-ADUser -DisplayName "$name" `
                       -EmailAddress "$upn" `
                       -Name "$name"  `
                       -GivenName "$given" `
                       -Surname "$sur" `
                       -Description "$description" `
                       -SamAccountName "$sam" `
                       -UserPrincipalName "$upn" `
                       -EmployeeNumber "$empNUM" `
                       -Title "$title" `
                       -Department $department `
                       -POBox $pobox `
                       -Office "$office" `
                       -AccountPassword $pass `
                       -Path "$ou" `
                       -PassThru | Enable-ADAccount
        }
        Else{
            New-ADUser -DisplayName "$name" `
                       -EmailAddress "$upn" `
                       -Name "$name"  `
                       -GivenName "$given" `
                       -Surname "$sur" `
                       -Description "$description" `
                       -SamAccountName "$sam" `
                       -UserPrincipalName "$upn" `
                       -EmployeeNumber "$empNUM" `
                       -Title "$title" `
                       -Department $department `
                       -Manager $gestor `
                       -POBox $pobox `
                       -Office "$office" `
                       -AccountPassword $pass `
                       -Path "$ou" `
                       -PassThru | Enable-ADAccount
        }
    
    try{
        Enable-Mailbox -Identity $sam -Database $maildb
    }
    catch{
        Write-Host Erro ao criar o usuário $sam -ForegroundColor Red
    }

    #This section deals with X500 proxy address. This address is used for
    #internal routing between exchange servers and exchange online

    $ProxyAddress1 = Get-ADUser $sam -Properties * | Select legacyExchangeDN
    Set-ADUser $sam -Add @{'proxyaddresses' = 'X500:'+$ProxyAddress1.legacyExchangeDN}

    $ProxyAddress2= $ProxyAddress1.legacyExchangeDN -replace "(.*)$x500_domain_entry(.*)","`$1$x500_replace_entry`$2"

    Set-ADUser $sam -Add @{'proxyaddresses' = 'X500:'+$ProxyAddress2}

    #Default AD group
    Add-ADGroupMember -Identity $default_group -Members $sam

    $body_success += "<tr>"
        $body_success += "<td>$($name)</td>"
        $body_success += "<td>$($sam)</td>"
        $body_success += "<td>$($upn)</td>"
        $body_success += "<td>$($description)</td>"
        $body_success += "<td>$($pobox)</td>"
        $body_success += "<td>$($caso)</td>"
    $body_success += "</tr>"    

    }
    
}

$body_success += "</table>"
$body_success = $body_success | out-string

$body_failure += "</table>"
$body_failure = $body_failure | out-string


$emailSmtpServer = "$($env:mail_smtp_server)"
$emailSmtpServerPort = "$($env:mail_smtp_port)"
$emailSmtpUser = "$($env:mail_user)"
$emailSmtpPass = "$($env:mail_pass)"
 
$emailMessage = New-Object System.Net.Mail.MailMessage
$emailMessage.From = " $($env:mail_user_name) <$($env:mail_user_email)>"
$emailMessage.To.Add( "$($env:mail_user_email)")
$emailMessage.Subject = "On-Premise - New User Created"
$emailMessage.IsBodyHtml = $true
$emailMessage.Body = $body_success
 
$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
$SMTPClient.Send( $emailMessage )

#failure email
if($failed_user -eq $true){
    $emailMessage = New-Object System.Net.Mail.MailMessage
    $emailMessage.From = " $($env:mail_user_name) <$($env:mail_user_email)>"
    $emailMessage.To.Add( "$($env:mail_user_email)")
    $emailMessage.Subject = "FAILED On-Premise - Users not Created"
    $emailMessage.IsBodyHtml = $true
    $emailMessage.Body = $body_failure
    $SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
    $SMTPClient.EnableSsl = $true
    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
    $SMTPClient.Send( $emailMessage )
    
}
Pause
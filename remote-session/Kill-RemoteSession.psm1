function Kill-RemoteSession {
    <#  
    .SYNOPSIS  
        Kill all user sessions from local or remote computers(s)
    
    .DESCRIPTION
        Kill all user sessions from local or remote computer(s).
        
        Script depends on Get-UserSession (https://gallery.technet.microsoft.com/scriptcenter/Get-UserSessions-Parse-b4c97837#content)
        Place Get-UserSession.ps1 on same directory as this script
    
    .PARAMETER computername
        Name of computer(s) to run session query against
                                      
    .FUNCTIONALITY
        Computers
    
    .EXAMPLE
        Kill-RemoteSession -computername "server1"
    
        Kills all current disconnected user sessions on 'server1'
    
    .EXAMPLE
        Kill-RemoteSession -computername $servers
    
        Kills all current disconnected user sessions on specified in array $servers
    
    .NOTES
        Thanks to Cookie.Monster for the Get-UserSession function available at https://gallery.technet.microsoft.com/scriptcenter/Get-UserSessions-Parse-b4c97837#content
    
    .LINK
        <not set>
    
    #>  
        [cmdletbinding()]      
        Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline = $True)]
        [string[]]$ComputerName = "localhost"
        )
        Process
        {
            #Add Get-UserSession.ps1 to PS local session, so it can be invoked as a cmdlet. Change $functionPath accordingly
            
            $functionPath = "$pwd\Get-UserSession.ps1"
            . $functionPath
    
            #$serverList = 'SRVS001'
            foreach($server in $ComputerName){
    
                $serverSessionList = Get-UserSession -ComputerName $server | Sort State
        
        
            }
        
            foreach($serverSession in $serverSessionList){
            
                If($serverSession.State -eq 'Disco'){
                
                    Write-Host "Logging Off user:$($serverSession.Username) from server: $($serverSession.ComputerName)"
    
                    logoff $($serverSession.Id) /server:$($serverSession.ComputerName)
    
                }Else{
            
                    Write-Host "User:$($serverSession.Username) has an active session on server: $($serverSession.ComputerName)"
    
                }
    
            }
        }
    }
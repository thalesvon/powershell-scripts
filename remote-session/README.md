# Remote Session Management

This folder contains scripts for management of remote session on Windows Machines

## Kill-RemoteSession

PowerShell functions that kill all user sessions from local or remote computer(s). This is very useful in a environment with a lot of server acessible by RDP, as users tend to forget to logoff from servers which leads to a [session deadlock](https://support.cloudconnect.net/support/solutions/articles/1000136686-cct-201410155-the-task-you-are-trying-to-do-can-t-be-completed-because-remote-desktop-services-is-)

### Dependencies

Script depends on Get-UserSession (https://gallery.technet.microsoft.com/scriptcenter/Get-UserSessions-Parse-b4c97837#content)
Place Get-UserSession.ps1 on same directory as this script

## Execution

```
    #Add Kill-RemoteSession to your session: 
        . "\\Path\To\Kill-RemoteSession.ps1" 
    
    #Get help for Kill-RemoteSession 
        Get-Help Kill-RemoteSession -Full 
    
    #Kill sessions on a remote server 
        Kill-RemoteSession -ComputerName Server14 
    
    #Kill sessions on a group of remote servers
        Kill-RemoteSession -ComputerName $Servers

```

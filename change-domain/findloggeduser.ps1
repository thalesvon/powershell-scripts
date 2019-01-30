do{
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'User finder'
$msg   = 'Enter hostname'

$computer = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)


Get-WmiObject -Class win32_process -ComputerName $computer |
    Where-Object{ $_.Name -eq "explorer.exe" } |
    ForEach-Object{ 
        $user=($_.GetOwner()).Domain + "\\" + ($_.GetOwner()).User;
        }


$serach_again=[System.Windows.Forms.MessageBox]::Show("Computer: $($computer) `n User: $($user) `n`n Search Again?","Search again?",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
}while($serach_again -eq "Yes")
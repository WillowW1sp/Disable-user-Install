# Check for Admin Privileges
function Test-IsAdmin {
    $currentIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($currentIdentity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Relaunch script with elevation if not running as admin
if (-not (Test-IsAdmin)) {
    $scriptPath = $MyInvocation.MyCommand.Path
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
    $psi.Verb = "runas"
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Script must be run as administrator. Exiting.","Permission Required")
    }
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "User Install Policy Manager"
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = "CenterScreen"

# Button to Enable Policy (Prohibit user installs)
$enableButton = New-Object System.Windows.Forms.Button
$enableButton.Text = "Disable User Installs"
$enableButton.Size = New-Object System.Drawing.Size(350,40)
$enableButton.Location = New-Object System.Drawing.Point(20,90)
$enableButton.Add_Click({
    try {
        $regPath = "HKLM:\Software\Classes\Msi.Package\DefaultIcon"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "(Default)" -Value "C:\Windows\System32\msiexec.exe,1" -Type String
        [System.Windows.Forms.MessageBox]::Show("Policy Enabled: User installs are now hidden/prohibited.","Success")
	[System.Windows.Forms.MessageBox]::Show("Please Reboot for changes to take effect","Reboot")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to enable policy.`n$_","Error")
    }
})

# Button to Disable Policy (Allow user installs)
$disableButton = New-Object System.Windows.Forms.Button
$disableButton.Text = "Enable User Installs"
$disableButton.Size = New-Object System.Drawing.Size(350,40)
$disableButton.Location = New-Object System.Drawing.Point(20,30)
$disableButton.Add_Click({
    try {
        $regPath = "HKLM:\Software\Classes\Msi.Package\DefaultIcon"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "(Default)" -Value "C:\Windows\System32\msiexec.exe,0" -Type String
        [System.Windows.Forms.MessageBox]::Show("Policy Disabled: User installs are allowed.","Success")
	[System.Windows.Forms.MessageBox]::Show("Please Reboot for changes to take effect","Reboot")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to disable policy.`n$_","Error")
    }
})

# Add buttons to form
$form.Controls.Add($enableButton)
$form.Controls.Add($disableButton)

# Run form
[void]$form.ShowDialog()

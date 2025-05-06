Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# Create Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "User Install Policy Manager"
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = "CenterScreen"

# Button to Enable Policy (Prohibit user installs)
$enableButton = New-Object System.Windows.Forms.Button
$enableButton.Text = "Enable 'Prohibit User Installs'"
$enableButton.Size = New-Object System.Drawing.Size(350,40)
$enableButton.Location = New-Object System.Drawing.Point(20,30)
$enableButton.Add_Click({
    try {
        $regPath = "HKLM:\Software\Policies\Microsoft\Windows\Installer"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "EnableUserInstalls" -Value 0 -Type DWord
        [System.Windows.Forms.MessageBox]::Show("Policy Enabled: User installs are now hidden/prohibited.","Success")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to enable policy.`n$_","Error")
    }
})

# Button to Disable Policy (Allow user installs)
$disableButton = New-Object System.Windows.Forms.Button
$disableButton.Text = "Disable 'Prohibit User Installs'"
$disableButton.Size = New-Object System.Drawing.Size(350,40)
$disableButton.Location = New-Object System.Drawing.Point(20,90)
$disableButton.Add_Click({
    try {
        $regPath = "HKLM:\Software\Policies\Microsoft\Windows\Installer"
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name "EnableUserInstalls" -Value 1 -Type DWord
        [System.Windows.Forms.MessageBox]::Show("Policy Disabled: User installs are allowed.","Success")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to disable policy.`n$_","Error")
    }
})

# Add buttons to form
$form.Controls.Add($enableButton)
$form.Controls.Add($disableButton)

# Run form
[void]$form.ShowDialog()

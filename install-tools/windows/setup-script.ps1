using namespace System.Management.Automation.Host

$bloat_apps = @(
    @{id = "Clipchamp.Clipchamp_yxz26nhyzhsrt"; name="Clipchamp"},
    @{id = "Microsoft.549981C3F5F10_8wekyb3d8bbwe"; name="Cortana"},
    @{id = "Microsoft.BingNews_8wekyb3d8bbwe"; name="News"},
    @{id = "Microsoft.BingWeather_8wekyb3d8bbwe"; name="MSN Weather"},
    @{id = "Microsoft.Getstarted_8wekyb3d8bbwe"; name="Microsoft Tips"},
    @{id = "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe"; name="Microsoft 365 (Office)"},
    @{id = "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe"; name="Solitaire & Casual Games"},
    @{id = "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe"; name="Microsoft Sticky Notes"},
    @{id = "Microsoft.MixedReality.Portal_8wekyb3d8bbwe"; name="Mixed Reality Portal"}
    @{id = "Microsoft.Office.OneNote_8wekyb3d8bbwe"; name="OneNote for Windows 10"}
    @{id = "Microsoft.OutlookForWindows_8wekyb3d8bbwe"; name="Outlook for Windows"}
    @{id = "Microsoft.People_8wekyb3d8bbwe"; name="Microsoft People"},
    @{id = "Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe"; name="Power Automate"},
    @{id = "Microsoft.SkypeApp_kzf8qxf38zg5c"; name="Skype"},
    @{id = "Microsoft.Todos_8wekyb3d8bbwe"; name="Microsoft To Do"},
    @{id = "Microsoft.DevHome"; name="Dev Home (Preview)"},
    @{id = "Microsoft.WindowsMaps_8wekyb3d8bbwe"; name="Windows Maps"},
    @{id = "Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe"; name="Windows Sound Recorder"},
    @{id = "Microsoft.YourPhone_8wekyb3d8bbwe"; name="Phone Link"},
    @{id = "Microsoft.ZuneVideo_8wekyb3d8bbwe"; name="Films & TV"},
    @{id = "MicrosoftTeams_8wekyb3d8bbwe"; name="Microsoft Teams"}
)

$dev_apps = @(
    @{id = "Microsoft.VisualStudioCode"; name="Microsoft Visual Studio Code"},
    @{id = "JetBrains.Toolbox"; name="JetBrains Toolbox App"},
    @{id = "Git.Git"; name="Git"},
    @{id = "GitHub.GitHubDesktop"; name="GitHub Desktop"}
);

$web_browser_apps = @(
    @{id = "Google.Chrome"; name="Google Chrome"},
    @{id = "Mozilla.Firefox"; name="Mozilla Firefox"}
)

$gaming_apps = @(
    # TODO: Add Battle.net
    @{id = "Valve.Steam"; name="Steam"},
    @{id = "GOG.Galaxy"; name="GOG GALAXY"},
    @{id = "EpicGames.EpicGamesLauncher"; name="Epic Games Launcher"},
    @{id = "ElectronicArts.EADesktop"; name="EA app"},
    @{id = "Ubisoft.Connect"; name="Ubisoft Connect"},
    @{id = "Playnite.Playnite"; name="Playnite"}
)

$utils_apps = @(
    @{id = "NordSecurity.NordVPN"; name="NordVPN"},
    @{id = "Twilio.Authy"; name="Authy Desktop"},
    @{id = "xanderfrangos.twinkletray"; name="Twinkle Tray"},
    @{id = "QL-Win.QuickLook"; name="QuickLook"},
    @{id = "Microsoft.PowerToys"; name="PowerToys (Preview)"},
    @{id = "Google.GoogleDrive"; name="Google Drive"},
    @{id = "SomePythonThings.WingetUIStore"; name="WingetUI"},
    # @{id = "9PKTQ5699M62"; name="iCloud"},
    # @{id = "9PB2MZ1ZMB1S"; name="iTunes"},
    @{id = "9P8LTPGCBZXD"; name="Wintoys"},
    @{id = "9NCBCSZSJRSB"; name="Spotify - Music and Podcasts"},
    @{id = "9NLXL1B6J7LW"; name="Password Manager SafeInCloud"},
    @{id = "9NC73MJWHSWW"; name="SyncFolder"}
)

$hardware_apps = @(
    @{id = "Logitech.GHUB"; name="Logitech G HUB"},
    @{id = "SteelSeries.GG"; name="SteelSeries GG"},
    @{id = "Nvidia.GeForceExperience"; name="NVIDIA GeForce Experience"},
    @{id = "REALiX.HWiNFO"; name="HWiNFO"},
    @{id = "9NVMNJCR03XV"; name="MSI Center"}
)

$communication_apps = @(
    @{id = "Discord.Discord"; name="Discord"},
    @{id = "9NKSQGP7F2NH"; name="WhatsApp"},
    @{id = "Viber.Viber"; name="Viber"}
)

Function Uninstall-Apps {
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [array]$apps
    )

    Foreach ($app in $apps) {
        $listApp = winget list --exact -q $app.id
        if ([String]::Join("", $listApp).Contains($app.id)) {
            Write-host -ForegroundColor Red "Removing: " $app.name
            winget uninstall -e --id $app.id 
        }
        else {
            Write-host -ForegroundColor Blue "Skipping (already removed): " $app.name
        }
    }
}

Function Install-Apps {
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [array]$apps
    )

    Foreach ($app in $apps) {
        $listApp = winget list --exact -q $app.id
        if (![String]::Join("", $listApp).Contains($app.id)) {
            Write-host -ForegroundColor Green "Installing: " $app.name
            winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.id
        }
        else {
            $color = "Blue"
            $text = "Skipping (already installed): $($app.name)"
            if([String]::Join("", $listApp).Contains("Available")) {
               $text += " (Updates available)"
               $color = "Yellow"
            }
            Write-host -ForegroundColor $color $text
        }
    }
}

Function Log {
    Param
    (
         [Parameter(Mandatory=$true)]
         [string]$message,
         [string]$colour = "Magenta"
    )

    Write-Host -ForegroundColor $colour $message
}

# Create prompt body
$title = "Software packages selection"
$message = "What would you like to do?"

# Create answers
$all_option = New-Object ChoiceDescription "Run &all", "Uninstall bloatware and install all software."
$gaming_option = New-Object ChoiceDescription "Install &gaming software","Install all gaming software."
$dev_option = New-Object ChoiceDescription "Install &development software","Install all software needed for local development."
$web_browser_option = New-Object ChoiceDescription "Install web &browsers","Install web browsers."
$communication_option = New-Object ChoiceDescription "Install &communication software","Install communication apps."
$hardware_option = New-Object ChoiceDescription "Install &hardware utilities","Install software for my hardware."
$utils_option = New-Object ChoiceDescription "Install software &utilities","Install software utilities."
$debloat_option = New-Object ChoiceDescription "&Remove bloatware","Uninstall bloatware."
$quit_option = New-Object ChoiceDescription "&Quit","Quit."

# Create ChoiceDescription with answers
$options = [ChoiceDescription[]]($all_option, $gaming_option, $dev_option, $web_browser_option, $communication_option, $hardware_option, $utils_option, $debloat_option, $quit_option)

do {
    # Show prompt and save user's answer to variable
    $response = $host.UI.PromptForChoice($title, $message, $options, 8)
    $finished = $false

    # Perform action based on answer
    switch ($response) {
        0 { # All
            Log "Uninstalling bloatware"
            Uninstall-Apps $bloat_apps

            Log "Installing all apps"
            Install-Apps $gaming_apps
            Install-Apps $dev_apps
            Install-Apps $web_browser_apps
            Install-Apps $communication_apps
            Install-Apps $hardware_apps
            Install-Apps $utils_apps
            break 
        }
        1 { # Gaming
            Log "Installing gaming apps"
            Install-Apps $gaming_apps
            break 
        }
        2 { # Development
            Log "Installing development apps"
            # TODO: Add WSL support
            Install-Apps $dev_apps
            break 
        }
        3 { # Web browsers
            Log "Installing web browser apps"
            Install-Apps $web_browser_apps
            break
        }
        4 { # Communication
            Log "Installing communication apps"
            Install-Apps $communication_apps
            break
        }
        5 { # Hardware utils
            Log "Installing hardware utilities"
            Install-Apps $hardware_apps
            break
        }
        6 { # Utils
            Log "Installing software utilities"
            Install-Apps $utils_apps
            break
        }
        7 { # Remove bloatware
            Log "Uninstalling bloatware"
            Uninstall-Apps $bloat_apps
            break
        }
        8 { # Quit
            $finished = $true
            break
        }
    }

    $message = "Is there anything else you would like to do?"
} while($finished -ne $true)

Log "Setup script finished" "Green"

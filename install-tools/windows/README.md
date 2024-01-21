# 🪟 Install software on Windows

PowerShell [script](/install-tools/windows/setup-script.ps1). `winget` first needs to set 2-letter geographic region before running this script, unfortunately, running the script itself doesn't prompt the user. First, run a command similar to this and accept the T&Cs:

```powershell
winget list
```

Run the following command to invoke the script:

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/ka5p3rr/pc-setup/main/install-tools/windows/setup-script.ps1 | Invoke-Expression
```

## 🖥️ DisplayFusion

Load configuration from backup.

## 🕹️ NVIDIA Control Panel

By default dislpay scaling is done on the display side. In NVIDIA Control Panel set the following settings.

![Nvidia Control Panel screenshot](NVIDIA_Control_Panel_scaling.png)

## Setup PowerShell

[Starship](https://starship.rs/) should be installed as part of the installation script. Make sure a [Nerd Font](https://starship.rs/guide/#prerequisites) is installed (best through Chocolatey).

Add the following line to `$PROFILE`:

```powershell
Invoke-Expression (&starship init powershell)
```

Enable preferred preset:

```powershell
starship preset pastel-powerline -o $HOME/.config/starship.toml
```

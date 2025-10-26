# If execution policy is not set to Unrestricted, change it
if ($executionPolicy -ne "Unrestricted") {
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
    Write-Host 'ExecutionPolicy set to Unrestricted.'
}

# Enable WMI (needed for managing scheduled tasks)
Set-Service -Name "Winmgmt" -StartupType Manual
Start-Service -Name "Winmgmt"

# Remove shady/redundant devices
pnputil /remove-device "DISPLAY\IVM66A5\5&35410B5&A&UID20738"
pnputil /remove-device "HID\VID_093A&PID_2533&MI_01&COL02\8&306E45C5&0&0001"
pnputil /remove-device "HID\VID_0B05&PID_1A9B&MI_00&Col03\8&23daee41&0&0002"
pnputil /remove-device "HID\VID_2DC8&PID_310A&MI_01&COL01\8&5FF2E83&0&0000"
pnputil /remove-device "HID\VID_2DC8&PID_310A&MI_01&COL03\8&5FF2E83&0&0002"
pnputil /remove-device "HID\VID_0B05&PID_1A9B&MI_00&Col01\8&23daee41&0&0000"
pnputil /remove-device "USB\VID_0B05&PID_1A9B&MI_02\7&2E5F8FAE&0&0002"
pnputil /remove-device "USB\VID_2DC8&PID_310A&MI_02\7&1BBB1AF5&0&0002"
pnputil /remove-device "HID\VID_093A&PID_2533&MI_01&COL02\8&1278375E&0&0001"
pnputil /remove-device "HID\VID_2DC8&PID_310A&MI_01&COL01\8&5FF2E83&0&0000"
pnputil /remove-device "HID\VID_093A&PID_2533&MI_01&COL02\8&1278375E&0&0001"
pnputil /remove-device "HID\VID_2DC8&PID_310A&MI_01&COL03\8&5FF2E83&0&0002"
pnputil /disable-device "HDAUDIO\FUNC_01&VEN_10DE&DEV_0099&SUBSYS_10DE13D3&REV_1001\5&1CE2157B&0&0001"
pnputil /disable-device "PCI\VEN_10DE&DEV_1AEC&SUBSYS_13D310DE&REV_A1\4&2283F625&0&0219"
pnputil /disable-device "SWD\MMDEVAPI\MicrosoftGSWavetableSynth"
pnputil /disable-device "ROOT\RDPBUS\0000"
pnputil /disable-device "PCI\VEN_10DE&DEV_1AED&SUBSYS_13D310DE&REV_A1\4&2283F625&0&0319"
pnputil /disable-device "ROOT\NET\0000"


# Disable Memory Compression
powershell -Command "Disable-MMAgent -mc"
bcdedit /set hypervisorlaunchtype off



# Remove "Home" & "Gallery" from Explorer Quick Pane
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f
reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /f /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0x00000000

# Remove duplicate drives in Explorer Quick Pane
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f

# Disable Windows Update scheduled tasks
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\UpdateOrchestrator' -TaskName 'Schedule Scan' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\UpdateOrchestrator' -TaskName 'Schedule Scan Static Task' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\WindowsUpdate' -TaskName 'Scheduled Start' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\WindowsUpdate' -TaskName 'Scheduled Start With Network' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\WindowsUpdate' -TaskName 'Scheduled Start With Automatic Maintenance' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\Printing' -TaskName 'PrinterCleanupTask' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\Printing' -TaskName 'PrintJobCleanupTask' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\PushToInstall' -TaskName 'LoginCheck' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\TextServicesFramework' -TaskName 'MsCtfMonitor' -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath '\Microsoft\Windows\RemoteAssistance' -TaskName 'RemoteAssistanceTask' -ErrorAction SilentlyContinue

# Disable Flighting Scheduled Task
Disable-ScheduledTask -TaskName "UsageDataFlushing" -TaskPath "\Microsoft\Windows\Flighting\FeatureConfig\"
Disable-ScheduledTask -TaskName "UsageDataReceiver" -TaskPath "\Microsoft\Windows\Flighting\FeatureConfig\"
Disable-ScheduledTask -TaskName "UsageDataReporting" -TaskPath "\Microsoft\Windows\Flighting\FeatureConfig\"

# Disable hanging "Synchronize Language Settings" Task
Disable-ScheduledTask -TaskName "Synchronize Language Settings" -TaskPath "\Microsoft\Windows\International\"

# Enable/Disable Windows Updates
Stop-Service -Name "BITS" -Force
Set-Service -Name "BITS" -StartupType Disabled
Stop-Service -Name "WaaSMedicSvc" -Force
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "UsoSvc" -Force
Set-Service -Name "UsoSvc" -StartupType Disabled
Stop-Service -Name "wuauserv" -Force
Set-Service -Name "wuauserv" -StartupType Disabled
#Stop-Service -Name "LicenseManager" -Force
#Set-Service -Name "LicenseManager" -StartupType Disabled
Stop-Service -Name "CryptSvc" -Force
Set-Service -Name "CryptSvc" -StartupType Disabled
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\CryptSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\CryptSvc_*" | Set-ItemProperty -Name Start -Value 4


# Stop Network Setup Service (Stays open after switching Networks/VPNs)
Stop-Service -Name "NetSetupSvc" -Force


# Broadcast DVR User Service
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\BcastDVRUserService_*" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "BcastDVRUserService_*" -Force

# Stop Clipboard User Service
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\cbdhsvc_*" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\cbdhsvc" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "cbdhsvc_*" -Force
Stop-Service -Name "cbdhsvc" -Force

# Stop DevicesFlowUserSvc
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\DevicesFlowUserSvc_*" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "DevicesFlowUserSvc" -Force
Stop-Service -Name "DevicesFlowUserSvc_*" -Force

# Stop Udk User Service
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\UdkUserSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\UdkUserSvc_*" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "UdkUserSvc" -Force
Stop-Service -Name "UdkUserSvc_*" -Force

# Contact Data
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\PimIndexMaintenanceSvc_*" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "PimIndexMaintenanceSvc" -Force
Stop-Service -Name "PimIndexMaintenanceSvc_*" -Force

# Stop Now Playing Service (affects task bar )
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\NPSMSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\NPSMSvc_*" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "NPSMSvc" -Force
Stop-Service -Name "NPSMSvc_*" -Force

# Stop Cloud Backup and Restore Service
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\CloudBackupRestoreSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\CloudBackupRestoreSvc_*" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "CloudBackupRestoreSvc" -Force
Stop-Service -Name "CloudBackupRestoreSvc_*" -Force

# Stop Network Connection Broker
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\NcbService" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "NcbService" -Force

# Stop Time Broker Service
# Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" | Set-ItemProperty -Name Start -Value 4
# Stop-Service -Name "TimeBrokerSvc" -Force

# Stop Remote Desktop Services (Winfuture Paranoia)
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SessionEnv" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\TermService" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\UmRdpService" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "SessionEnv" -Force
Stop-Service -Name "TermService" -Force
Stop-Service -Name "UmRdpService" -Force

# Stop Bluetooth User Service
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\BluetoothUserService" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\BluetoothUserService_*" | Set-ItemProperty -Name Start -Value 4
Stop-Service -Name "BluetoothUserService" -Force

# Stop Windows Update service
Stop-Service -Name "AxInstSV" -Force
Stop-Service -Name "AppVClient" -Force
Stop-Service -Name "AppXSvc" -Force
Stop-Service -Name "BDESVC" -Force
Stop-Service -Name "BTAGService" -Force
Stop-Service -Name "BthAvctpSvc" -Force
Stop-Service -Name "bthserv" -Force
Stop-Service -Name "ClipSVC" -Force
Stop-Service -Name "CscService" -Force
Stop-Service -Name "defragsvc" -Force
Stop-Service -Name "DeviceAssociationService" -Force
Stop-Service -Name "DeviceInstall" -Force
Stop-Service -Name "Dhcp" -Force
Stop-Service -Name "DiagTrack" -Force
Stop-Service -Name "DialogBlockingService"
Stop-Service -Name "DisplayEnhancementService" -Force
Stop-Service -Name "dmwappushservice" -Force
#Stop-Service -Name "DoSvc" -Force
Stop-Service -Name "dot3svc" -Force
Stop-Service -Name "DPS" -Force
Stop-Service -Name "DusmSvc" -Force
Stop-Service -Name "DsSvc" -Force
Stop-Service -Name "DsmSvc" -Force
Stop-Service -Name "FrameServer" -Force
Stop-Service -Name "hidserv" -Force
Stop-Service -Name "icssvc" -Force
Stop-Service -Name "IKEEXT" -Force
Stop-Service -Name "InstallService" -Force
Stop-Service -Name "iphlpsvc" -Force
Stop-Service -Name "LanmanServer" -Force
Stop-Service -Name "LanmanWorkstation" -Force
Stop-Service -Name "lfsvc" -Force
Stop-Service -Name "lmhosts" -Force
Stop-Service -Name "MapsBroker" -Force
Stop-Service -Name "midisrv" -Force
Stop-Service -Name "MSDTC" -Force
Stop-Service -Name "MsKeyboardFilter" -Force
Stop-Service -Name "NVDisplay.ContainerLocalSystem" -Force
Stop-Service -Name "PcaSvc" -Force
Stop-Service -Name "PolicyAgent" -Force
Stop-Service -Name "PrintDeviceConfigurationService" -Force
Stop-Service -Name "PushToInstall" -Force
Stop-Service -Name "RasAuto" -Force
Stop-Service -Name "RasMan" -Force
Stop-Service -Name "RemoteAccess" -Force
Stop-Service -Name "RemoteRegistry" -Force
Stop-Service -Name "RetailDemo" -Force
Stop-Service -Name "RmSvc" -Force
Stop-Service -Name "SCardSvr" -Force
Stop-Service -Name "ScDeviceEnum" -Force
Stop-Service -Name "SCPolicySvc" -Force
Stop-Service -Name "seclogon" -Force
Stop-Service -Name "SEMgrSvc" -Force
Stop-Service -Name "SensorDataService" -Force
Stop-Service -Name "SensorService" -Force
Stop-Service -Name "SensrSvc" -Force
Stop-Service -Name "ShellHWDetection" -Force
Stop-Service -Name "shpamsvc" -Force
Stop-Service -Name "smphost" -Force
Stop-Service -Name "Spooler" -Force
Stop-Service -Name "SSDPSRV" -Force
Stop-Service -Name "SstpSvc" -Force
Stop-Service -Name "StiSvc" -Force
Stop-Service -Name "StorSvc" -Force
Stop-Service -Name "TapiSrv" -Force
Stop-Service -Name "Themes" -Force
Stop-Service -Name "TokenBroker" -Force
Stop-Service -Name "TrkWks" -Force
Stop-Service -Name "TroubleshootingSvc" -Force
Stop-Service -Name "tzautoupdate" -Force
Stop-Service -Name "UevAgentService" -Force
Stop-Service -Name "wcncsvc" -Force
Stop-Service -Name "WebClient" -Force
Stop-Service -Name "WerSvc" -Force
Stop-Service -Name "wlidsvc" -Force
Stop-Service -Name "WinRM" -Force
Stop-Service -Name "wisvc" -Force
Stop-Service -Name "WPDBusEnum" -Force
Stop-Service -Name "WpnService" -Force
Stop-Service -Name "WpnUserService_*" -Force
Stop-Service -Name "WSearch" -Force
Stop-Service -Name "WSAIFabricSvc" -Force
Stop-Service -Name "FrameServerMonitor" -Force
Stop-Service -Name "FDResPub" -Force
Stop-Service -Name "VSS" -Force
Stop-Service -Name "swprv" -Force
Stop-Service -Name "TrustedInstaller" -Force
Stop-Service -Name "LxpSvc" -Force
Stop-Service -Name "DPS" -Force
Stop-Service -Name "WdiServiceHost" -Force
Stop-Service -Name "WdiSystemHost" -Force
Stop-Service -Name "whesvc" -Force
Stop-Service -Name "Browser" -Force
Stop-Service -Name "ZTHELPER" -Force
#Stop-Service -Name "NetSetupSvc" -Force
Stop-Service -Name "XblAuthManager" -Force
Stop-Service -Name "XboxNetApiSvc" -Force
Stop-Service -Name "WlanSvc" -Force
Stop-Service -Name "MicrosoftEdgeElevationService" -Force
Stop-Service -Name "PrintScanBrokerService" -Force
Stop-Service -Name "PrintNotify" -Force
Stop-Service -Name "Steam Client Service" -Force
Stop-Service -Name "upnphost" -Force
Stop-Service -Name "Netlogon" -Force
Stop-Service -Name "DevQueryBroker" -Force
Stop-Service -Name "AppReadiness" -Force
#Stop-Service -Name "sppsvc" -Force
Stop-Service -Name "NgcSvc" -Force
Stop-Service -Name "XblGameSave" -Force
Stop-Service -Name "XboxGipSvc" -Force
Stop-Service -Name "PhoneSvc" -Force
Stop-Service -Name "WFDSConMgrSvc" -Force
Stop-Service -Name "McmSvc" -Force
Stop-Service -Name "GraphicsPerfSvc" -Force
Stop-Service -Name "RpcLocator" -Force
Stop-Service -Name "fhsvc" -Force
Stop-Service -Name "dcsvc" -Force

# Disable blocked (uneditable) Windows services
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\AppXSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\ClipSVC" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\DoSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\CaptureService" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\CaptureService_*" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\WpnUserService" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\WpnUserService_*" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" | Set-ItemProperty -Name Start -Value 4
Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\NgcSvc" | Set-ItemProperty -Name Start -Value 4
#Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\sppsvc" | Set-ItemProperty -Name Start -Value 4


# Set Update Services to Manual
#Set-Service -Name "UsoSvc" -StartupType Manual
#Set-Service -Name "IKEEXT" -StartupType Manual
#Set-Service -Name "WPDBusEnum" -StartupType Manual
Set-Service -Name "LanmanWorkstation" -StartupType Disabled

# Disable Windows Update Orchestrator service
Set-Service -Name "XblGameSave" -StartupType Disabled
Set-Service -Name "AxInstSV" -StartupType Disabled
Set-Service -Name "AppVClient" -StartupType Disabled
Set-Service -Name "BDESVC" -StartupType Disabled
Set-Service -Name "BTAGService" -StartupType Disabled
Set-Service -Name "BthAvctpSvc" -StartupType Disabled
Set-Service -Name "bthserv" -StartupType Disabled
Set-Service -Name "CDPSvc" -StartupType Disabled
Set-Service -Name "CscService" -StartupType Disabled
Set-Service -Name "defragsvc" -StartupType Disabled
Set-Service -Name "DeviceAssociationService" -StartupType Disabled
Set-Service -Name "DeviceInstall" -StartupType Disabled
Set-Service -Name "Dhcp" -StartupType Disabled
Set-Service -Name "DiagTrack" -StartupType Disabled
Set-Service -Name "DialogBlockingService" -StartupType Disabled
Set-Service -Name "DisplayEnhancementService" -StartupType Disabled
Set-Service -Name "dmwappushservice" -StartupType Disabled
Set-Service -Name "dot3svc" -StartupType Disabled
Set-Service -Name "DPS" -StartupType Disabled
Set-Service -Name "DusmSvc" -StartupType Disabled
Set-Service -Name "DsSvc" -StartupType Disabled
Set-Service -Name "DsmSvc" -StartupType Disabled
Set-Service -Name "FrameServer" -StartupType Disabled
Set-Service -Name "hidserv" -StartupType Disabled
Set-Service -Name "icssvc" -StartupType Disabled
Set-Service -Name "InstallService" -StartupType Disabled
Set-Service -Name "iphlpsvc" -StartupType Disabled
Set-Service -Name "InventorySvc" -StartupType Disabled
Set-Service -Name "LanmanServer" -StartupType Disabled
Set-Service -Name "lfsvc" -StartupType Disabled
Set-Service -Name "lmhosts" -StartupType Disabled
Set-Service -Name "MapsBroker" -StartupType Disabled
Set-Service -Name "midisrv" -StartupType Disabled
Set-Service -Name "MSDTC" -StartupType Disabled
Set-Service -Name "MsKeyboardFilter" -StartupType Disabled
Set-Service -Name "NVDisplay.ContainerLocalSystem" -StartupType Disabled
Set-Service -Name "PcaSvc" -StartupType Disabled
Set-Service -Name "PolicyAgent" -StartupType Disabled
Set-Service -Name "PrintDeviceConfigurationService" -StartupType Disabled
Set-Service -Name "PushToInstall" -StartupType Disabled
Set-Service -Name "RasAuto" -StartupType Disabled
Set-Service -Name "RasMan" -StartupType Disabled
Set-Service -Name "RemoteAccess" -StartupType Disabled
Set-Service -Name "RemoteRegistry" -StartupType Disabled
Set-Service -Name "RetailDemo" -StartupType Disabled
Set-Service -Name "RmSvc" -StartupType Disabled
Set-Service -Name "SCardSvr" -StartupType Disabled
Set-Service -Name "ScDeviceEnum" -StartupType Disabled
Set-Service -Name "SCPolicySvc" -StartupType Disabled
Set-Service -Name "seclogon" -StartupType Disabled
Set-Service -Name "SEMgrSvc" -StartupType Disabled
Set-Service -Name "SensorDataService" -StartupType Disabled
Set-Service -Name "SensorService" -StartupType Disabled
Set-Service -Name "SensrSvc" -StartupType Disabled
Set-Service -Name "ShellHWDetection" -StartupType Disabled
Set-Service -Name "shpamsvc" -StartupType Disabled
Set-Service -Name "smphost" -StartupType Disabled
Set-Service -Name "Spooler" -StartupType Disabled
Set-Service -Name "SSDPSRV" -StartupType Disabled
Set-Service -Name "SstpSvc" -StartupType Disabled
Set-Service -Name "StiSvc" -StartupType Disabled
Set-Service -Name "StorSvc" -StartupType Disabled
Set-Service -Name "TapiSrv" -StartupType Disabled
Set-Service -Name "Themes" -StartupType Disabled
Set-Service -Name "TokenBroker" -StartupType Disabled
Set-Service -Name "TrkWks" -StartupType Disabled
Set-Service -Name "TroubleshootingSvc" -StartupType Disabled
Set-Service -Name "tzautoupdate" -StartupType Disabled
Set-Service -Name "UevAgentService" -StartupType Disabled
Set-Service -Name "wcncsvc" -StartupType Disabled
Set-Service -Name "WebClient" -StartupType Disabled
Set-Service -Name "WerSvc" -StartupType Disabled
Set-Service -Name "wlidsvc" -StartupType Disabled
Set-Service -Name "WinRM" -StartupType Disabled
Set-Service -Name "wisvc" -StartupType Disabled
Set-Service -Name "WPDBusEnum" -StartupType Disabled
Set-Service -Name "WpnService" -StartupType Disabled
Set-Service -Name "WSearch" -StartupType Disabled
Set-Service -Name "WSAIFabricSvc" -StartupType Disabled
Set-Service -Name "FrameServerMonitor" -StartupType Disabled
Set-Service -Name "FDResPub" -StartupType Disabled
Set-Service -Name "VSS" -StartupType Disabled
Set-Service -Name "swprv" -StartupType Disabled
Set-Service -Name "TrustedInstaller" -StartupType Disabled
Set-Service -Name "LxpSvc" -StartupType Disabled
Set-Service -Name "DPS" -StartupType Disabled
Set-Service -Name "WdiServiceHost" -StartupType Disabled
Set-Service -Name "WdiSystemHost" -StartupType Disabled
Set-Service -Name "whesvc" -StartupType Disabled
Set-Service -Name "TrustedInstaller" -StartupType Disabled
Set-Service -Name "Browser" -StartupType Disabled
Set-Service -Name "ZTHELPER" -StartupType Disabled
#Set-Service -Name "NetSetupSvc" -StartupType Disabled
Set-Service -Name "XblAuthManager" -StartupType Disabled
Set-Service -Name "XboxNetApiSvc" -StartupType Disabled
Set-Service -Name "WlanSvc" -StartupType Disabled
Set-Service -Name "MicrosoftEdgeElevationService" -StartupType Disabled
Set-Service -Name "PrintScanBrokerService" -StartupType Disabled
Set-Service -Name "PrintNotify" -StartupType Disabled
Set-Service -Name "Steam Client Service" -StartupType Disabled
Set-Service -Name "upnphost" -StartupType Disabled
Set-Service -Name "Netlogon" -StartupType Disabled
Set-Service -Name "DevQueryBroker" -StartupType Disabled
Set-Service -Name "AppReadiness" -StartupType Disabled
Set-Service -Name "XboxGipSvc" -StartupType Disabled
Set-Service -Name "PhoneSvc" -StartupType Disabled
Set-Service -Name "WFDSConMgrSvc" -StartupType Disabled
Set-Service -Name "McmSvc" -StartupType Disabled
Set-Service -Name "GraphicsPerfSvc" -StartupType Disabled
Set-Service -Name "RpcLocator" -StartupType Disabled
Set-Service -Name "fhsvc" -StartupType Disabled
Set-Service -Name "dcsvc" -StartupType Disabled

Write-Host 'Windows services have been disabled.'

taskkill /F /IM CrossDeviceResume.exe
taskkill /F /IM ShellExperienceHost.exe
taskkill /F /IM DataExchangeHost.exe
taskkill /F /IM mobsync.exe
taskkill /F /IM RuntimeBroker.exe
taskkill /F /IM DllHost.exe
taskkill /F /IM taskhostw.exe
taskkill /F /IM conhost.exe
taskkill /F /IM wlrmdr.exe
taskkill /F /IM SystemSettings.exe

# CrossDeviceResume.exe
$File = 'C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\CrossDeviceResume.exe'
if (Test-Path -Path $File) {
	taskkill /F /IM CrossDeviceResume.exe
	takeown /F $File
	icacls $File /T /C /grant administrators:F System:F everyone:F
	move $File "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\CrossDeviceResume.exe.bak"
	Write-Host 'CrossDeviceResume.exe has been renamed/disabled.'
}


# ShellExperienceHost.exe (right click taskbar is fucked without it)
$File = 'C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe'
if (Test-Path -Path $File) {
	taskkill /F /IM ShellExperienceHost.exe
	takeown /F $File
	icacls $File /T /C /grant administrators:F System:F everyone:F
	move "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe" "C:\Windows\SystemApps\ShellExperienceHost_cw5n1h2txyewy\ShellExperienceHost.exe.bak"
	Write-Host 'ShellExperienceHost.exe has been renamed/disabled.'
}

# DataExchangeHost
$File = "C:\Windows\System32\DataExchangeHost.exe"
if (Test-Path -Path $File) {
	taskkill /F /IM DataExchangeHost.exe
	takeown /F "C:\Windows\System32\DataExchangeHost.exe"
	icacls "C:\Windows\System32\DataExchangeHost.exe" /T /C /grant administrators:F System:F everyone:F
	move "C:\Windows\System32\DataExchangeHost.exe" "C:\Windows\System32\DataExchangeHost.exe.bak"
	Write-Host 'DataExchangeHost.exe has been renamed/disabled.'
}

# SearchIndexer
$File = "C:\Windows\System32\SearchIndexer.exe"
$FileBck = "C:\Windows\System32\SearchIndexer.exe.bak"
if (Test-Path -Path $FileBck) {
	del "C:\Windows\System32\SearchIndexer.exe.bak"
}
if (Test-Path -Path $File) {
	taskkill /F /IM SearchIndexer.exe
	takeown /F "C:\Windows\System32\SearchIndexer.exe"
	icacls "C:\Windows\System32\SearchIndexer.exe" /T /C /grant administrators:F System:F everyone:F
	move "C:\Windows\System32\SearchIndexer.exe" "C:\Windows\System32\SearchIndexer.exe.bak"
	Write-Host 'SearchIndexer.exe has been renamed/disabled.'
}

# mobsync
$File = "C:\Windows\System32\mobsync.exe"
if (Test-Path -Path $File) {
	taskkill /F /IM mobsync.exe
	takeown /F $File
	icacls $File /T /C /grant administrators:F System:F everyone:F
	move $File "C:\Windows\System32\mobsync.exe.bak"
	Write-Host 'mobsync.exe has been renamed/disabled.'
}

# SearchHost
$File = 'C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe'
if (Test-Path -Path $File) {
	taskkill /F /IM SearchHost.exe
	takeown /F "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe"
	icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" /T /C /grant administrators:F System:F everyone:F
	move "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe" "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe.bak"
	Write-Host 'SearchHost.exe has been renamed/disabled.'
}

# TextInputHost
$File = 'C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe'
if (Test-Path -Path $File) {
	taskkill /F /IM TextInputHost.exe
	takeown /F "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe"
	icacls "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe" /T /C /grant administrators:F System:F everyone:F
	move "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe" "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe.bak"
	Write-Host 'TextInputHost.exe has been renamed/disabled.'
}3

# Set some default files as hidden
attrib +h C:\inetpub
attrib +h C:\PerfLogs
if (Test-Path -Path "C:\Windows.old") { attrib +h C:\Windows.old }
attrib +h C:\DumpStack.log


# Disable WMI (needed for managing scheduled tasks, careful controller)
Write-Host 'Disable WMI .. (needed for managing scheduled tasks)'
taskkill /F /IM WmiPrvSE.exe
Set-Service -Name "Winmgmt" -StartupType Disabled
Stop-Service -Name "Winmgmt"



#Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser -Force
#Write-Host 'ExecutionPolicy set back to Restricted.'
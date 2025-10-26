# Disable-Windows-Services
Script to disable unused Windows Services to increase performance, especially for Gamers.

For years I was annoyed by all the numerous Windows Services that kept on popping up in the background which could cause Ping and FPS drops every couple minutes. Especially for professional gamers and mobile internet users (3G/4G or slower) this can be quite devastating.

There are various Windows Blockers like W10Privacy or O&O ShutUp which disable a lot of telemetry, background apps and tasks, but none of them are handling all the services by itself.

> [!CAUTION]
> No Revert Script is included. If any Windows functionality is broken after using the script, you have to re-enable the associated Services manually via services.msc.


Please note that some specific functions won't be working anymore:
- Bluetooth
- WiFi
- (WSL)

----

- Remove unnneded devices (i.e. Monitor)
- Disable Memory Compression
- Disable Windows Update scheduled tasks
- Disable Flighting Scheduled Task
- Disable hanging "Synchronize Language Settings" Task
- Enable/Disable Windows Updates
- Kills open processes: CrossDeviceResume.exe, ShellExperienceHost.exe, DataExchangeHost.exe, mobsync.exe, RuntimeBroker.exe, DllHost.exe, taskhostw.exe, conhost.exe, wlrmdr.exe, SystemSettings.exe

Cosmetics:
- Explorer: Remove "Home" & "Gallery" from Quick Pane
- Explorer: Remove duplicate drives in Explorer Quick Pane
- Windows Fiels: Set some default folders as hidden (C:\inetpub, C:\PerfLogs, C:\Windows.old, C:\DumpStack.log)

Currently the script is setting **4 Windows Services to Manual**:
Winmgmt | Windows Management Instrumentation | Occasionally used for some apps that fetch sensor data like CPU-Z and for installing *.wmi package files.
UsoSvc | Update Service Orchester | Used for Windows Updates. Can be disabled when your Windows Updates are disabled anyway.
CDPSvc | Connected Devices Platform Service 
InventorySvc | 


Currently the script **disables 70 Windows Services**:
AppVClient
BDESVC
BITS
BTAGService
BthAvctpSvc
bthserv
CscService
defragsvc | Used for defragmenting storage drives. Only useful if you still use old HDD drives.
DeviceInstall | Important for installing/setting up new devices on your system. Can be disabled if all devices are installed.
DiagTrack
DialogBlockingService
DisplayEnhancementService
dmwappushservice
dot3svc
DPS
DusmSvc
DsSvc
DsmSvc
hidserv
icssvc
InstallService
LanmanServer
LanmanWorkstation
lfsvc
lmhosts
LogiFacecamService
midisrv
MsKeyboardFilter
NVDisplay.ContainerLocalSystem
PcaSvc
perceptionsimulation
PimIndexMaintenanceSvc_3eaae
PushToInstall
RasAuto
RasMan
RemoteAccess
RemoteRegistry
RetailDemo
RmSvc
SCardSvr
ScDeviceEnum
SCPolicySvc
seclogon
SEMgrSvc
SensorDataService
SensorService
SensrSvc
SgrmBroker
ShellHWDetection
shpamsvc
smphost
Spooler
SSDPSRV
SstpSvc
StiSvc
StorSvc
Themes
TokenBroker
TrkWks
TroubleshootingSvc | Windows Troubleshooting. This process gets triggered by numerous apps and pops up secretly in the background. It's only used if you use the Troubleshooter in Windows Settings to debug a problem.
tzautoupdate
UevAgentService
UnistoreSvc_3eaae
UserDataSvc_3eaae
WaaSMedicSvc
wcncsvc
WerSvc
WinRM
wisvc
wildsvc
WSearch | Windows Search used for indexing files. Indexing can pop up in the background and. 

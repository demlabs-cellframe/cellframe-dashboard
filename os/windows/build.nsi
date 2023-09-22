; ***************************************************************
; * Authors:
; * Konstantin Papizh <papizh.konstantin@demlabs.net>
; * DeM Labs Inc.   https://demlabs.net
; * Cellframe Project https://gitlab.demlabs.net/cellframe
; * Copyright  (c) 2020
; * All rights reserved.
; ***************************************************************

!define MULTIUSER_EXECUTIONLEVEL Admin
;!include "MultiUser.nsh"
!include "MUI2.nsh"
!include "x64.nsh"
Unicode true
!include "nsis.defines.nsh"
!include "modifyConfig.nsh"						   

!define MUI_ICON		"icon_win32.ico"
!define MUI_UNICON		"icon_win32.ico"

!define NODE_NAME		"cellframe-node"
!define EXE_NAME		"${APP_NAME}.exe"
!define PUBLISHER		"Cellframe Network"

!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

!define MUI_COMPONENTSPAGE_TEXT_TOP ""

Name 	"${APP_NAME}"
OutFile	"${APP_NAME} ${APP_VER} installer.exe"
BrandingText "${APP_NAME} by ${PUBLISHER}"

!define MUI_FINISHPAGE_NOAUTOCLOSE

Var CommonDocuments
Var ConfigPath

VIAddVersionKey "ProductName"		"${APP_NAME}"
VIAddVersionKey "CompanyName"		"${PUBLISHER}"
VIAddVersionKey "LegalCopyright"	"${PUBLISHER} 2022"
VIAddVersionKey "FileDescription"	"Cellframe Dashboard Application"
VIAddVersionKey "FileVersion"		"${APP_VER}"
VIAddVersionKey "ProductVersion"	"${APP_VER}"
VIProductVersion "${APP_VERSION}"

Function .onInit
	${If} ${RunningX64}
		${EnableX64FSRedirection}
		SetRegView 64
	${else}
        MessageBox MB_OK "${APP_NAME} supports x64 architectures only"
        Abort
    ${EndIf}
	ReadRegStr $CommonDocuments HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "Common Documents"
	StrCpy $ConfigPath "$CommonDocuments\${NODE_NAME}"
FunctionEnd

Function UninstPrev
	ReadRegStr $R0 HKLM "${UNINSTALL_PATH}" "UninstallString"
	${If} $R0 == ""
	Goto Fin
	${EndIf}
	DetailPrint "Uninstall older version" 
	ExecWait '"$R0" /S'
	Fin:
FunctionEnd

Function EnableMSMQ
	Push $R0
	Push $R1
	ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
	${DisableX64FSRedirection}
	StrCpy $R1 $R0 3
	DetailPrint "WinNT version: $R1"
	StrCmp $R1 '6.0' +1 0
	StrCmp $R1 '6.1' 0 +1
	nsExec::ExecToLog /OEM  'dism /online /enable-feature /featurename:MSMQ-Container /featurename:MSMQ-Server /featurename:MSMQ-Multicast /NoRestart'
	Goto +2
	nsExec::ExecToLog /OEM  'dism /online /enable-feature /featurename:MSMQ-Server /All /NoRestart'
	Pop $R1
	Pop $R0
FunctionEnd

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES  

!insertmacro MUI_LANGUAGE 	"English"
!insertmacro MUI_LANGUAGE 	"Russian"

LangString MsgBoxText ${LANG_ENGLISH} "Update network configurations?"
LangString MsgBoxText ${LANG_RUSSIAN} "Update network configurations?"

!macro varPaths
	IfFileExists "$ConfigPath\var\log" yesLog 0
	CreateDirectory "$ConfigPath\var\log"
yesLog:
	IfFileExists "$ConfigPath\var\lib\global_db" yesDb 0
	CreateDirectory "$ConfigPath\var\lib\global_db"
yesDb:
	IfFileExists "$ConfigPath\var\lib\wallet" yesWallet 0
	CreateDirectory "$ConfigPath\var\lib\wallet"	
yesWallet:
	IfFileExists "$ConfigPath\var\lib\ca" yesCa 0
	CreateDirectory "$ConfigPath\var\lib\ca"
yesCa:
	IfFileExists "$ConfigPath\log" yesDashLog 0
	CreateDirectory "$CommonDocuments\${APP_NAME}\log"
yesDashLog:
	IfFileExists "$ConfigPath\data" yesDashData 0
	CreateDirectory "$CommonDocuments\${APP_NAME}\data"
yesDashData:
	IfFileExists "$ConfigPath\etc\network" 0 end
	MessageBox MB_YESNO $(MsgBoxText) IDYES true IDNO false
true:
	RMDir /r "$ConfigPath\etc\network"
	Delete "$ConfigPath\etc\${NODE_NAME}.cfg"
    RMDir /r "$ConfigPath\var\lib\global_db"
    RMDir /r "$ConfigPath\var\lib\network"
false:	
    RMDir /r "$ConfigPath\var\lib\global_db"
    RMDir /r "$ConfigPath\var\lib\network"
end:
!macroend

!macro killAll
	nsExec::ExecToLog /OEM  'taskkill /f /im ${EXE_NAME}'
	nsExec::ExecToLog /OEM  'taskkill /f /im ${APP_NAME}Service.exe' ;Legacy
	nsExec::ExecToLog /OEM  'taskkill /f /im ${NODE_NAME}.exe'
	${DisableX64FSRedirection}
	nsExec::ExecToLog /OEM  'schtasks /Delete /TN "${APP_NAME}Service" /F' ;Legacy
	nsExec::ExecToLog /OEM  'schtasks /Delete /TN "${NODE_NAME}" /F'	
    ${EnableX64FSRedirection}
	nsExec::ExecToLog /OEM 'sc stop ${APP_NAME}Service'
!macroend

InstallDir "$PROGRAMFILES64\${APP_NAME}"

!define PRODUCT_NAME "${APP_NAME}"
!define PRODUCT_VERSION "${APP_VER}"
!define PRODUCT_FULLNAME "${APP_NAME} ${APP_VER}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_FULLNAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_UNINSTALL_EXE "uninstall.exe"

Section -UninstallPrevious
    Call UninstPrev
SectionEnd

Section "${APP_NAME}" CORE
	SectionIn RO
	SetOutPath "$INSTDIR"
!insertmacro killAll
	File "opt/cellframe-dashboard/bin/${APP_NAME}.exe"
	File "opt/cellframe-dashboard/bin/${APP_NAME}Service.exe"
	File "opt/cellframe-node/bin/${NODE_NAME}.exe"
	File "opt/cellframe-node/bin/${NODE_NAME}-cli.exe"
	File "opt/cellframe-node/bin/${NODE_NAME}-tool.exe"
!insertmacro varPaths
	InitPluginsDir
	SetOutPath "$PLUGINSDIR"

	SetOutPath "$ConfigPath\etc"
	File /r "opt/cellframe-node/etc/"

	SetOutPath "$ConfigPath\share"
	File /r "opt/cellframe-node/share/*"
	
	CopyFiles "$ConfigPath\share\configs\${NODE_NAME}.cfg.tpl" "$ConfigPath\etc\${NODE_NAME}.cfg"
	StrCpy $net1 "Backbone"
	;StrCpy $net2 "raiden"
	StrCpy $net3 "riemann"
	StrCpy $net4 "KelVPN"
	
	CopyFiles "$ConfigPath\share\configs\network\$net1.cfg.tpl" "$ConfigPath\etc\network\$net1.cfg"
	;CopyFiles "$ConfigPath\share\configs\network\$net2.cfg.tpl" "$ConfigPath\etc\network\$net2.cfg"
	CopyFiles "$ConfigPath\share\configs\network\$net3.cfg.tpl" "$ConfigPath\etc\network\$net3.cfg"
	CopyFiles "$ConfigPath\share\configs\network\$net4.cfg.tpl" "$ConfigPath\etc\network\$net4.cfg"
	
!insertmacro modifyConfigFiles
	WriteRegStr HKLM "${UNINSTALL_PATH}" "DisplayName" "${APP_NAME} ${APP_VER}"
	WriteRegStr HKLM "${UNINSTALL_PATH}" "UninstallString" "$INSTDIR\Uninstall.exe"
	WriteRegStr HKLM "${UNINSTALL_PATH}" "DisplayVersion" "${APP_VERSION}"
	WriteRegStr HKLM "${UNINSTALL_PATH}" "Publisher" "${PUBLISHER}"
	WriteRegStr HKLM "${UNINSTALL_PATH}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"
	
	WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\${NODE_NAME}.exe" 		"RUNASADMIN"
	;WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\${APP_NAME}Service.exe" "RUNASADMIN"
	WriteUninstaller "$INSTDIR\Uninstall.exe"
	CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
	StrCpy $0 "'$INSTDIR\${NODE_NAME}.exe'"
	${DisableX64FSRedirection}
	nsExec::ExecToLog /OEM  'schtasks /Create /F /RL highest /SC onlogon /TR "$0" /TN "${NODE_NAME}"'
	${EnableX64FSRedirection}
	;nsExec::ExecToLog /OEM  'schtasks /Create /F /RL highest /SC onlogon /TR "$INSTDIR\${APP_NAME}Service.exe" /TN "${APP_NAME}Service"'
	;CreateShortCut "$DESKTOP\${APP_NAME}Service.lnk" "$INSTDIR\${APP_NAME}Service.exe"
SectionEnd

Section -startNode
	#Call EnableMSMQ
	Exec '"$INSTDIR\${NODE_NAME}.exe"'
	;Exec '"$INSTDIR\${APP_NAME}Service.exe"'
	nsExec::ExecToLog /OEM '"$INSTDIR\${APP_NAME}Service.exe" install'
	nsExec::ExecToLog /OEM 'sc start ${APP_NAME}Service'
SectionEnd

Section "Uninstall"
	SetRegView 64
	!insertmacro killAll
	nsExec::ExecToLog /OEM 'sc delete ${APP_NAME}Service'
	Delete "$INSTDIR\${APP_NAME}.exe"
	Delete "$INSTDIR\${APP_NAME}Service.exe"
	Delete "$INSTDIR\${NODE_NAME}.exe"
	Delete "$INSTDIR\${NODE_NAME}-tool.exe"
	Delete "$INSTDIR\${NODE_NAME}-cli.exe"
	DeleteRegKey HKLM "${UNINSTALL_PATH}"
	DeleteRegKey HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\$INSTDIR\${NODE_NAME}.exe"
	DeleteRegKey HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\$INSTDIR\${APP_NAME}Service.exe"
	Delete "$INSTDIR\Uninstall.exe"
	Delete "$DESKTOP\${APP_NAME}.lnk"
	;Delete "$DESKTOP\${APP_NAME}Service.lnk"
	;RMDir "$INSTDIR"
SectionEnd

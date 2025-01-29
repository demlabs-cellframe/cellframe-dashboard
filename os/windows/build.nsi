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
    CreateDirectory "$CommonDocuments\${APP_NAME}\data"
    CreateDirectory "$CommonDocuments\${APP_NAME}\data\wallet"
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

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES  

!insertmacro MUI_LANGUAGE 	"English"
!insertmacro MUI_LANGUAGE 	"Russian"

!macro killAll
	nsExec::ExecToLog /OEM  'taskkill /f /im ${EXE_NAME}'
	nsExec::ExecToLog /OEM  'taskkill /f /im ${APP_NAME}Service.exe' ;Legacy
	${DisableX64FSRedirection}
	nsExec::ExecToLog /OEM  'schtasks /Delete /TN "${APP_NAME}Service" /F' ;Legacy
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
;	File "opt/cellframe-dashboard/bin/${APP_NAME}Service.exe"

	InitPluginsDir
	SetOutPath "$PLUGINSDIR"
	
	WriteRegStr HKLM "${UNINSTALL_PATH}" "DisplayName" "${APP_NAME} ${APP_VER}"
	WriteRegStr HKLM "${UNINSTALL_PATH}" "UninstallString" "$INSTDIR\Uninstall.exe"
	WriteRegStr HKLM "${UNINSTALL_PATH}" "DisplayVersion" "${APP_VERSION}"
	WriteRegStr HKLM "${UNINSTALL_PATH}" "Publisher" "${PUBLISHER}"
	WriteRegStr HKLM "${UNINSTALL_PATH}" "DisplayIcon" "$INSTDIR\${EXE_NAME}"	
	WriteUninstaller "$INSTDIR\Uninstall.exe"
	CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${EXE_NAME}"
SectionEnd

;Section -startNode
;	nsExec::ExecToLog /OEM '"$INSTDIR\${APP_NAME}Service.exe" install'
;	nsExec::ExecToLog /OEM 'sc start ${APP_NAME}Service'
;SectionEnd

Section "Uninstall"
	SetRegView 64
	!insertmacro killAll
;	nsExec::ExecToLog /OEM 'sc delete ${APP_NAME}Service'
	Delete "$INSTDIR\${APP_NAME}.exe"
;	Delete "$INSTDIR\${APP_NAME}Service.exe"
	DeleteRegKey HKLM "${UNINSTALL_PATH}"
;	DeleteRegKey HKCU "Software\Microsofhttps://github.com/google/cpu_features/tree/main/srct\Windows NT\CurrentVersion\AppCompatFlags\Layers\$INSTDIR\${APP_NAME}Service.exe"
	Delete "$INSTDIR\Uninstall.exe"
	Delete "$DESKTOP\${APP_NAME}.lnk"
SectionEnd

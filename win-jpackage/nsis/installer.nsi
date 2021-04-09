UniCode true

SetCompressor lzma

!include "version.nsi"

!define MUI_ICON MuWire\MuWire.ico
!define MUI_FINISHPAGE
!include "MUI2.nsh"

Name "MuWire ${MUWIRE_VERSION}"
OutFile MuWire-${MUWIRE_VERSION}.exe
Icon MuWire\MuWire.ico
RequestExecutionLevel admin
InstallDir "$PROGRAMFILES\MuWire"

LangString MUI_TEXT_WELCOME_INFO_TITLE ${LANG_ENGLISH} "Welcome to MuWire"
LangString MUI_TEXT_WELCOME_INFO_TEXT ${LANG_ENGLISH} "Press Next to install MuWire on your computer"

!insertmacro MUI_PAGE_WELCOME

PageEx license
    licensetext "GPLv3"
    licensedata "GPLv3.txt"
PageExEnd
Page directory
Page instfiles

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Start MuWire now"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_FINISH


Function LaunchLink
    ExecShell "" "$DESKTOP\MuWire.lnk"
FunctionEnd

Section install
	CreateDirectory $INSTDIR
	SetOutPath $INSTDIR
	
	File GPLv3.txt
	
	File /r MuWire\*.*
	
	SetShellVarContext all
	
    CreateDirectory "$SMPROGRAMS\MuWire"
    CreateShortCut "$SMPROGRAMS\MuWire\MuWire.lnk" "$INSTDIR\MuWire.exe" "" "$INSTDIR\MuWire.ico"
    CreateShortCut "$DESKTOP\MuWire.lnk" "$INSTDIR\MuWire.exe" "" "$INSTDIR\MuWire.ico"

    WriteUninstaller "$INSTDIR\uninstall-muwire.exe"
SectionEnd

Section "uninstall"
    Delete "$INSTDIR\GPLv3-ud.txt"
    Delete "$INSTDIR\MuWire.ico"
    Delete "$INSTDIR\uninstall-muwire.exe"

    Delete "$DESKTOP\MuWire.lnk"
    RmDir /r "$SMPROGRAMS\MuWire"

    RmDir /r "$INSTDIR"
SectionEnd
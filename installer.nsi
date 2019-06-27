# Uncomment on v3
# UniCode true

# uncomment when building production - takes forever
#SetCompressor lzma

!include "version.nsi"

!define MUI_ICON toopie.ico
!define MUI_FINISHPAGE
!include "MUI2.nsh"

Name "MuWire ${MUWIRE_VERSION}"
OutFile MuWire-${MUWIRE_VERSION}.exe
Icon toopie.ico
RequestExecutionLevel admin
InstallDir "$PROGRAMFILES\MuWire"

PageEx license
    licensetext "GPLv3"
    licensedata "GPLv3-ud.txt"
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

Section Install
    CreateDirectory $INSTDIR
    SetOutPath $INSTDIR

    File GPLv3-ud.txt
    File toopie.ico

    File /r pkg\*.*

    CreateDirectory "$INSTDIR\jre"
    SetOutPath "$INSTDIR\jre"
    File /r jre\*.*

    SetShellVarContext current

    CreateDirectory "$SMPROGRAMS\MuWire"
    CreateShortCut "$SMPROGRAMS\MuWire\MuWire.lnk" "c:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\muwire.bat$\"" "$INSTDIR\toopie.ico"
    CreateShortCut "$DESKTOP\MuWire.lnk" "c:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\muwire.bat$\"" "$INSTDIR\toopie.ico"

    WriteUninstaller "$INSTDIR\uninstall-muwire.exe"
SectionEnd

Section "uninstall"
    Delete "$INSTDIR\GPLv3-ud.txt"
    Delete "$INSTDIR\toopie.ico"
    Delete "$INSTDIR\uninstall-muwire.exe"

    Delete "$DESKTOP\MuWire.lnk"
    RmDir /r "$SMPROGRAMS\MuWire"

    RmDir /r "$INSTDIR\jre"
    RmDir /r "$INSTDIR"
SectionEnd



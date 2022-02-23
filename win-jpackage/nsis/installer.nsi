UniCode true

SetCompressor lzma
!include "version.nsi"
Name "MuWire ${MUWIRE_VERSION}"
OutFile MuWire-${MUWIRE_VERSION}.exe

RequestExecutionLevel admin
InstallDir "$PROGRAMFILES\MuWire"

!include LogicLib.nsh
!include FindProcess.nsh
!include MUI2.nsh

; MUI Settings

!define MUI_ICON "MuWire\MuWire.ico"
!define MUI_UNICON "MuWire\MuWire.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "muwire.bmp"
!define MUI_HEADERIMAGE_BITMAP_STRETCH "FitControl"

!define MUI_HEADERIMAGE_UNBITMAP "muwire.bmp"
!define MUI_HEADERIMAGE_UNBITMAP_STRETCH "FitControl"

!define MUI_WELCOMEFINISHPAGE_BITMAP "mu.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP_STRETCH  "FitControl"

!define MUI_UNWELCOMEFINISHPAGE_BITMAP "mu.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP_STRETCH "FitControl"

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Start MuWire now"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"

!define MUI_WELCOMEPAGE_TEXT "Press Next to install MuWire on your computer."

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE GPLv3.txt

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Function LaunchLink
    ShellExecAsUser::ShellExecAsUser "" "$DESKTOP\MuWire.lnk"
FunctionEnd

Function .onInit
    IfSilent 0 end

    Banner::show "Upgrading MuWire..."
    
    ${Do}
        ${FindProcess} "MuWire.exe" $0
        Sleep 500
    ${LoopWhile} $0 <> 0

    end:
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

	IfSilent 0 end
    Banner::destroy
	ShellExecAsUser::ShellExecAsUser "" "$DESKTOP\MuWire.lnk"
	end:
SectionEnd

Section "uninstall"
    Delete "$INSTDIR\GPLv3-ud.txt"
    Delete "$INSTDIR\MuWire.ico"
    Delete "$INSTDIR\uninstall-muwire.exe"

    Delete "$DESKTOP\MuWire.lnk"
    RmDir /r "$SMPROGRAMS\MuWire"

    RmDir /r "$INSTDIR"
SectionEnd

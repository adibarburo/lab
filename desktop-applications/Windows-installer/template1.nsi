RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)
!define APP_NAME "application name"
!define COMP_NAME "company name"
!define WEB_SITE "www.website.com"
!define VERSION "0.0.0.0"
!define COPYRIGHT "Developer  © 2015-2016"
!define DESCRIPTION "Description for the application"
!define MAIN_APP_EXE "main_program.exe"
!define INSTALL_TYPE "SetShellVarContext current"

# location and name for the resulted compiled installer
!define INSTALLER_NAME "D:\InstallerForApp"

# root in registry where all the reg data is saved, if HKLM installation will require admin rights and will install the app for all users, if HKCU the instalation will applay only for current user
!define REG_ROOT "HKLM"

# save path for the application in the list with application in registry
!define REG_APP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${MAIN_APP_EXE}"

# Where uninstall info will be save in registry
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

# application size -> will appear in list with program installed on computer
!define INSTALLSIZE 0

######################################################################
# Application details -> properties for installer
VIProductVersion  "${VERSION}"
VIAddVersionKey "ProductName"  "${APP_NAME}"
VIAddVersionKey "CompanyName"  "${COMP_NAME}"
VIAddVersionKey "LegalCopyright"  "${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "${DESCRIPTION}"
VIAddVersionKey "ProductVersion"  "${VERSION}"
VIAddVersionKey "FileVersion"  "${VERSION}"

######################################################################

SetCompressor ZLIB
Name "${APP_NAME}"
Caption "${APP_NAME}"
BrandingText "${APP_NAME}"
InstallDirRegKey "${REG_ROOT}" "${REG_APP_PATH}" ""

# where to save the output
OutFile "${INSTALLER_NAME}"

# icon for the installer
!define MUI_ICON "resources\icon.ico"

# where the application will be installed, user can change directory and name
InstallDir "$PROGRAMFILES\${APP_NAME}"

######################################################################

!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!define MUI_LANGDLL_REGISTRY_ROOT "${REG_ROOT}"
!define MUI_LANGDLL_REGISTRY_KEY "${UNINSTALL_PATH}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

!insertmacro MUI_PAGE_WELCOME

!ifdef LICENSE_TXT
!insertmacro MUI_PAGE_LICENSE "${LICENSE_TXT}"
!endif

!insertmacro MUI_PAGE_DIRECTORY

!ifdef REG_START_MENU
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${APP_NAME}"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${REG_ROOT}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${UNINSTALL_PATH}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${REG_START_MENU}"
!insertmacro MUI_PAGE_STARTMENU Application $SM_Folder
!endif

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN "$INSTDIR\${MAIN_APP_EXE}"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH


!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Romanian"


!insertmacro MUI_RESERVEFILE_LANGDLL

######################################################################
!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend

Function .onInit
# check to see if the installer has admin rights
!insertmacro VerifyUserIsAdmin

# use the defined languages
!insertmacro MUI_LANGDLL_DISPLAY

# check if the application is already installed
  ReadRegStr $R0 ${REG_ROOT} \
  "${UNINSTALL_PATH}" \ 
  "UninstallString"
  
StrCmp $R0 "" done
 
 # if Yes then show dialog for uninstall first or abort installation
  MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
  "${APP_NAME} is already installed. $\n$\nClick OK to remove the \
  previous version or Cancel to cancel this upgrade." \
  IDOK uninst
  Abort
 
;Run the uninstaller
uninst:
  ClearErrors
  ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
 
  IfErrors no_remove_uninstaller done
    ;You can either use Delete /REBOOTOK in the uninstaller or add some code
    ;here to remove the uninstaller. Use a registry key to check
    ;whether the user has chosen to uninstall. If you are using an uninstaller
    ;components page, make sure all sections are uninstalled.
  no_remove_uninstaller:
 
done:
FunctionEnd

######################################################################

Section -MainProgram
${INSTALL_TYPE}
# define all files that will be installed
SetOverwrite ifnewer

SetOutPath "$INSTDIR"
File "R:\installer\inst\README"
File "R:\installer\inst\versions.txt"
File "R:\installer\inst\Main_app.exe"

SetOutPath "$INSTDIR\resources"
File "R:\installer\inst\resources\file1.txt"
File "R:\installer\inst\resources\icon.ico"
SectionEnd

######################################################################

Section -Additional
# define aditional files that will be installed
SectionEnd

######################################################################

Section -Icons_Reg
# create icons and shortcuts

# add the uninstaller exe in folder of installation
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall.exe"

!ifdef REG_START_MENU
# create desktop and start menu shortcut for the application
!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
CreateShortCut "$SMPROGRAMS\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}" "" "$INSTDIR\resources\logo.ico" 0
CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}" "" "$INSTDIR\resources\logo.ico" 0
# create shortcut to developer or company website in the instalation dir
WriteIniStr "$INSTDIR\${APP_NAME} website.url" "InternetShortcut" "URL" "${WEB_SITE}"
!insertmacro MUI_STARTMENU_WRITE_END
!endif

# create keys in registry with the info about program
WriteRegStr ${REG_ROOT} "${REG_APP_PATH}" "Path" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayName" "${APP_NAME} - ${DESCRIPTION}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "UninstallString" "$INSTDIR\uninstall.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayIcon" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "DisplayVersion" "0.0.0.0"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "Publisher" "${COMP_NAME}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}"  "EstimatedSize" "0"

SectionEnd

######################################################################

Section Uninstall
${INSTALL_TYPE}
# delete all files and sybfolders in the instalation directory

# delete all files from subfolders example and then delete subfolder
RMDir /r "$INSTDIR\resources\*.*"   
RMDir "$INSTDIR\resources"
	
# delete all files from instalation root and then delete the main directory
RMDir /r "$INSTDIR\*.*"    
delete $INSTDIR\uninstall.exe # delete uninstaller
rmDir $INSTDIR

# delete auxiliary data saved in %APPDATA% in Windows
RMDir /r "$APPDATA\myapp\*.*"   
RMDir "$APPDATA\myapp"

!ifndef NEVER_UNINSTALL
!endif

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_GETFOLDER "Application" $SM_Folder
Delete "$SMPROGRAMS\${APP_NAME}.lnk"
Delete "$DESKTOP\${APP_NAME}.lnk"
!endif

DeleteRegKey ${REG_ROOT} "${REG_APP_PATH}"
DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"

SectionEnd

######################################################################

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
FunctionEnd

######################################################################


#!/bin/bash
# Date : (2018-01-19)
# Distribution used to test : Xubuntu 17.10
# Author : RoninDusette, taurin, unhammer
# Licence : GPLv3
# PlayOnLinux: 4.2.12

# For some reason, playonlinux fails on trying to create the wineprefix.
# Run this
# $ killall wineserver wineboot.exe rundll32.exe
# $ PREFIX="Lightroom6LS11"
# $ env "WINE=$HOME/.PlayOnLinux/wine/linux-amd64/3.0/bin/wine64" "WINEPREFIX=$HOME/.PlayOnLinux/wineprefix/$PREFIX" winetricks colorprofile
# $ printf "ARCH=amd64\nVERSION=3.0\n" >"$HOME/.PlayOnLinux/wineprefix/$PREFIX/playonlinux.cfg"
# To avoid the Freetype issue:
# $ find ~/.PlayOnLinux/ -name 'libz*' -print0|xargs -0r rm
# And try the script again

# On installing, we get this thing when it asks for logging in:
# 00c0:fixme:ras:RasEnumConnectionsW RAS support is not implemented! Configure program to use LAN connection/winsock instead!
# which eventually times out.
# You can "log in later" and accept the license.
# It defaults to install to "C:\Program Files\Adobe"
# It installs 100 %, but then
# says that "certain components failed, see error log" which contains:

# Exit Code: 6
# Please see specific errors below for troubleshooting. For example,  ERROR:
# -------------------------------------- Summary --------------------------------------
#  - 0 fatal error(s), 8 error(s)
# ----------- Payload: Microsoft Visual C++ 2010 Redistributable Package (x64) 10.0.40219.325 {54B0C34F-18F9-11E2-BC1D-00215AEA26C9} -----------
# ERROR: Third party payload installer vcredist_x64.exe failed with exit code: -2146762485
# ERROR: Failed to install Microsoft Visual C++ 2010 Redistributable Package (x64). Please try installing it by double clicking on the executable at "C:\users\me\Desktop\Adobe\Photoshop Lightroom 6.0\payloads\Microsoft VC 2010 Redist (x64)\vcredist_x64.exe", or download and install the latest Microsoft Visual C++ 2010 Redistributable Package (x64) from Microsoft website - www.microsoft.com
# ----------- Payload: Microsoft Visual C++ 2010 Redistributable Package (x86) 10.0.40219.325 {55B82130-18F9-11E2-8D43-00215AEA26C9} -----------
# ERROR: Third party payload installer vcredist_x86.exe failed with exit code: -2146762485
# ERROR: Failed to install Microsoft Visual C++ 2010 Redistributable Package (x86). Please try installing it by double clicking on the executable at "C:\users\me\Desktop\Adobe\Photoshop Lightroom 6.0\payloads\Microsoft VC 2010 Redist (x86)\vcredist_x86.exe", or download and install the latest Microsoft Visual C++ 2010 Redistributable Package (x86) from Microsoft website - www.microsoft.com
# ----------- Payload: Microsoft Visual C++ 2012 Redistributable Package (x64) 11.0.61030.0 {3E272A93-C06B-4206-AD02-0EBE02535E20} -----------
# ERROR: Third party payload installer vcredist_x64.exe failed with exit code: -2146885619
# ERROR: Failed to install Microsoft Visual C++ 2012 Redistributable Package (x64). Please try installing it by double clicking on the executable at "C:\users\me\Desktop\Adobe\Photoshop Lightroom 6.0\payloads\Microsoft VC 2012 Redist (x64)\vcredist_x64.exe", or download and install the latest Microsoft Visual C++ 2012 Redistributable Package (x64) from Microsoft website - www.microsoft.com
# ----------- Payload: Microsoft Visual C++ 2012 Redistributable Package (x86) 11.0.61030.0 {873BE68F-480F-49A6-9649-F98CAB056AFC} -----------
# ERROR: Third party payload installer vcredist_x86.exe failed with exit code: -2146885619
# ERROR: Failed to install Microsoft Visual C++ 2012 Redistributable Package (x86). Please try installing it by double clicking on the executable at "C:\users\me\Desktop\Adobe\Photoshop Lightroom 6.0\payloads\Microsoft VC 2012 Redist (x86)\vcredist_x86.exe", or download and install the latest Microsoft Visual C++ 2012 Redistributable Package (x86) from Microsoft website - www.microsoft.com

# Running "C:\Program Files\Adobe\lightroom.exe" leads to a crash with these missing dll's:
# 00c3:err:module:import_dll Library mfc110u.dll (which is needed by L"C:\\Program Files\\Adobe\\Adobe Lightroom\\substrate.dll") not found
# 00c3:err:module:import_dll Library substrate.dll (which is needed by L"C:\\Program Files\\Adobe\\Adobe Lightroom\\ui.dll") not found
# 00c3:err:module:import_dll Library gdiplus.dll (which is needed by L"C:\\Program Files\\Adobe\\Adobe Lightroom\\ui.dll") not found
# 00c3:err:module:import_dll Library mfc110u.dll (which is needed by L"C:\\Program Files\\Adobe\\Adobe Lightroom\\ui.dll") not found
# 00c3:err:module:import_dll Library ui.dll (which is needed by L"C:\\Program Files\\Adobe\\Adobe Lightroom\\lightroom.exe") not found
# 00c3:err:module:import_dll Library mfc110u.dll (which is needed by L"C:\\Program Files\\Adobe\\Adobe Lightroom\\substrate.dll") not found
# 00c3:err:module:import_dll Library substrate.dll (which is needed by L"C:\\Program Files\\Adobe\\Adobe Lightroom\\lightroom.exe") not found
# 00c3:err:module:import_dll Library mfc110u.dll (which is needed by L"C:\\Program Files\\Adobe\\Adobe Lightroom\\lightroom.exe") not found



[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

PREFIX="Lightroom6LS11"
WINEVERSION="3.0"
TITLE="Adobe Photoshop Lightroom 6 LS11"
EDITOR="Adobe Systems Inc."
GAME_URL="http://www.adobe.com"
AUTHOR="RoninDusette, taurin, unhammer"

#Initialization
POL_GetSetupImages "http://files.playonlinux.com/resources/setups/$PREFIX/top.jpg" "http://files.playonlinux.com/resources/setups/$PREFIX/left.jpg" "$TITLE"
POL_SetupWindow_Init

POL_Debug_Init

# Presentation
POL_SetupWindow_presentation "$TITLE" "$EDITOR" "$GAME_URL" "$AUTHOR" "$PREFIX"

POL_SetupWindow_message "$(eval_gettext 'IMPORTANT: This program may NOT work well with most Intel graphics. Nvidia and AMD proprietary drivers are REQUIRED in most cases.
\n\n
Needs sRGB color profile for images to be visible. Copy sRGB.icm (comes with some native Linux software, such as GraphicsMagick) to "~/.PlayOnLinux/wineprefix/$PREFIX/drive_c/windows/system32/spool/drivers/color/sRGB Color Space Profile.icm".
\n
Or if you have winetricks installed you can run "env WINEPREFIX=~/.PlayOnLinux/wineprefix/$PREFIX winetricks colorprofile"')" "$TITLE"

# Create Prefix
POL_SetupWindow_browse "$(eval_gettext 'Please select $TITLE install file.')" "$TITLE"
POL_System_SetArch "amd64"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"

# Configuration
Set_OS "win7"

POL_Call POL_Install_atmlib
POL_Call POL_Install_corefonts
POL_Call POL_Install_wintrust
POL_Call POL_Install_msasn1
# POL_Call POL_Install_vcrun2008
POL_Call POL_Install_vcrun2010
POL_Download_Resource "https://web.archive.org/web/20061224003406/http://download.microsoft.com/download/5/0/c/50c42d0e-07a8-4a2b-befb-1a403bd0df96/IE5.01sp4-KB871260-Windows2000sp4-x86-ENU.exe" "0c0f6e300800e49472e9b2e0890a09c1" "0c0f6e300800e49472e9b2e0890a09c1"

cd "$WINEPREFIX/drive_c/windows/temp"
cabextract "$POL_USER_ROOT/ressources/IE5.01sp4-KB871260-Windows2000sp4-x86-ENU.exe" -F WINHTTP.DLL
if [ "$POL_ARCH" = "amd64" ]; then
        cp -f WINHTTP.DLL ../syswow64/winhttp.dll
else
        cp -f WINHTTP.DLL ../system32/winhttp.dll
fi
POL_Wine_OverrideDLL "native, builtin" "winhttp"
POL_Download_Resource "https://web.archive.org/web/20061224003406/http://download.microsoft.com/download/5/0/c/50c42d0e-07a8-4a2b-befb-1a403bd0df96/IE5.01sp4-KB871260-Windows2000sp4-x86-ENU.exe" "0c0f6e300800e49472e9b2e0890a09c1"
cd "$WINEPREFIX/drive_c/windows/temp"
cabextract "$POL_USER_ROOT/ressources/IE5.01sp4-KB871260-Windows2000sp4-x86-ENU.exe" -F WININET.DLL
if [ "$POL_ARCH" = "amd64" ]; then
        cp -f WININET.DLL ../syswow64/wininet.dll
else
        cp -f WININET.DLL ../system32/wininet.dll
fi
POL_Wine_OverrideDLL "native, builtin" "wininet"


# Installation
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$APP_ANSWER"
POL_Wine_WaitExit "$TITLE"

POL_SetupWindow_message "$(eval_gettext 'PlayOnLinux will now install a few required programs, including IE6. Just click NEXT through IE install, as you usually would.')" "$TITLE"

#Dependencies
# Set_OS "winxp"
# POL_Call POL_Install_ie6
# POL_Call POL_Install_wmpcodecs
# Set_OS "win7"
POL_Call POL_Install_FontsSmoothRGB
POL_Call POL_Install_gdiplus

# Create Shortcuts
POL_Shortcut "lightroom.exe" "$TITLE"
POL_Shortcut_InsertBeforeWine "$TITLE" "export LC_ALL=C.UTF-8"

POL_SetupWindow_Close
exit 0

/*
************************************************************************************************
* ShiftGameWindow                                                                              *
*                                                                                              *
* Version:             0.1 (version history at the bottom of this script)                      *
* AutoHotkey Version:  1.1                                                                     *
* Language:            English                                                                 *
* Platform:            Windows 7, 8                                                            *
* Author:              www.twitter.com/matthiew                                                *
*                                                                                              *
* Script Function:     For video games in windowed mode at native resolution. ShiftGameWindow  *
*					   will reposition the window to fill the screen.                          *
************************************************************************************************
*/


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoTrayIcon
#SingleInstance




WinGetActiveTitle, WinTitle
WinGetPos, WinX, WinY, WinWidth, WinHeight, %WinTitle%
SysGet, MonitorCount, MonitorCount
Loop, %MonitorCount%	
{
	SysGet Monitor, Monitor, %A_Index%
	if ((MonitorLeft < WinX) && (WinX < MonitorRight) && (MonitorTop < WinY) && (WinY < MonitorBottom))
	{
		MonX := MonitorLeft
		MonY := MonitorTop
		MonWidth := MonitorRight - MonitorLeft
		MonHeight := MonitorBottom - MonitorTop
	}
}
if ((WinWidth > MonWidth) && (WinHeight > MonHeight))
{
	X := (MonX - ((WinWidth - MonWidth) / 2))
	Y := (MonY - (WinHeight - MonHeight - (((WinWidth - MonWidth) / 2))))
	WinMove, %WinTitle%, , %X%, %Y%
	SetTimer, ChangeButtonNames, 50 
	MsgBox, 3, ShiftGameWindow, Do you want to keep this window size and position?
	IfMsgBox, Yes
	{
		return
	}
	else IfMsgBox, No
	{
		MsgBox, , ShiftGameWindow, Unable to detect correct window position. Please move the window so that the top left corner is in the middle of the screen, then relaunch ShiftGameWindow.		
	}
	else
	{
		WinMove, %WinTitle%, , %WinX%, %WinY%, %WinWidth%, %WinHeight%
		return
	}
	ChangeButtonNames:
	{
		IfWinNotExist, ShiftGameWindow
		{
			return  ; Keep waiting.
		}
		SetTimer, ChangeButtonNames, off 
		WinActivate 
		ControlSetText, Button1, &Yes
		ControlSetText, Button2, &Retry
		ControlSetText, Button3, &No
		return
	}
}
else
{
	MsgBox, , Invalid Resolution, The active window's resolution is lower than your monitor's. ShiftGameWindow will only work if both resolutions match.`n`nShiftGameWindow will now exit.
	return
}




/*
************************************************************************************************
ShiftGameWindow Known Issues:
 - If the top-left corner of the window is off-screen, ShiftGameWindow can't reposition the
   window properly.
 - If the top-left corner of the window is on or under the Taskbar, ShiftGameWindow can't
   reposition the window properly.
 - Sometimes a game in windowed mode won't render at the correct resolution. ShiftGameWindow
   will process these normally, but the results won't be normal. Usually when this happens the
   game just needs to be restarted. I've seen this behaviour in COD4, CODWaW, Loadout, and
   Titanfall.
   

TO DO:
 - Compile.
 - Create an icon.
 - Distribute.


ShiftGameWindow Version History:
0.1 - Created ShiftGameWindow.
************************************************************************************************
*/
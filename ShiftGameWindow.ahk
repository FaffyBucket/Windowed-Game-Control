/*
************************************************************************************************
* ShiftGameWindow                                                                              *
*                                                                                              *
* Version:             0.3 (version history at the bottom of this script)                      *
* AutoHotkey Version:  1.1                                                                     *
* Language:            English                                                                 *
* Platform:            Windows 7, 8                                                            *
* Author:              www.twitter.com/matthiew                                                *
*                                                                                              *
* Script Function:     For video games in windowed mode at native resolution. ShiftGameWindow  *
*					   will reposition the active window to fill the screen.                   *
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
	if ((MonitorLeft < WinX) && (WinX < MonitorRight)
	    && (MonitorTop < WinY) && (WinY < MonitorBottom))
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
;	if (%WinTitle% = Loadout)
;	{
;		WinMove, Loadout, , %X%, %Y%, (%MonWidth% + 6), (%MonHeight% + 28)
		;Loadout doesn't always launch at the correct resolution in windowed mode.
		;This assumes the Windows 7 default border sizes.
		;WinMove, Loadout, , -3, 743, 1372, 796
;	}
	WinMove, %WinTitle%, , %X%, %Y%
	SetTimer, ChangeButtonNames, 50 
	MsgBox, 3, ShiftGameWindow, Do you want to keep this window size and position?
	IfMsgBox, Yes
		return
	else IfMsgBox, No
	{
		ErrorMsg1 =
		( LTrim Join`s
			If you are experiencing problems with ShiftGameWindow, please check the following:
			`n - Make sure that the TOP-LEFT corner of the game window is on the correct
			monitor. Move it to the center to be sure.
			`n - Make sure that the game resolution matches the monitor resolution.
			`n - Some games do not display at the correct resolution when in windowed mode. 
			This can usually be corrected by restarting the game. However, if the game won't
			display at the correct resolution, then ShiftGameWindow will not work.
			`n - Make sure that the TOP-LEFT corner of the game you want to reposition is
			clearly on the monitor workspace. If it is on/near the edge of the screen, or the
			StartMenu/Taskbar area, ShiftGameWindow will have problems detecting the window.
			`n
			`nShiftGameWindow will now undo any changes and relaunch.
		)
		MsgBox, , ShiftGameWindow, %ErrorMsg1%
		WinMove, %WinTitle%, , %WinX%, %WinY%,
		Run "%A_ScriptFullPath%"
		ExitApp
	}
	else
	{
		WinMove, %WinTitle%, , %WinX%, %WinY%,
		return
	}
	ChangeButtonNames:
	{
		IfWinNotExist, ShiftGameWindow
			return  ; Keep waiting.
		SetTimer, ChangeButtonNames, off 
		WinActivate 
		ControlSetText, Button1, &Yes
		ControlSetText, Button2, &Troubleshoot
		ControlSetText, Button3, &No
		return
	}
}
else
{
	ErrorMsg2 =
	( LTrim Join
		The active window's resolution is lower than your monitor's. ShiftGameWindow will only 
		work if both resolutions match.`n`nShiftGameWindow will now exit.
	)
	MsgBox, , Invalid Resolution, %ErrorMsg2%
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
 - Troubleshoot Loadout.


ShiftGameWindow Version History:
0.3 - Added relaunch.
0.2 - Improved error handling. Changed "Retry" to "Troubleshooting" and added troubleshooting
	  steps for the user.
0.1 - Created ShiftGameWindow.
************************************************************************************************
*/
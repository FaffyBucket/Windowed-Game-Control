/*
************************************************************************************************
* ShiftGameWindow                                                                              *
*                                                                                              *
* Version:             0.6 (version history at the bottom of this script)                      *
* AutoHotkey Version:  1.1                                                                     *
* Language:            English                                                                 *
* Platform:            Windows 7, 8                                                            *
* Author:              www.twitter.com/matthiew                                                *
*                                                                                              *
* Script Function:     This is designed for video games in windowed mode. Assign a keyboard    *
*					   shortcut to run ShiftGameWindow, then when you press the shortcut key   *
*					   ShiftGameWindow will reposition the active window to fill the screen.   *
*					   																		   *
************************************************************************************************
*/


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoTrayIcon
#SingleInstance



; Get details of the active window and monitors.
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

; Move the active window.
X := (MonX - ((WinWidth - MonWidth) / 2))
Y := (MonY - (WinHeight - MonHeight - (((WinWidth - MonWidth) / 2))))
WinMove, %WinTitle%, , %X%, %Y%
	
; After moving the window, prompt for confirmation that it worked.
SetTimer, ChangeButtonNames, 50 
MsgBox, 3, ShiftGameWindow, Do you want to keep this window size and position?
	
; [Yes]: Moving the window was successful, return.
IfMsgBox, Yes
	return
	
; [Troubleshoot].
else IfMsgBox, No
{
	WinMove, %WinTitle%, , 100, 100
	ErrorMsg1 =
	( LTrim Join`s
		If you are experiencing problems with ShiftGameWindow, please check the following:
		`n - Make sure that the TOP-LEFT corner of the game window is on the correct
		monitor. Move it to the center to be sure.
		`n - Make sure that the game resolution MATCHES the monitor resolution.
		`n - Some games do not display at the correct resolution when in windowed mode. 
		This can usually be corrected by restarting the game. However, if the game won't
		display at the correct resolution, then ShiftGameWindow may not work. You can try
		resizing it in the Advanced menu.
		`n - Make sure that the TOP-LEFT corner of the game you want to reposition is
		clearly on the monitor workspace. If it is on/near the edge of the screen, or the
		StartMenu/Taskbar area, ShiftGameWindow will have problems detecting the window.
		`n
		`nAfter checking the above, press "Retry" to relaunch ShiftGameWindow.
		`n
		`nFor windows that are the wrong resolution, press "Advanced".
		`n
		`nTo undo any changes and exit, press "Cancel".
	)
	;SetTimer, ChangeButtonNames2, 50
	MsgBox, 3, ShiftGameWindow troubleshooting, %ErrorMsg1%
		
; [Retry]: Reload ShiftGameWindow.
	IfMsgBox, Yes
	{
		Run "%A_ScriptFullPath%"
		ExitApp
	}
		
; [Advanced]: Manual repositioning.
	else IfMsgBox, No
	{
		InputMsg1 =
		( LTrim Join`s
			Please enter the desired width of the game window in pixels. This should be
			the width of your display, plus the width of the left and right borders of the
			game window.
			`n
			`nFor example if your display's resolution is 1366x768 and you are running
			Windows 7 with the default theme and DPI, you would enter "1372".
			`n
			`nThe default value is the window's current width.
		)
		InputBox, ManualWidth, Enter desired width, %InputMsg1%, , 375, 279, , , , , %WinWidth%
		if ErrorLevel
		{
			MsgBox, Window resizing cancelled. ShiftGameWindow will undo any changes and exit.
			WinMove, %WinTitle%, , %WinX%, %WinY%
			ExitApp
		}
		InputMsg2 =
		( LTrim Join`s
			Please enter the desired height of the game window in pixels. This should be
			the height of your display, plus the height of the top border (Titlebar) and
			bottom border of the game window.
			`n
			`nFor example if your display's resolution is 1366x768 and you are running
			Windows 7 with the default theme and DPI, you would enter "796".
			`n
			`nThe default value is the window's current height.
		)
		InputBox, ManualHeight, Enter desired height, %InputMsg2%, , 375, 279, , , , , %WinHeight%
		if ErrorLevel
		{
			MsgBox, Window resizing cancelled. ShiftGameWindow will undo any changes and exit.
			WinMove, %WinTitle%, , %WinX%, %WinY%
			ExitApp
		}
		WinMove, %WinTitle%, , %X%, %Y%, %ManualWidth%, %ManualHeight%
		return
	}
		
; [Cancel]: Undo any changes and end.
	else
	{
		WinMove, %WinTitle%, , %WinX%, %WinY%
		return
	}
}
	
; [Cancel]: Undo any changes and end.
else
{
	WinMove, %WinTitle%, , %WinX%, %WinY%
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
	

/*
ChangeButtonNames2::
{
	IfWinNotExist, ShiftGameWindow troubleshooting
		return  ; Keep waiting.
	SetTimer, ChangeButtonNames2, off 
	WinActivate 
	ControlSetText, Button1, &Retry
	ControlSetText, Button2, &Advanced
	ControlSetText, Button3, &Cancel
	return
}
*/




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
 - ChangeButtonNames2.


ShiftGameWindow Version History:
0.6 - Completed ShiftGameWindow functionality.
	- ChangeButtonNames2 still doesn't work.
	- Added Manual resizing.
	- Rewrote troubleshooting.
0.5 - Added further troubleshooting, but it's incomplete.
	- ChangeButtonNames2 doesn't work.
	- "Advanced" doesn't do anything yet.
0.4 - Updated documentation.
0.3 - Added relaunch.
0.2 - Improved error handling. Changed "Retry" to "Troubleshooting" and added troubleshooting
	  steps for the user.
0.1 - Created ShiftGameWindow.
************************************************************************************************
*/
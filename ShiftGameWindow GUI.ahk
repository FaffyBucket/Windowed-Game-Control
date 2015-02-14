/*
************************************************************************************************
* ShiftGameWindow                                                                              *
*                                                                                              *
* Version:             0.02 (version history at the bottom of this script)                     *
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


; GUI.
; GUI settings.
Gui, Color, FFFFFF
Gui, Font, s11
; Help Menu.
Menu, HelpMenu, Add, &How to use ShiftGameWindow, HelpHowTo
Menu, HelpMenu, Add, &Tips and troubleshooting, HelpTips
Menu, HelpMenu, Add ; Separator line.
Menu, HelpMenu, Add, &About ShiftGameWindow, HelpAbout
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar
; Main section.
Msg1 =
( LTrim Join`s
	The active window has been shifted ("%WinTitle%").
	`n
	`nDo you want to keep this window size and position?
)
Gui, Add, Text, , %Msg1%
Gui, Add, GroupBox
Gui, Add, Button, Default, &Yes
Gui, Add, Button, , &No
; Advanced section.
Gui, Add, Button, , &Advanced
Gui, Add, GroupBox
Gui, Add, TreeView
P1 := TV_Add("Advanced")
P1C1 := TV_Add("stuff goes here", P1)
Gui, Add, Hotkey, vChosenHotkey
; Show GUI.
Gui, Show, , ShiftGameWindow, ShiftGameWindow
return


; [Yes]: Moving the window was successful. Exit.
ButtonYes:
ExitApp


; [No]: Undo any changes and end.
ButtonNo:
WinMove, %WinTitle%, , %WinX%, %WinY%
ExitApp


; [Advanced]:
ButtonAdvanced:
; - Move to next window.
; - Move to 100x100.
; - Move to 100x100 on next window.
; - Resize window.


; Help Menu
HelpHowTo:
HelpMsgHowTo =
( LTrim Join`s
	ShiftGameWindow is a tool for repositioning windowed games running at
	native resolution. Assign it to a keyboard shortcut so that you can run it
	at the press of a button while in game. When it launches it will reposition
	the game to fill your screen.
	`n
	`nThe controls:
	`n - YES: Saves the current window position and exits ShiftGameWindow.
	`n - NO: Exits ShiftGameWindow without saving. Closing ShiftGameWindow will
	also exit without saving.
	`n - ADVANCED: Advanced options.
)
MsgBox, , How to use ShiftGameWindow, %HelpMsgHowTo%
return

HelpTips:
HelpMsgTips =
( LTrim Join`s
	`nAssign ShiftGameWindow to a keyboard shortcut so you can launch it in
	game.
	`nMake sure that the TOP-LEFT corner of the game window is on the correct
	monitor. Move it to the center to be sure.
	`n
	`nMake sure that the TOP-LEFT corner of the game you want to reposition is
	clearly on the monitor workspace. If it is on/near the edge of the screen,
	or the StartMenu/Taskbar area, ShiftGameWindow will have problems detecting
	the window.
	`n
	`nMake sure that the game resolution MATCHES the monitor resolution.
	`n
	`nSome games do not display at the correct resolution when in windowed
	mode. This can usually be corrected by restarting the game. However, if the
	game won't display at the correct resolution, then ShiftGameWindow may not
	work. You can try resizing it in the Advanced section.
)
MsgBox, , Tips and troubleshooting, %HelpMsgTips%
return

HelpAbout:
HelpMsgAbout = 
(
	Version 0.02
)
MsgBox, , About ShiftGameWindow, %HelpMsgAbout%
return




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
 - Recreate ShiftGameWindow with a proper GUI.
 - Create icon.
 - Compile.


ShiftGameWindow Version History:
0.1 - 
************************************************************************************************
*/
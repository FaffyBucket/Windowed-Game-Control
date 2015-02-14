#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoTrayIcon
#SingleInstance




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
	The active window has been shifted. Do you want
	`nto keep this window size and position?
)
Gui, Add, GroupBox, ,
Gui, Add, GroupBox, x1 y1 w100 h100, .
Gui, Add, Text, , %Msg1%
Gui, Add, Button, Default, &Keep changes
Gui, Add, Button, , &Revert
; Advanced section.
Gui, Add, Button, , &Advanced
Gui, Add, GroupBox
Gui, Add, TreeView
P1 := TV_Add("Advanced")
P1C1 := TV_Add("stuff goes here", P1)
Gui, Add, Hotkey, vChosenHotkey
; Show GUI.
Gui, Show, w320, ShiftGameWindow - "%WinTitle%"
return


; [Keep changes]: Moving the window was successful. Exit.
ButtonKeepchanges:
ExitApp


; [No]: Undo any changes and end.
ButtonRevert:
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
/*
*******************************************************************************
* ShiftGameWindow                                                             *
*                                                                             *
* Version:              0.05 (version history at the bottom of this script)   *
* AutoHotkey Version:   1.1                                                   *
* Language:             English                                               *
* Platform:             Windows 7, 8                                          *
* Author:               www.twitter.com/matthiew                              *
*                                                                             *
* Script Function:      This is designed for video games in windowed mode.	  *
*						Assign a keyboard shortcut to run ShiftGameWindow,    *
*						then when you press the shortcut key ShiftGameWindow  *
*						will reposition the active window to fill the screen. *
*					   														  *
*******************************************************************************
*/


#NoEnv  ; Recommended for performance and compatibility.
SendMode Input  ; Recommended due to its superior speed and reliability.
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




; GUI 2 (there is no GUI 1).
; GUI settings.
Gui, 2:+MinSize340x296 +Resize	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui, 2:Color, FFFFFF
Gui, 2:Font, s11
; Help Menu.
Menu, HelpMenu, Add, &How to use ShiftGameWindow, HelpHowTo
Menu, HelpMenu, Add, &Tips and troubleshooting, HelpTips
Menu, HelpMenu, Add ; Separator line.
Menu, HelpMenu, Add, &About ShiftGameWindow, HelpAbout
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, 2:Menu, MyMenuBar
; Main section.
Msg1 =
( LTrim Join`s
	The active window has been shifted. Do you want
	`nto keep this window size and position?
)
Gui, 2:Add, GroupBox, w316 h104,
Gui, 2:Add, Text, xp+12 yp+20, %Msg1%
Gui, 2:Add, Button, Default Section vKeepChanges x146 y68, &Keep changes
KeepChanges_TT := "Save new window position and exit."
Gui, 2:Add, Button, vRevert ys, &Revert
Revert_TT := "Undo all changes and exit."
; Advanced section.
Gui, 2:Add, Checkbox, vAdvanced xm, &Advanced features.
Advanced_TT := "More features if the automatic window shift isn't enough."
Gui, 2:Add, GroupBox
; Show GUI.
Gui, 2:Show, x800 y800 w340, ShiftGameWindow - "%WinTitle%"	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OnMessage(0x200, "WM_MOUSEMOVE")	; Tooltips
return

; [Keep changes]: Moving the window was successful. Exit.
2ButtonKeepchanges:
ExitApp

; [Revert]: Undo any changes and end.
2ButtonRevert:
2GuiClose:
2GuiEscape:
WinMove, %WinTitle%, , %WinX%, %WinY%
ExitApp




; How to use ShiftGameWindow (Gui 3)
HelpHowTo:
WinGetPos, SGWX, SGWY, , , ShiftGameWindow
SGWX := SGWX - 60
SGWY := SGWY + 20
Gui, 3:New
Gui, 3:Color, FFFFFF
Gui, 3:Font, s11
HelpMsgHowTo =
( LTrim Join`s
	ShiftGameWindow is a tool for repositioning windowed games running at
	`nnative resolution. Assign it to a keyboard shortcut so that you can run
	`nit at the press of a button while in game. When it launches it will
	`nreposition the game to fill your screen.
	`n
	`nThe controls:
	`n - YES: Saves the current window position and exits ShiftGameWindow.
	`n - NO: Exits ShiftGameWindow without saving. Closing ShiftGameWindow will
	`nalso exit without saving.
	`n - ADVANCED: Advanced options.
	`n
)
Gui, 3:Add, Text, , %HelpMsgHowTo%
Gui, 3:Add, Button, vOK x220, &OK
OK_TT :=
Gui, 3:Show, x%SGWX% y%SGWY%, How to use ShiftGameWindow
return

3ButtonOK:
3GuiClose:
3GuiEscape:
Gui, Destroy
return




; Tips and troubleshooting (GUI 4)
HelpTips:
WinGetPos, SGWX, SGWY, , , ShiftGameWindow
SGWX := SGWX - 60
SGWY := SGWY + 20
Gui, 4:New
Gui, 4:Color, FFFFFF
Gui, 4:Font, s11
HelpMsgTips =
( LTrim Join
	`nAssign ShiftGameWindow to a keyboard shortcut so you can launch it in
	`ngame.
	`n
	`nMake sure that the TOP-LEFT corner of the game window is on the correct
	`nmonitor. Move it to the center to be sure.
	`n
	`nMake sure that the TOP-LEFT corner of the game you want to reposition is
	`nclearly on the monitor workspace. If it is on/near the edge of the screen
	, or
	`nthe StartMenu/Taskbar area, ShiftGameWindow will have problems
	`ndetecting the window.
	`n
	`nMake sure that the game resolution MATCHES the monitor resolution.
	`n
	`nSome games do not display at the correct resolution when in windowed
	`nmode. This can usually be corrected by restarting the game. However, if
	`nthe game won't display at the correct resolution, then ShiftGameWindow
	`nmay not work. You can try resizing it in the Advanced section.
	`n
)
Gui, 4:Add, Text, , %HelpMsgTips%
Gui, 4:Add, Button, vOK x220, &OK
OK_TT :=
Gui, 4:Show, x%SGWX% y%SGWY%, Tips and troubleshooting
return

4ButtonOK:
4GuiClose:
4GuiEscape:
Gui, Destroy
return




; About ShiftGameWindow (GUI 5)
HelpAbout:
WinGetPos, SGWX, SGWY, , , ShiftGameWindow
SGWX := SGWX - 60
SGWY := SGWY + 20
Gui, 5:New
Gui, 5:Color, FFFFFF
Gui, 5:Font, s11
HelpMsgAbout = 
(
	Version 0.05
)
Gui, 5:Add, Text, , %HelpMsgAbout%
Gui, 5:Add, Button, vOK x220, &OK
OK_TT :=
Gui, 5:Show, x%SGWX% y%SGWY%, About ShiftGameWindow
return

5ButtonOK:
5GuiClose:
5GuiEscape:
Gui, Destroy
return




; Tooltips.
WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := A_GuiControl
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; Turn off any previous tooltip.
        SetTimer, DisplayToolTip, 200
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    ToolTip % %CurrControl%_TT  ; The leading percent sign tell it to use an expression.
    SetTimer, RemoveToolTip, 3000
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
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
 - Advanced section.
	- Move to next window.
	- Move to 100x100.
	- Move to 100x100 on next window.
	- Resize window.
 - Remember window position.
 - About.
 - Create icon.
 - Compile.


ShiftGameWindow Version History:
0.05 - Changed Help messages to additional GUIs with relative positions.
0.04 - Added GuiClose and GuiEscape.
0.03 - Started GUI design.
0.02 - Added Help Menu.
0.01 - Starting over based on previous ShiftGameWindow Alpha.
************************************************************************************************
*/
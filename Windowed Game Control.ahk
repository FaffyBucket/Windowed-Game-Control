/*
*******************************************************************************
* Windowed Game Control                                                       *
*                                                                             *
* Version:              0.08 (version history at the bottom of this script)   *
* AutoHotkey Version:   1.1                                                   *
* Language:             English                                               *
* Platform:             Windows 7, 8                                          *
* Author:               www.twitter.com/matthiew                              *
*                                                                             *
* Script Function:      This is designed for video games in windowed mode.	  *
*						Assign a keyboard shortcut to run Windowed Game	      *
*						Control, then when you press the shortcut key 		  *
*						Windowed Game Control will reposition the active	  *
*                       window to fill the screen. 							  *
*					   														  *
*******************************************************************************
*/


#NoEnv  ; Recommended for performance and compatibility.
SendMode Input  ; Recommended due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoTrayIcon
#SingleInstance




; Load settings from the registry.
RegRead, AdvancedCheckbox, HKCU, Software\FaffyBucket\Windowed Game Control
	, AdvancedCheckbox




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




; Automatically move the active window on start.
X := (MonX - ((WinWidth - MonWidth) / 2))
Y := (MonY - (WinHeight - MonHeight - (((WinWidth - MonWidth) / 2))))
WinMove, %WinTitle%, , %X%, %Y%




; GUI 2 (there is no GUI 1).
; GUI settings.
Gui, 2:+MinSize342x180 +Resize
Gui, 2:Color, FFFFFF
Gui, 2:Font, s11
; Help Menu.
Menu, HelpMenu, Add, &How to use Windowed Game Control, HelpHowTo
Menu, HelpMenu, Add, &Tips and troubleshooting, HelpTips
Menu, HelpMenu, Add ; Separator line.
Menu, HelpMenu, Add, &About Windowed Game Control, HelpAbout
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
if (AdvancedCheckbox == 0)
{
	Gui, 2:Add, GroupBox, Section x13 y117 w154 h49,
	Gui, 2:Add, Checkbox
		, gAdvancedFeatures vAdvancedCheckbox xp+12 yp+20, &Advanced features.
	AdvancedCheckbox_TT := "More features if the automatic window shift isn't enough."
	; Show GUI.
	Gui, 2:Show, x800 y800 w342 h180, Windowed Game Control - "%WinTitle%"	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}
else
; Advanced section.
{
	Gui, 2:Add, GroupBox, Section x13 y117 w316 h200,
	Gui, 2:Add, Checkbox
		, Checked gAdvancedFeatures vAdvancedCheckbox xp+12 yp+20
		, &Advanced features.
	AdvancedCheckbox_TT := "More features if the automatic window shift isn't enough."
	Gui, 2:Add, Button, vOnScreen, &Bring on-screen
	OnScreen_TT := "Game window stuck off-screen? Click to bring it back!"
	; Show GUI.
	Gui, 2:Show, x800 y800 w342 h280, Windowed Game Control - "%WinTitle%"	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
}
OnMessage(0x200, "WM_MOUSEMOVE")	; Tooltips
return

; [Keep changes]: Moving the window was successful. Exit.
2ButtonKeepChanges:
ExitApp

; [Revert]: Undo any changes and end.
2ButtonRevert:
2GuiClose:
2GuiEscape:
WinMove, %WinTitle%, , %WinX%, %WinY%
ExitApp

; [Advanced features.]
AdvancedFeatures:
Gui, Submit, NoHide
RegWrite, REG_DWORD, HKCU, Software\FaffyBucket\Windowed Game Control
	, AdvancedCheckbox, %AdvancedCheckbox%
WinMove, %WinTitle%, , %WinX%, %WinY%
Reload
return

; [Bring on-screen]
2ButtonBringOn-Screen:
WinMove, %WinTitle%, , 100, 100
return




; GUI 3: "How to use Windowed Game Control"
HelpHowTo:
WinGetPos, SGWX, SGWY, , , Windowed Game Control
SGWX := SGWX - 60
SGWY := SGWY + 20
Gui, 3:New
Gui, 3:Color, FFFFFF
Gui, 3:Font, s11
HelpMsgHowTo =
( LTrim Join`s
	 Windowed Game Control is a tool for repositioning windowed games running
	`nat native resolution. Assign it to a keyboard shortcut so that you can
	`nrun it at the press of a button while in game. When it launches it will
	`nreposition the game to fill your screen.
	`n
	`n
	`nThe controls:
	`n
	`nYES:  Saves the current window position and exits WGC.
	`n
	`nNO:  Exits WGC without saving. Closing WGC also exits without saving.
	`n
	`nADVANCED:  Advanced options.
	`n
)
Gui, 3:Add, Text, , %HelpMsgHowTo%
Gui, 3:Add, Button, vOK x220, &OK
OK_TT :=
Gui, 3:Show, x%SGWX% y%SGWY%, How to use Windowed Game Control
return

3ButtonOK:
3GuiClose:
3GuiEscape:
Gui, Destroy
return




; GUI 4: "Tips and troubleshooting"
HelpTips:
WinGetPos, SGWX, SGWY, , , Windowed Game Control
SGWX := SGWX - 60
SGWY := SGWY + 20
Gui, 4:New
Gui, 4:Color, FFFFFF
Gui, 4:Font, s11
HelpMsgTips =
( LTrim Join
	`nAssign Windowed Game Control to a keyboard shortcut so you can launch it
	`nin game.
	`n
	`nMake sure that the TOP-LEFT corner of the game window is on the correct
	`nmonitor. Move it to the center to be sure.
	`n
	`nMake sure that the TOP-LEFT corner of the game you want to reposition is
	`nclearly on the monitor workspace. If it is on/near the edge of the screen
	, or
	`nthe StartMenu/Taskbar area, Windowed Game Control will have problems
	`ndetecting the window.
	`n
	`nMake sure that the game resolution MATCHES the monitor resolution.
	`n
	`nSome games do not display at the correct resolution when in windowed
	`nmode. This can usually be corrected by restarting the game. However, if
	`nthe game won't display at the correct resolution, then Windowed Game
	`nControl may not work. You can try resizing it in the Advanced section.
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




; GUI 5: "About Windowed Game Control"
HelpAbout:
WinGetPos, SGWX, SGWY, , , Windowed Game Control
SGWX := SGWX - 60
SGWY := SGWY + 20
Gui, 5:New
Gui, 5:Color, FFFFFF
Gui, 5:Font, s11
HelpMsgAbout = 
(
	Version 0.06
)
Gui, 5:Add, Text, , %HelpMsgAbout%
Gui, 5:Add, Button, vOK x220, &OK
OK_TT :=
Gui, 5:Show, x%SGWX% y%SGWY%, About Windowed Game Control
return

5ButtonOK:
5GuiClose:
5GuiEscape:
Gui, Destroy
return




; Tooltips.
WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT 
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
    ToolTip % %CurrControl%_TT
    SetTimer, RemoveToolTip, 3000
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}




/*
*******************************************************************************
Windowed Game Control Known Issues:
 - If the top-left corner of the window is off-screen, Windowed Game Control
   can't reposition the window properly.
 - If the top-left corner of the window is on or under the Taskbar, Windowed
   Game Control can't reposition the window properly.
 - Sometimes a game in windowed mode won't render at the correct resolution.
   Windowed Game Control will process these normally, but the results won't be
   normal. Usually when this happens the game just needs to be restarted. I've
   seen this behaviour in COD4, CODWaW, Loadout, and Titanfall.
   

TO DO:
 - Advanced section.
    - GUI.
	- Move to next window.
	- Move to 100x100 on next window.
	- Resize window.
	- Replace Reload with Destroy and Show.
	- Favourites.
 - Remember window position.
 - Hotkey.
 - About.
 - Create icon.
 - Compile.


Windowed Game Control Version History:
0.08 - "Advanced features" checkbox saves state.
	 - Checkbox toggles window size.
	 - Added "Bring on-screen".
0.07 - Added AdvancedFeatures.
0.06 - Renamed to Windowed Game Control.
0.05 - Changed Help messages to additional GUIs with relative positions.
0.04 - Added GuiClose and GuiEscape.
0.03 - Started GUI design.
0.02 - Added Help Menu.
0.01 - Starting over based on previous ShiftGameWindow Alpha.
*******************************************************************************
*/
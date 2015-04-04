/*
*******************************************************************************
* Windowed Game Control                                                       *
*                                                                             *
* Version:              0.12 (version history at the bottom of this script)   *
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

#SingleInstance force




; MAIN
Hotkey, !F1, WGCHotkey
return

WGCHotkey:
RegRead, AdvancedCheckbox, HKCU, Software\FaffyBucket\Windowed Game Control
	, AdvancedCheckbox
RegRead, WGCX, HKCU, Software\FaffyBucket\Windowed Game Control, WGCX
RegRead, WGCY, HKCU, Software\FaffyBucket\Windowed Game Control, WGCY
WinGetActiveTitle, WinTitle
WinGetPos, OriginalX, OriginalY, OriginalWidth, OriginalHeight, %WinTitle%
AutoReposition(WinTitle)
RunGUI()
return




; Get details of the active window and monitors.
GetPosition()
{
	global
	WinGetPos, WinX, WinY, WinWidth, WinHeight, %WinTitle%
	SysGet, MonitorCount, MonitorCount
	SysGet Monitor1, Monitor, 1
	SysGet Monitor2, Monitor, 2
	return
}




; Automatically move the active window to fill the monitor.
AutoReposition(WinTitle)
{
	global
	GetPosition()
	if ((Monitor1Left < WinX + 100) && (WinX < Monitor1Right)
			&& (Monitor1Top < WinY + 100) && (WinY < Monitor1Bottom))
	{
		MonX := Monitor1Left
		MonY := Monitor1Top
		MonWidth := Monitor1Right - Monitor1Left
		MonHeight := Monitor1Bottom - Monitor1Top
	}
	if ((Monitor2Left < WinX + 100) && (WinX < Monitor2Right)
			&& (Monitor2Top < WinY + 100) && (WinY < Monitor2Bottom))
	{
		MonX := Monitor2Left
		MonY := Monitor2Top
		MonWidth := Monitor2Right - Monitor2Left
		MonHeight := Monitor2Bottom - Monitor2Top
	}
	X := (MonX - ((WinWidth - MonWidth) / 2))
	Y := (MonY - (WinHeight - MonHeight - (((WinWidth - MonWidth) / 2))))
	WinMove, %WinTitle%, , %X%, %Y%
	return
}




; GUI 2 (there is no GUI 1).
; GUI settings.
RunGUI()
{
	global
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
		The active window has been repositioned. Do you
		`nwant to save this window size and position?
	)
	Gui, 2:Add, GroupBox, w316 h104,
	Gui, 2:Add, Text, xp+10 yp+20, %Msg1%
	Gui, 2:Add, Button, Default Section vSave x117 y68, &Save
	Save_TT := "Save new window position and exit."
	Gui, 2:Add, Button, vUndo ys, &Undo
	Undo_TT := "Undo all changes and exit."
	if (AdvancedCheckbox == 0)	
	{
		Gui, 2:Add, GroupBox, Section x13 y117 w104 h49,
		Gui, 2:Add, Checkbox
			, gAdvanced vAdvancedCheckbox xp+12 yp+20, &Advanced.
		AdvancedCheckbox_TT := "Advanced window controls, and WGC settings."
		; Show GUI.
		Gui, 2:Show, x%WGCX% y%WGCY% w342 h180
			, Windowed Game Control - "%WinTitle%"
	}
	else
	; Advanced section.
	{
		Gui, 2:Add, GroupBox, Section x13 y117 w316 h200,
		Gui, 2:Add, Checkbox
			, Checked gAdvanced vAdvancedCheckbox xp+12 yp+20
			, &Advanced.
		AdvancedCheckbox_TT := "Advanced window controls, and WGC settings."
		; Advanced controls.
		Gui, 2:Add, Button, Section vNextScreen w140, &Next screen
		NextScreen_TT := "Moves the game to the next screen if you have 2 screens."
		Gui, 2:Add, Button, vAutoReposition wp ys, &Auto-reposition
		AutoReposition_TT
			:= "Automatically reposition the game window to fill the screen."
		Gui, 2:Add, Button, Section vFixStuck x25 yp+38 wp, &Fix stuck window
		FixStuck_TT := "Got a game window that won't move? This will fix it!"
		Gui, 2:Add, Button, vResizeWindow wp ys, &Resize window
		ResizeWindow_TT := "Manually resize the game window."
		; WGC settings.
		;Gui, 2:Add, Text, Section x28 yp+44, Keyboard shortcut: 
		;Gui, 2:Add, Hotkey, vWGCHotkey x150 yp-4
		;WGCHotkey_TT := "Change the shortcut that launches the WGC window."		
		; Show GUI.
		Gui, 2:Show, x%WGCX% y%WGCY% w342 h280
			, Windowed Game Control - "%WinTitle%"
	}
	OnMessage(0x200, "WM_MOUSEMOVE")	; Tooltips
	return
}


; [Save]: Moving the window was successful. Exit.
2ButtonSave:
{
	WinGetPos, WGCX, WGCY, , , Windowed Game Control
	RegWrite, REG_DWORD, HKCU, Software\FaffyBucket\Windowed Game Control
		, WGCX, %WGCX%
	RegWrite, REG_DWORD, HKCU, Software\FaffyBucket\Windowed Game Control
		, WGCY, %WGCY%
	Gui, Destroy
	return
}

; [Undo]: Undo any changes and end.
2ButtonUndo:
2GuiClose:
2GuiEscape:
{
	WinMove, %WinTitle%, , %OriginalX%, %OriginalY%, %OriginalWidth%, %OriginalHeight%
	WinGetPos, WGCX, WGCY, , , Windowed Game Control
	RegWrite, REG_DWORD, HKCU, Software\FaffyBucket\Windowed Game Control
		, WGCX, %WGCX%
	RegWrite, REG_DWORD, HKCU, Software\FaffyBucket\Windowed Game Control
		, WGCY, %WGCY%
	Gui, Destroy
	return
}

; [Advanced controls.]
Advanced:
{
	Gui, Submit, NoHide
	RegWrite, REG_DWORD, HKCU, Software\FaffyBucket\Windowed Game Control
		, AdvancedCheckbox, %AdvancedCheckbox%
	WinMove, %WinTitle%, , %OriginalX%, %OriginalY%
	Gui, Destroy
	RunGUI()
	return
}

; [Next screen]
2ButtonNextScreen:
{
	if (MonitorCount != 2)
	{
		MsgBox,, Error!, This only works if you have two monitors!
		return
	}
	else
	{
		GetPosition()
		if ((Monitor1Left < WinX + 100) && (WinX < Monitor1Right)
				&& (Monitor1Top < WinY + 100) && (WinY < Monitor1Bottom))
		{
			MonX := Monitor2Left
			MonY := Monitor2Top
		}
		if ((Monitor2Left < WinX + 100) && (WinX < Monitor2Right)
				&& (Monitor2Top < WinY + 100) && (WinY < Monitor2Bottom))
		{
			MonX := Monitor1Left
			MonY := Monitor1Top
		}
		X := (MonX - ((WinWidth - MonWidth) / 2))
		Y := (MonY - (WinHeight - MonHeight - (((WinWidth - MonWidth) / 2))))
		WinMove, %WinTitle%, , %X%, %Y%
		return
	}
}

; [Auto-reposition]
2ButtonAuto-Reposition:
{
	AutoReposition(WinTitle)
	return
}

; [Fix stuck window]
2ButtonFixStuckWindow:
{
	WinMove, %WinTitle%, , 100, 100
	return
}

; [Resize window]
2ButtonResizeWindow:
{
	RegRead, ResizeHeight, HKCU, Software\FaffyBucket\Windowed Game Control
		, ResizeHeight
	RegRead, ResizeWidth, HKCU, Software\FaffyBucket\Windowed Game Control
		, ResizeWidth
	SuggestedWidth := MonWidth + 6
	SuggestedHeight := MonHeight + 28
	ResizeMsg1 = 
	( LTrim Join`s
		Please enter the desired width of the game window in pixels. This should be
		the width of your display, plus the width of the left and right borders of the
		game window.
		`n
		`nFor example if your display's resolution is %MonWidth%x%MonHeight% and you are running
		Windows 7 with the default theme and DPI, you would enter "%SuggestedWidth%".
	)
	InputBox, ResizeWidth, Enter desired width, %ResizeMsg1%, , 375, 246, , , , , %ResizeWidth%
	If ErrorLevel
	{
		return
	}
	ResizeMsg2 =
	( LTrim Join`s
		Please enter the desired height of the game window in pixels. This should be
		the height of your display, plus the height of the top border (Titlebar) and
		bottom border of the game window.
		`n
		`nFor example if your display's resolution is %MonWidth%x%MonHeight% and you are running
		Windows 7 with the default theme and DPI, you would enter "%SuggestedHeight%".
	)
	InputBox, ResizeHeight, Enter desired height, %ResizeMsg2%, , 375, 257, , , , , %ResizeHeight%
	If ErrorLevel
	{
		return
	}
	WinMove, %WinTitle%, , %X%, %Y%, %ResizeWidth%, %ResizeHeight%
	AutoReposition(WinTitle)
	RegWrite, REG_DWORD, HKCU, Software\FaffyBucket\Windowed Game Control
		, ResizeHeight, %ResizeHeight%
	RegWrite, REG_DWORD, HKCU, Software\FaffyBucket\Windowed Game Control
		, ResizeWidth, %ResizeWidth%
	return
}




; GUI 3: "How to use Windowed Game Control"
HelpHowTo:
{
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
}

3ButtonOK:
3GuiClose:
3GuiEscape:
{
	Gui, Destroy
	return
}




; GUI 4: "Tips and troubleshooting"
HelpTips:
{
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
		`nthe StartMenu/Taskbar area, Windowed Game Control may have problems
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
}

4ButtonOK:
4GuiClose:
4GuiEscape:
{
	Gui, Destroy
	return
}




; GUI 5: "About Windowed Game Control"
HelpAbout:
{
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
}

5ButtonOK:
5GuiClose:
5GuiEscape:
{
	Gui, Destroy
	return
}




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
   can't reposition the window automatically.
 - If the top-left corner of the window is on or under the Taskbar, Windowed
   Game Control can't reposition the window properly.
 - Sometimes a game in windowed mode won't render at the correct resolution.
   Windowed Game Control will process these normally, but the results won't be
   normal. Usually when this happens the game just needs to be restarted. I've
   seen this behaviour in COD4, CODWaW, Loadout, and Titanfall.
   

TO DO:
 - Advanced section.
    - GUI.
	- Resize window GUI.
	- Replace Reload with Destroy and Show.
	- Favourites.
	- Hardcore mode.
 - Hotkey.
 - Update Help.
 - Create icon.
 - Compile.
 - Settings.ini.
 - Updater.
 - System tray menu.


Windowed Game Control Version History:
0.12 - Remember window position when WGC closes/opens.
	 - Updated Save button.
	 - Updated Undo button.
	 - Added "Resize window" button.
	 - Updated positioning of Advanced section buttons.
	 - Added !F1 hotkey.
	 - Updated Advanced checkbox.
	 - Updated #SingleInstance.
	 - Updated TO DO list.
0.11 - Added GetPosition().
	 - Added 100x100 offset.
	 - Added "Next screen" functionality.
0.10 - Updated AutoReposition().
	 - Removed unnecessary code.
	 - Changed "Bring on-screen" to "Fix stuck window".
	 - Added "Next screen" button.
0.09 - Renamed "Advanced features" to "Advanced controls".
	 - Added AutoReposition().
	 - Reorganised code.
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
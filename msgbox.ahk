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
* Script Function:     Maximise/restore the current window.                                    *
************************************************************************************************
*/


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoTrayIcon




#SingleInstance
SetTimer, ChangeButtonNames, 50 
MsgBox, 3, ShiftGameWindow, Do you want to keep this window size and position?
IfMsgBox, Yes 
    MsgBox, You chose Yes. 
else IfMsgBox, No
    MsgBox, You chose Retry.
else
	MsgBox, You chose No.
return 

ChangeButtonNames: 
IfWinNotExist, ShiftGameWindow
    return  ; Keep waiting.
SetTimer, ChangeButtonNames, off 
WinActivate 
ControlSetText, Button1, &Yes
ControlSetText, Button2, &Retry
ControlSetText, Button3, &No
return






/*
************************************************************************************************
ShiftGameWindow Version History:
1.0 - Created ShiftGameWindow.
************************************************************************************************
*/
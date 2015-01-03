/*
************************************************************************************************
* ShiftGameWindow                                                                              *
*                                                                                              *
* Version:             0.4 (version history at the bottom of this script)                      *
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
0.4 - Updated documentation.
0.3 - Added relaunch.
0.2 - Improved error handling. Changed "Retry" to "Troubleshooting" and added troubleshooting
	  steps for the user.
0.1 - Created ShiftGameWindow.
************************************************************************************************
*/
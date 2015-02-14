#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoTrayIcon
#SingleInstance




gui, add, edit, w600  ; Add a fairly wide edit control at the top of the window.
gui, add, text, section, First Name:  ; Save this control's position and start a new section.
gui, add, text,, Last Name:
gui, add, edit, ys  ; Start a new column within this section.
gui, add, edit
gui, show
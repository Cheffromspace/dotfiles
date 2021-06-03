#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting director

CapsLock::Esc
Return

^h::
send, {Left down}{Left up}
Return

^j::
send, {Down down}{Down up}
Return

^k::
send, {Up down}{Up up}
Return

^l::
send, {Right down}{Right up}
Return

Up::
Return

Down::
Return

Left::
Return

Right::
Return






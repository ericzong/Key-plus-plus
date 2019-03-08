
; global var
global version := "Version: 0.0.1"
global productionName := "Eric Hotkey"

global keyMap := {}

; run as admin
if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}

#Include lib
#Include systemTray.ahk
#Include init.ahk
#Include function.ahk
#Include keyMap.ahk

; -------------------------------------------------- main start --------------------------------------------------
global isCapsLockEnabled, isCapsLockPressed

^CapsLock::
!CapsLock::
+CapsLock::
^!CapsLock::
^+CapsLock::
!+CapsLock::
^+!CapsLock::
CapsLock::
isCapsLockEnabled:=true
isCapsLockPressed:=true

SetTimer, setCapsLockDisabled, -150

KeyWait, CapsLock
isCapsLockPressed:=false
if isCapsLockEnabled
{
    SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"
}
isCapsLockEnabled:=false
return

setCapsLockDisabled:
isCapsLockEnabled:=false
return

#If isCapsLockPressed

h::
j::
k::
l::
try
	runFunc(keyMap["caps_" . A_ThisHotkey])
return

#If

; -------------------------------------------------- main end --------------------------------------------------
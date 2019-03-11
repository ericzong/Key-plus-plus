#SingleInstance Force

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

;-------------------------------------------------- Single Key --------------------------------------------------
a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
m::
n::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z::
`;::
Enter::
try
	runFunc(keyMap["caps_" . A_ThisHotkey])
return

;-------------------------------------------------- Alt --------------------------------------------------
!a::
!b::
!c::
!d::
!e::
!f::
!g::
!h::
!i::
!j::
!k::
!l::
!m::
!n::
!o::
!p::
!q::
!r::
!s::
!t::
!u::
!v::
!w::
!x::
!y::
!z::
try
	runFunc(keyMap["caps_alt_" . A_ThisHotkey])
return

;-------------------------------------------------- Ctrl --------------------------------------------------
^a::
^b::
^c::
^d::
^e::
^f::
^g::
^h::
^i::
^j::
^k::
^l::
^m::
^n::
^o::
^p::
^q::
^r::
^s::
^t::
^u::
^v::
^w::
^x::
^y::
^z::
try
	runFunc(keyMap["caps_ctrl_" . A_ThisHotkey])
return

;-------------------------------------------------- Ctrl + Alt --------------------------------------------------
^!a::
^!b::
^!c::
^!d::
^!e::
^!f::
^!g::
^!h::
^!i::
^!j::
^!k::
^!l::
^!m::
^!n::
^!o::
^!p::
^!q::
^!r::
^!s::
^!t::
^!u::
^!v::
^!w::
^!x::
^!y::
^!z::
try
	runFunc(keyMap["caps_ctrl_alt_" . A_ThisHotkey])
return

;-------------------------------------------------- Shift + Alt --------------------------------------------------
+!a::
+!b::
+!c::
+!d::
+!e::
+!f::
+!g::
+!h::
+!i::
+!j::
+!k::
+!l::
+!m::
+!n::
+!o::
+!p::
+!q::
+!r::
+!s::
+!t::
+!u::
+!v::
+!w::
+!x::
+!y::
+!z::
try
	runFunc(keyMap["caps_shift_alt_" . A_ThisHotkey])
return

;-------------------------------------------------- Ctrl + Shift --------------------------------------------------
^+a::
^+b::
^+c::
^+d::
^+e::
^+f::
^+g::
^+h::
^+i::
^+j::
^+k::
^+l::
^+m::
^+n::
^+o::
^+p::
^+q::
^+r::
^+s::
^+t::
^+u::
^+v::
^+w::
^+x::
^+y::
^+z::
try
	runFunc(keyMap["caps_ctrl_shift_" . A_ThisHotkey])
return

;-------------------------------------------------- Ctrl + Shift + Alt --------------------------------------------------
^+!a::
^+!b::
^+!c::
^+!d::
^+!e::
^+!f::
^+!g::
^+!h::
^+!i::
^+!j::
^+!k::
^+!l::
^+!m::
^+!n::
^+!o::
^+!p::
^+!q::
^+!r::
^+!s::
^+!t::
^+!u::
^+!v::
^+!w::
^+!x::
^+!y::
^+!z::
try
	runFunc(keyMap["caps_ctrl_shift_alt_" . A_ThisHotkey])
return

#If

;-------------------------------------------------- main end --------------------------------------------------

#SingleInstance Force

; global var
global version := "Version: 0.1.0"
global productionName := "Eric Hotkey"

global keyMap := {}
global config := readIniConfig("config\config.ini")

; run as admin
if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}

#Include language
#Include zh_CN.ahk

#Include ..\lib
#Include function.ahk
#Include keyMap.ahk
#Include systemTray.ahk
#Include init.ahk

; --------------------- main start ---------------------
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

;-------------------- Single Key --------------------
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
esc::
F2::
F5::
;-------------------- Alt --------------------
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
;-------------------- Ctrl --------------------
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
;-------------------- Shift --------------------
+a::
+b::
+c::
+d::
+e::
+f::
+g::
+h::
+i::
+j::
+k::
+l::
+m::
+n::
+o::
+p::
+q::
+r::
+s::
+t::
+u::
+v::
+w::
+x::
+y::
+z::
+;::
;-------------------- Ctrl + Alt --------------------
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
;-------------------- Shift + Alt --------------------
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
;-------------------- Ctrl + Shift --------------------
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
;-------------------- Ctrl + Shift + Alt --------------------
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
	runFunc(keyMap["caps_" . A_ThisHotkey])
return

#If

;--------------------- main end ---------------------

; 子程序，必须放置在这里，否则会被立即执行，导致问题
#Include sub.ahk
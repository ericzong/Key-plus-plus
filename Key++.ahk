#SingleInstance Force

; global var
global version := "Version: 0.5.8"
global productionName := "Key++"

global keyMap := {}
global config := readIniConfig("config\config.ini")

global rootDir := A_ScriptDir

global windowQueue := Array()
;global winIdx := -1

SetWorkingDir %A_ScriptDir%

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

;#WinActivateForce
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

SetTimer, setCapsLockDisabled, -200

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
1::
2::
3::
4::
5::
6::
7::
8::
9::
0::
F1::
F2::
F3::
F4::
F5::
F6::
F7::
F8::
F9::
F10::
F11::
F12::
[::
`;::
'::
`::
Enter::
esc::
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
!1::
!2::
!3::
!4::
!5::
!6::
!7::
!8::
!9::
!0::
!F1::
!F2::
!F3::
!F4::
!F5::
!F6::
!F7::
!F8::
!F9::
!F10::
!F11::
!F12::
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
^1::
^2::
^3::
^4::
^5::
^6::
^7::
^8::
^9::
^0::
^F1::
^F2::
^F3::
^F4::
^F5::
^F6::
^F7::
^F8::
^F9::
^F10::
^F11::
^F12::
^Left::
^Right::
^Up::
^Down::
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
+1::
+2::
+3::
+4::
+5::
+6::
+7::
+8::
+9::
+0::
+F1::
+F2::
+F3::
+F4::
+F5::
+F6::
+F7::
+F8::
+F9::
+F10::
+F11::
+F12::
+`;::
+,::
+[::
+'::
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
^!1::
^!2::
^!3::
^!4::
^!5::
^!6::
^!7::
^!8::
^!9::
^!0::
^!F1::
^!F2::
^!F3::
^!F4::
^!F5::
^!F6::
^!F7::
^!F8::
^!F9::
^!F10::
^!F11::
^!F12::
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
+!1::
+!2::
+!3::
+!4::
+!5::
+!6::
+!7::
+!8::
+!9::
+!0::
+!F1::
+!F2::
+!F3::
+!F4::
+!F5::
+!F6::
+!F7::
+!F8::
+!F9::
+!F10::
+!F11::
+!F12::
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
^+1::
^+2::
^+3::
^+4::
^+5::
^+6::
^+7::
^+8::
^+9::
^+0::
^+F1::
^+F2::
^+F3::
^+F4::
^+F5::
^+F6::
^+F7::
^+F8::
^+F9::
^+F10::
^+F11::
^+F12::
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
^+!1::
^+!2::
^+!3::
^+!4::
^+!5::
^+!6::
^+!7::
^+!8::
^+!9::
^+!0::
^+!F1::
^+!F2::
^+!F3::
^+!F4::
^+!F5::
^+!F6::
^+!F7::
^+!F8::
^+!F9::
^+!F10::
^+!F11::
^+!F12::
try
	runFunc(keyMap["caps_" . A_ThisHotkey])
return

#If

;--------------------- main end ---------------------

; 子程序，必须放置在这里，否则会被立即执行，导致问题
#Include sub.ahk

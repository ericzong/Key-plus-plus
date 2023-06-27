#SingleInstance Force

; global var
global version := "Version: 1.0.0-Beta"
global productionName := "Key++"

global keyMap := Map()
global config := readIniConfig("config\config.ini")

global rootDir := A_ScriptDir

global windowQueue := ["", "", "", "", ""]

global isCapsLockEnabled := false
global isCapsLockPressed := false

SetWorkingDir(A_ScriptDir)

; run as admin
if not A_IsAdmin
{
	Run("*RunAs `"" A_ScriptFullPath "`"")
	ExitApp()
}

#Include "language"
#Include "zh_CN.ahk"

#Include "..\lib"
#Include "function.ahk"
#Include "keyMap.ahk"
#Include "systemTray.ahk"
#Include "init.ahk"
#Include "sub.ahk"

; --------------------- main start ---------------------

^CapsLock::
!CapsLock::
+CapsLock::
^!CapsLock::
^+CapsLock::
!+CapsLock::
^+!CapsLock::
CapsLock::
{
	global isCapsLockEnabled
	global isCapsLockPressed
	isCapsLockEnabled:=true
	isCapsLockPressed:=true

	SetTimer(setCapsLockDisabled,-200)

	KeyWait("CapsLock")
	isCapsLockPressed:=false
	if (isCapsLockEnabled)
	{
		SetCapsLockState(GetKeyState("CapsLock", "T") ? "Off" : "On")
	}
	isCapsLockEnabled:=false
}

setCapsLockDisabled()
{
global isCapsLockEnabled
isCapsLockEnabled:=false
}

#HotIf isCapsLockPressed

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
{
	try
	{
		keyName := "caps_" . A_ThisHotkey
		if (keyMap.Has(keyName))
		{
			runFunc(keyMap[keyName])
		} else
		{
			writeLog("热键未定义：" A_ThisHotkey, "INFO")
		}
	}
	catch Error as err
	{
		global writeLog
		writeLog("执行热键失败：" A_ThisHotkey " " err.File "(" err.Line ") " err.Message, "ERROR")
	}
}

#HotIf

;--------------------- main end ---------------------

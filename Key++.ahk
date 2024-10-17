﻿#Requires AutoHotkey v2.0 ; prefer Unicode.
#SingleInstance Force

; global var
global version := "1.4.0"
global productionName := "Key++"

global keyMap := Map()
global config := readIniConfig("config\config.ini")

global rootDir := A_ScriptDir

; 窗口句柄数组，用于记录/激活窗口
global windowQueue := ["", "", "", "", ""]
global minimizedWindows := Map()

global isCapsLockEnabled := false
global isCapsLockPressed := false

global isNumLock := false

SetWorkingDir(A_ScriptDir)

; run as admin
if not A_IsAdmin
{
	Run("*RunAs `"" A_ScriptFullPath "`" /restart")
	ExitApp()
}

#Include "language"
#Include "zh_CN.ahk"

#Include "..\plugins"
#Include "open-dialog-helper.ahk"
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
		; 备注：一些组合键使用了~前缀，则在后结触发时也带~前缀。
		; 比如：定义了快捷键 ~!d，后续触发的 Alt+D 也会带上前缀。
		; 为了避免该原因引起的找不到键映射的问题，这里需要移除快捷键中的~
		hotkey := StrReplace(A_ThisHotkey, "~", "")
		keyName := "caps_" . hotkey
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

;--------------------- Num Lock start ---------------------
#HotIf isNumLock and !isCapsLockPressed
j::SendInput("1")
k::SendInput("2")
l::SendInput("3")
u::SendInput("4")
i::SendInput("5")
o::SendInput("6")
n::SendInput("0")
,::SendInput("×")
m::SendInput("÷")
#HotIf
;--------------------- Num Lock end ---------------------

;--------------------- main end ---------------------

#Requires AutoHotkey v2.0 ; prefer Unicode.
#SingleInstance Force

; global var
global version := "1.6.3"
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

#Include "..\lib"
#Include "function.ahk"
#Include "keyMap.ahk"
#Include "hud.ahk"
#Include "systemTray.ahk"
#Include "init.ahk"
#Include "..\plugins"
#Include "file-dialog-helper.ahk"

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
		; 备注：一些组合键使用了~前缀，则在后续触发时也带~前缀。
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
m::
{
    SendText("1")
    showHud("m")
}
,::
{
    SendText("2")
    showHud(",")
}
.::
{
    SendText("3")
    showHud(".")
}
j::
{
    SendText("4")
    showHud("j")
}
k::
{
    SendText("5")
    showHud("k")
}
l::
{
    SendText("6")
    showHud("l")
}
u::
{
    SendText("7")
    showHud("u")
}
i::
{
    SendText("8")
    showHud("i")
}
o::
{
    SendText("9")
    showHud("o")
}
n::
{
    SendText("0")
    showHud("n")
}
; 带空心圈数字：Ctrl + 数字键
^m::
{
    SendText("①")
    showHud("^m")
}
^,::
{
    SendText("②")
    showHud("^,")
}
^.::
{
    SendText("③")
    showHud("^.")
}
^j::
{
    SendText("④")
    showHud("^j")
}
^k::
{
    SendText("⑤")
    showHud("^k")
}
^l::
{
    SendText("⑥")
    showHud("^l")
}
^u::
{
    SendText("⑦")
    showHud("^u")
}
^i::
{
    SendText("⑧")
    showHud("^i")
}
^o::
{
    SendText("⑨")
    showHud("^o")
}
^n::
{
    SendText("⑩")
    showHud("^n")
}
; 带实心圈数字：Ctrl + Shift + 数字键
^!m::
{
    SendText("❶")
    showHud("^!m")
}
^!,::
{
    SendText("❷")
    showHud("^!,")
}
^!.::
{
    SendText("❸")
    showHud("^!.")
}
^!j::
{
    SendText("❹")
    showHud("^!j")
}
^!k::
{
    SendText("❺")
    showHud("^!k")
}
^!l::
{
    SendText("❻")
    showHud("^!l")
}
^!u::
{
    SendText("❼")
    showHud("^!u")
}
^!i::
{
    SendText("❽")
    showHud("^!i")
}
^!o::
{
    SendText("❾")
    showHud("^!o")
}
^!n::
{
    SendText("❿")
    showHud("^!n")
}
; ----- 符号定义 start -----
h::
{
    SendText("+")
    showHud("h")
}
+h::
{
    SendText("±")
    showHud("+h")
}
`;::
{
    SendText("-")
    showHud("`;")
}
y::
{
    SendText("×")
    showHud("y")
}
p::
{
    SendText("÷")
    showHud("p")
}
/::
{
    SendText("≠")
    showHud("/")
}
+/::
{
    SendText("≈")
    showHud("+/")
}

+,::
{
    SendText("<")
    showHud("+,")
}
!,::
{
    SendText("≤")
    showHud("!,")
}
+.::
{
    SendText(">")
    showHud("+.")
}
!.::
{
    SendText("≥")
    showHud("!.")
}
; ----- 符号定义 end -----

#HotIf
;--------------------- Num Lock end ---------------------

;--------------------- main end ---------------------

;--------------------- Hotstring start ---------------------

::>now::
{
	SendInput now("yyyy-MM-dd HH:mm:ss")
}

::>ts::
{
	SendInput now("yyyyMMddHHmmss")
}

::>dt::
{
	SendInput now("yyyyMMdd")
}

::>-dt::
{
	SendInput now("yyyy-MM-dd")
}

::>.dt::
{
	SendInput now("yyyy.MM.dd")
}

::>ym::
{
	SendInput now("yyyyMM")
}

;--------------------- Hotstring end ---------------------

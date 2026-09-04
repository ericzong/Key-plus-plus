; HUD 浮层显示函数
; 小键盘开启时显示，关闭时隐藏，按键时更新显示内容

global hudGui := ""

; 小键盘键位 -> 符号映射表
global numpadSymbolMap := Map()
sym1 := Map()
sym1["base"] := "1"
sym1["shift"] := ""
sym1["alt"] := ""
sym1["ctrl"] := "①"
sym1["ctrlShift"] := "❶"
numpadSymbolMap["m"] := sym1
sym2 := Map()
sym2["base"] := "2"
sym2["shift"] := "<"
sym2["alt"] := "≤"
sym2["ctrl"] := "②"
sym2["ctrlShift"] := "❷"
numpadSymbolMap[","] := sym2
sym3 := Map()
sym3["base"] := "3"
sym3["shift"] := ">"
sym3["alt"] := "≥"
sym3["ctrl"] := "③"
sym3["ctrlShift"] := "❸"
numpadSymbolMap["."] := sym3
sym4 := Map()
sym4["base"] := "4"
sym4["shift"] := ""
sym4["alt"] := ""
sym4["ctrl"] := "④"
sym4["ctrlShift"] := "❹"
numpadSymbolMap["j"] := sym4
sym5 := Map()
sym5["base"] := "5"
sym5["shift"] := ""
sym5["alt"] := ""
sym5["ctrl"] := "⑤"
sym5["ctrlShift"] := "❺"
numpadSymbolMap["k"] := sym5
sym6 := Map()
sym6["base"] := "6"
sym6["shift"] := ""
sym6["alt"] := ""
sym6["ctrl"] := "⑥"
sym6["ctrlShift"] := "❻"
numpadSymbolMap["l"] := sym6
sym7 := Map()
sym7["base"] := "7"
sym7["shift"] := ""
sym7["alt"] := ""
sym7["ctrl"] := "⑦"
sym7["ctrlShift"] := "❼"
numpadSymbolMap["u"] := sym7
sym8 := Map()
sym8["base"] := "8"
sym8["shift"] := ""
sym8["alt"] := ""
sym8["ctrl"] := "⑧"
sym8["ctrlShift"] := "❽"
numpadSymbolMap["i"] := sym8
sym9 := Map()
sym9["base"] := "9"
sym9["shift"] := ""
sym9["alt"] := ""
sym9["ctrl"] := "⑨"
sym9["ctrlShift"] := "❾"
numpadSymbolMap["o"] := sym9
sym0 := Map()
sym0["base"] := "0"
sym0["shift"] := ""
sym0["alt"] := ""
sym0["ctrl"] := "⑩"
sym0["ctrlShift"] := "❿"
numpadSymbolMap["n"] := sym0
symH := Map()
symH["base"] := "+"
symH["shift"] := "±"
symH["alt"] := ""
symH["ctrl"] := ""
symH["ctrlShift"] := ""
numpadSymbolMap["h"] := symH
symSemicolon := Map()
symSemicolon["base"] := "-"
symSemicolon["shift"] := ""
symSemicolon["alt"] := ""
symSemicolon["ctrl"] := ""
symSemicolon["ctrlShift"] := ""
numpadSymbolMap["`;"] := symSemicolon
symY := Map()
symY["base"] := "×"
symY["shift"] := ""
symY["alt"] := ""
symY["ctrl"] := ""
symY["ctrlShift"] := ""
numpadSymbolMap["y"] := symY
symP := Map()
symP["base"] := "÷"
symP["shift"] := ""
symP["alt"] := ""
symP["ctrl"] := ""
symP["ctrlShift"] := ""
numpadSymbolMap["p"] := symP
symSlash := Map()
symSlash["base"] := "≠"
symSlash["shift"] := "≈"
symSlash["alt"] := ""
symSlash["ctrl"] := ""
symSlash["ctrlShift"] := ""
numpadSymbolMap["/"] := symSlash

; 获取当前按键应显示的符号
getNumpadDisplay(hotkey) {
    global numpadSymbolMap
    
    ; 解析修饰符和按键
    key := hotkey
    hasShift := false
    hasAlt := false
    hasCtrl := false
    
    ; 检查 Ctrl+Shift+Alt
    if (SubStr(key, 1, 3) == "^+!") {
        hasCtrl := true
        hasShift := true
        hasAlt := true
        key := SubStr(key, 4)
    }
    ; 检查 Ctrl+Shift
    else if (SubStr(key, 1, 2) == "^+") {
        hasCtrl := true
        hasShift := true
        key := SubStr(key, 3)
    }
    ; 检查 Ctrl+Alt
    else if (SubStr(key, 1, 2) == "^!") {
        hasCtrl := true
        hasAlt := true
        key := SubStr(key, 3)
    }
    ; 检查 Ctrl
    else if (SubStr(key, 1, 1) == "^") {
        hasCtrl := true
        key := SubStr(key, 2)
    }
    ; 检查 Alt
    else if (SubStr(key, 1, 1) == "!") {
        hasAlt := true
        key := SubStr(key, 2)
    }
    ; 检查 Shift
    else if (SubStr(key, 1, 1) == "+") {
        hasShift := true
        key := SubStr(key, 2)
    }
    
    ; 查找对应的映射
    if (!numpadSymbolMap.Has(key))
        return ""

    sym := numpadSymbolMap[key]

    ; 注意：Map 取键值必须用索引访问 sym["xxx"]。
    ; 点访问 sym.base 会取到对象原生属性 base（返回 Map.Prototype）而非键值
    if (hasCtrl && hasShift && sym["ctrlShift"] != "")
        return sym["ctrlShift"]
    if (hasCtrl && sym["ctrl"] != "")
        return sym["ctrl"]
    if (hasShift && sym["shift"] != "")
        return sym["shift"]
    if (hasAlt && sym["alt"] != "")
        return sym["alt"]
    return sym["base"]
}

; 创建并显示 HUD
showHud(hotkey) {
    global hudGui

    display := getNumpadDisplay(hotkey)
    if (display == "")
        return

    ; 获取鼠标位置
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mx, &my)

    ; 创建或更新 GUI
    if (!hudGui || !WinExist("ahk_id " hudGui.Hwnd)) {
        try {
            hudGui := Gui("+AlwaysOnTop -Caption")
            hudGui.BackColor := "1a1b26"
            hudGui.SetFont("s20 w700 c7aa2f7", "Segoe UI")
            hudGui.AddText("vhudText", display)
            hudGui.Show("Hide")
        } catch Error as err {
            writeLog("HUD 创建失败：" err.Message, "ERROR")
            return
        }
    } else {
        ; 更新显示内容
        try {
            hudGui["hudText"].Text := display
        } catch {
            ; 控件可能已被销毁，重新创建
            try {
                hudGui.Destroy()
            } catch {
                ; ignore
            }
            hudGui := ""
            return showHud(hotkey)
        }
    }

    ; 居中到鼠标位置
    hudGui.Show("x" . (mx - 25) . " y" . (my - 35) . " NoActivate")

    ; 设置定时隐藏（2秒后）
    ; 注意：v2 的 SetTimer 返回空串（不是定时器对象），
    ; 取消/重设定时器须直接操作 hideHud 函数引用
    SetTimer(hideHud, 0)
    SetTimer(hideHud, 2000)
}

; 显示小键盘布局（初始状态）
showNumpadLayout() {
    global hudGui

    ; 获取鼠标位置
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mx, &my)

    ; 创建或更新 GUI
    if (!hudGui || !WinExist("ahk_id " hudGui.Hwnd)) {
        try {
            hudGui := Gui("+AlwaysOnTop -Caption")
            hudGui.BackColor := "1a1b26"
            hudGui.SetFont("s20 w700 c7aa2f7", "Segoe UI")
            hudGui.AddText("vhudText", "Num Lock 已开启")
            hudGui.Show("Hide")
        } catch Error as err {
            writeLog("HUD 创建失败：" err.Message, "ERROR")
            return
        }
    } else {
        ; 更新显示内容
        try {
            hudGui["hudText"].Text := "Num Lock 已开启"
        } catch {
            ; 控件可能已被销毁，重新创建
            try {
                hudGui.Destroy()
            } catch {
                ; ignore
            }
            hudGui := ""
            return showNumpadLayout()
        }
    }

    ; 居中到鼠标位置
    hudGui.Show("x" . (mx - 25) . " y" . (my - 35) . " NoActivate")

    ; 设置定时隐藏（3秒后）
    SetTimer(hideHud, 0)
    SetTimer(hideHud, 3000)
}

; 隐藏 HUD
hideHud(*) {
    global hudGui

    if (hudGui != "" && WinExist("ahk_id " hudGui.Hwnd)) {
        try {
            hudGui.Hide()
        } catch {
            hudGui := ""
        }
    }
}

; 销毁 HUD（脚本退出时调用）
destroyHud() {
    global hudGui

    SetTimer(hideHud, 0)

    if (hudGui != "" && WinExist("ahk_id " hudGui.Hwnd)) {
        try {
            hudGui.Destroy()
        } catch {
            ; ignore
        }
        hudGui := ""
    }
}

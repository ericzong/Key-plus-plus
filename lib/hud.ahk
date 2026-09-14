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

; 将 HUD 定位到鼠标所在屏幕的工作区右下角
positionNumpadHUD() {
    global hudGui

    monitorIdx := GetActiveMonitor()
    if (!monitorIdx)
        monitorIdx := 1

    mh := MonitorWorkArea(monitorIdx)
    posX := mh.Right - 340 - 16
    posY := mh.Bottom - 170 - 16
    hudGui.Show("x" . posX . " y" . posY . " NoActivate")
}

; 创建并显示常驻小键盘布局 HUD（固定屏幕右下角）
showNumpadLayout() {
    global hudGui, numpadSymbolMap

    if (hudGui != "" && WinExist("ahk_id " hudGui.Hwnd)) {
        ; GUI 已存在，按当前鼠标所在屏幕重新定位并显示
        try {
            positionNumpadHUD()
        } catch {
            ; ignore
        }
        SetTimer(_numpadTimerFn, 100)
        return
    }

    ; ---- 第一次创建 ----
    try {
        hudGui := Gui("+AlwaysOnTop -Caption +ToolWindow +OwnDialogs +E0x20")
        hudGui.BackColor := "1a1b26"
        hudGui.SetFont("s13 w700 c9493d3", "Segoe UI")   ; 按键名（上）
        hudGui.SetFont("s13 w700 c9493d3", "Segoe UI")    ; 映射字符（上）

        ; 每格宽 52px，行高 54px，起始偏移
        startX := 16
        startY := 16
        cellW  := 52
        cellH  := 54

        ; 键盘布局：每个条目 [key, x索引, y索引]
        layout := [
            ["y", 0, 0], ["u", 1, 0], ["i", 2, 0], ["o", 3, 0], ["p", 4, 0],
            ["h", 0, 1], ["j", 1, 1], ["k", 2, 1], ["l", 3, 1], ["`;", 4, 1],
            ["n", 0, 2], ["m", 1, 2], [",", 2, 2], [".", 3, 2], ["/", 4, 2]
        ]

        for entry in layout {
            key      := entry[1]
            colIdx   := entry[2]
            rowIdx   := entry[3]
            ctrlName := "k_" . StrReplace(key, "`;", "semi")
            xPos     := startX + colIdx * cellW
            yPos     := startY + rowIdx * cellH

            ; 上：映射字符（大字号，绿色）
            sym := numpadSymbolMap[key]
            hudGui.AddText("x" . xPos . " y" . yPos . " w" . cellW . " h" . (cellH // 2) . " center v" . ctrlName, sym["base"])
            ; 下：按键名（小字号，灰白色）
            hudGui.SetFont("s11 w400 c89b0c1", "Segoe UI")
            hudGui.AddText("x" . xPos . " y" . (yPos + cellH // 2) . " w" . cellW . " h" . (cellH // 2) . " center", key)
            hudGui.SetFont("s13 w700 c9493d3", "Segoe UI")   ; 恢复映射字符字体
        }

        hudGui.Show("Hide")
        ; 立即初始化显示（基于当前修饰符状态）
        refreshNumpadHUD()
        positionNumpadHUD()
        SetTimer(_numpadTimerFn, 100)
    } catch Error as err {
        writeLog("HUD 创建失败：" err.Message, "ERROR")
        return
    }
}

; 刷新 HUD 所有格子显示（由定时 timer 调用）
refreshNumpadHUD() {
    global hudGui, numpadSymbolMap

    if (!hudGui || !WinExist("ahk_id " hudGui.Hwnd))
        return

    hasCtrl := GetKeyState("Ctrl", "P")
    hasShift := GetKeyState("Shift", "P")
    hasAlt := GetKeyState("Alt", "P")

    for key, sym in numpadSymbolMap {
        controlName := "k_" . StrReplace(key, "`;", "semi")

        if (hasCtrl && hasShift && sym["ctrlShift"] != "")
            display := sym["ctrlShift"]
        else if (hasCtrl && sym["ctrl"] != "")
            display := sym["ctrl"]
        else if (hasShift && sym["shift"] != "")
            display := sym["shift"]
        else if (hasAlt && sym["alt"] != "")
            display := sym["alt"]
        else
            display := sym["base"]

        try {
            ; 只在文本真正变化时才更新，避免不必要的重绘闪烁
            if (hudGui[controlName].Text != display) {
                hudGui[controlName].Text := display
            }
        } catch {
            ; ignore
        }
    }
}

; 定时刷新修饰符状态（100ms 间隔）
_numpadTimerFn(*) {
    static lastMonitorIdx := 0
    monitorIdx := GetActiveMonitor()
    if (!monitorIdx)
        monitorIdx := 1
    if (monitorIdx != lastMonitorIdx) {
        lastMonitorIdx := monitorIdx
        positionNumpadHUD()
    }
    refreshNumpadHUD()
}

; 隐藏 HUD
hideHud(*) {
    global hudGui

    SetTimer(_numpadTimerFn, 0)   ; 停止刷新定时器

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

    SetTimer(_numpadTimerFn, 0)   ; 停止刷新定时器

    if (hudGui != "" && WinExist("ahk_id " hudGui.Hwnd)) {
        try {
            hudGui.Destroy()
        } catch {
            ; ignore
        }
        hudGui := ""
    }
}

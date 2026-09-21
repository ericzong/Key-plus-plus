; HUD 浮层显示函数
; 小键盘开启时显示，关闭时隐藏，按键时更新显示内容

global hudGui := ""

; 小键盘键位 -> 符号映射表
global numpadSymbolMap := Map()

NumpadSymbol(base, shift := "⊘", alt := "⊘", ctrl := "⊘", ctrlShift := "⊘", ctrlAlt := "⊘", shiftAlt := "⊘", ctrlShiftAlt := "⊘") {
    return Map(
        "base", base,
        "shift", shift,
        "alt", alt,
        "ctrl", ctrl,
        "ctrlShift", ctrlShift,
        "ctrlAlt", ctrlAlt,
        "shiftAlt", shiftAlt,
        "ctrlShiftAlt", ctrlShiftAlt
    )
}

numpadSymbolMap["m"] := NumpadSymbol("1", , , "①", , "❶")
numpadSymbolMap[","] := NumpadSymbol("2", "<", "≤", "②", , "❷")
numpadSymbolMap["."] := NumpadSymbol("3", ">", "≥", "③", , "❸")
numpadSymbolMap["j"] := NumpadSymbol("4", , , "④", , "❹")
numpadSymbolMap["k"] := NumpadSymbol("5", , , "⑤", , "❺")
numpadSymbolMap["l"] := NumpadSymbol("6", , , "⑥", , "❻")
numpadSymbolMap["u"] := NumpadSymbol("7", , , "⑦", , "❼")
numpadSymbolMap["i"] := NumpadSymbol("8", , , "⑧", , "❽")
numpadSymbolMap["o"] := NumpadSymbol("9", , , "⑨", , "❾")
numpadSymbolMap["n"] := NumpadSymbol("0", , , "⑩", , "❿")
numpadSymbolMap["h"] := NumpadSymbol("+", "±")
numpadSymbolMap["`;"] := NumpadSymbol("-")
numpadSymbolMap["y"] := NumpadSymbol("×")
numpadSymbolMap["p"] := NumpadSymbol("÷")
numpadSymbolMap["/"] := NumpadSymbol("≠", "≈")

getNumpadSymbol(sym, hasCtrl, hasShift, hasAlt) {
    if (hasCtrl && hasShift && hasAlt)
        return sym["ctrlShiftAlt"]
    if (hasCtrl && hasShift)
        return sym["ctrlShift"]
    if (hasCtrl && hasAlt)
        return sym["ctrlAlt"]
    if (hasShift && hasAlt)
        return sym["shiftAlt"]
    if (hasCtrl)
        return sym["ctrl"]
    if (hasShift)
        return sym["shift"]
    if (hasAlt)
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

        display := getNumpadSymbol(sym, hasCtrl, hasShift, hasAlt)

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

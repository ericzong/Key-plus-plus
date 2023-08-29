;****************************** Tool functions ******************************
runFunc(str) {
	; 执行指定的函数
	; 参数：str - 函数调用的字符串表示，可以包含参数
	; 注意：函数参数如能转化为数字则会转换，否则视为字符串
	if(!RegExMatch(str, "\)$"))
	{ ; (简化处理)如果参数字符串不以“右圆括号”结尾，就认为参数字符串是函数名
		%str%() ; 直接无参调用
		return
	}
	if(RegExMatch(str, "(\w+)\((.*)\)$", &match))
	{ ; 如果参数字符串格式为：FuncName(...)
		func := match[1]

		if (!match[2])
		{ ; 分组2 不存在，即有括号无参数
			%func%() ; 直接无参调用
			return
		}
		; 分析函数参数
		params := Array()
		Loop Parse, match[2], "CSV"
		{
			params.Push(A_LoopField)
		}

		paramsLen := params.Length

		local p1 := params[1]
		if (IsNumber(params[1]))
		{
			p1 := Number(params[1])
		}
		if(paramsLen == 1)
		{ ; 只有一个参数

			%func%(p1)
			return
		}

		local p2 := params[2]
		if (IsNumber(params[2]))
		{
			p2 := Number(params[2])
		}
		if(paramsLen == 2)
		{
			func(p1, p2)
			return
		}

		local p3 := params[3]
		if (IsNumber(params[3]))
		{
			p3 := Number(params[3])
		}
		if(paramsLen == 3)
		{
			func(p1, p2, p3)
			return
		}
		if(paramsLen > 3) ; 如果参数超过 3 个，必须是可变参数
		{
			func(params*)
			return
		}
	}
}

runProgram(program) {
	SplitPath(program, &name)
	PID := ProcessExist(name)
	if(PID = 0)
	{
		Run(program, , "Hide")
	}
}

openDir(path) {
	if InStr(FileExist(path), "D") { ; FileExist return substring of "RASHNDOCT"
		Run("`"explorer`" `"" path "`"")
	}
}

writeLog(msg, level := "INFO") {
	timestamp := FormatTime(A_Now, "yyyy/MM/dd HH:mm:ss")
	FileAppend(timestamp " [" level "] " msg " `n", "Key++.log")
}

showHotKey() {
	MsgBox(A_ThisHotkey)
	return
}

getSelectedText()
{
	ClipboardTemp := ClipboardAll()
	A_Clipboard := ""
	SendInput("^{Insert}")
	ClipResult := ClipWait(0.5)
	if(ClipResult) {
		selectedText := A_Clipboard
		A_Clipboard := ClipboardTemp
		lastChar := SubStr(selectedText, -1)
		if(Ord(lastChar) == 10) ; 换行符
		{
			selectedText := ""
		}
		A_Clipboard := ClipboardTemp
		return selectedText
	}
}

wrapAround(charLeft, charRight := "")
{
	if(charRight == "")
	{
		charRight := charLeft
	}
	charRightLength := StrLen(charRight)
	originalText := getSelectedText()
	ClipboardTemp := ClipboardAll()
	if(originalText)
	{
		A_Clipboard := charLeft . originalText . charRight
		SendInput("+{Insert}")
	}
	else
	{
			A_Clipboard := charLeft . charRight
			SendInput("+{Insert}{Left " charRightLength "}")
	}
	Sleep(100)
	A_Clipboard := ClipboardTemp
	return
}

;-------------------- Time functions --------------------
getUptimeSeconds() {
	uptime_second := A_TickCount // 1000
	return uptime_second
}
;-------------------- Time functions End --------------------

;-------------------- GUI functions --------------------
storeWin(idx) {
	global windowQueue
	WinId := WinGetID("A") ; ID，Cmd 返回窗口句柄；A 代表当前活动窗口
	WinClass := WinGetClass("A")
	if (WinClass == "Progman" or WinClass == "WpsDesktopWindow") {
	; 当前活动窗口为“桌面”或“WPS桌面助手”时跳过
		return
	}

	windowQueue[idx] := WinId
	;MsgBox % WinId
}

activeWin(idx) {
	global windowQueue
	toWin := windowQueue[idx]

	if (!toWin) {
		; 尚未存储窗口句柄
		writeLog(idx . "尚未存储窗口")
		return
	}

	if !WinExist(getWinIdStr(toWin)) {
		; 窗口已关闭或隐藏, 重置存储
		windowQueue[idx] := ""
		return
	}

	WinGetPos(&X, &Y, &Width, &Height, "A")
	WinId := WinGetID("A")
	; 通常，(X, Y) = (-32000, -32000) 时，即使是活动窗口也是最小化的
	if(WinId == toWin && (X !== -32000 && Y !== -32000)) {
		WinMinimize(getWinIdStr(toWin))
	} else {
	    WinActivate(getWinIdStr(toWin))
	}

	return
}

getActiveWinId() {
	WinId := WinGetID("A")
	WinIdStr := getWinIdStr(WinId)
	return WinIdStr
}

getWinIdStr(id) {
	return "ahk_id " . id
}

hideWindow() {
	global minimizedWindows
	winId := WinGetId("A") ; ID，Cmd 返回窗口句柄；A 代表当前活动窗口
	WinClass := WinGetClass("A")
	if (WinClass == "Progman" or WinClass == "WpsDesktopWindow") {
	; 当前活动窗口为“桌面”或“WPS桌面助手”时跳过
		return
	}

	WinIdStr := getWinIdStr(WinId)
	Title := WinGetTitle(WinIdStr)
	minimizedWindows.Set(WinIdStr, Title)
	WinHide(WinIdStr)
}

displayAllHiddenWindows() {
	global minimizedWindows
	for WinIdStr in minimizedWindows
		WinShow(WinIdStr)
	minimizedWindows.Clear()
}

displayHiddenWindowList() {
	global minimizedWindows

	if (minimizedWindows.Count = 0)
	{ ; 没有隐藏窗口，就不显示列表窗口
		return
	}

	; 创建窗口
	MyGui := Gui()
	; +Owner 避免显示任务栏按钮
	; -Caption 移除标题部分
	MyGui.Opt("+AlwaysOnTop +Owner -Caption")
	MyGui.MarginX := 0
	MyGui.MarginY := 0
	; -Hdr 隐藏标题行
	LV := MyGui.AddListView("r16 +Report +Grid -Hdr", ["ID", "Title"])
	; 添加数据行
	for WinIdStr, title in minimizedWindows
		LV.Add(, WinIdStr, title)
	; 第一列是窗口句柄，列宽设为0（隐藏）
	LV.ModifyCol(1, "0 Integer")
	; 默认选中首行
	LV.Modify(1, "+Focus +Select")
	; 第二列自适应宽度，最后一列会填充剩余宽度
	LV.ModifyCol(2, "AutoHdr")
	; 丢失焦点关闭窗口
	LV.OnEvent("LoseFocus", CloseWinFromCtrl)
	; 双击，窗口恢复显示
	LV.OnEvent("DoubleClick", LV_DoubleClick)
	; 点击 ESC 键关闭窗口
	MyGui.OnEvent("Escape", CloseWin)
	; 需要添加隐藏的默认按钮来为 ListView 添加 Enter 键监听
	MyGui.Add("Button", "Hidden Default h0", "OK").OnEvent("Click", LV_Enter)

	MyGui.Show
}

LV_Enter(GuiCtrlObj, Info)
{
	LV := GuiCtrlObj.Gui.FocusedCtrl
	RowNumber := LV.GetNext(0, "Focused")
	LV_DoubleClick(LV, RowNumber)
}

LV_DoubleClick(LV, RowNumber)
{
	if (RowNumber = 0)
	{
		return
	}

	global minimizedWindows
	WinIdStr := LV.GetText(RowNumber, 1)

	minimizedWindows.Delete(WinIdStr)
	CloseWin(LV)

	WinShow(WinIdStr)
	WinActivate(WinIdStr)
}

CloseWin(thisGui, *) {
    WinClose(thisGui)
}

CloseWinFromCtrl(thisGui, *) {
    WinClose(thisGui.Gui)
}

;-------------------- GUI functions End --------------------

;-------------------- File .ini functions --------------------
readIniConfig(iniFile) {
	local myMap := Map()
	sections := IniRead(iniFile)
	sectionArray:=StrSplit(sections, "`n")
	for _, sectionName in sectionArray
	{
		myMap[sectionName] := readSection(iniFile, sectionName)
	}

	return myMap
}

readSection(iniFile, sectionName) {
	local myMap := Map()
	sectionMap := IniRead(iniFile, sectionName)
	keyValueArray := StrSplit(sectionMap, "`n")
	for _, keyValue in keyValueArray
	{
		keyOrValue := StrSplit(keyValue, "=")
		key := keyOrValue[1]
		value := keyOrValue[2]
		myMap[key] := value
	}

	return myMap
}
;-------------------- File .ini functions End --------------------

editScript() {
	; 如果有配置SciTE4AutoHotkey路径，使用
	editor := config["Ext"]["editor"]
	if (editor) {
		if FileExist(editor)
			Run(editor " " A_ScriptFullPath)
			return
	}
	; 否则，尝试使用notepad++
	Try
		Run("notepad++ " A_ScriptFullPath, , "", )
	; 失败，使用记事本
	catch Error
		Run("notepad " A_ScriptFullPath)

	return
}

reloadScript() {
	Reload()
	return
}

;pauseScript() {
;	Tray:= A_TrayMenu
;	Tray.ToggleCheck(lang_tray_item_pause)
;	Pause(-1)
;	return
;}

suspendScript() {
	Tray.ToggleCheck(lang_tray_item_suspend)
	Suspend(-1)
	if (A_IsSuspended) {
		TraySetIcon(,, false)
		TraySetIcon("ico\hotkey_suspend.ico",,true)
	} else {
		TraySetIcon(,, false)
		TraySetIcon("ico\hotkey.ico",,true)
	}
	return
}

exitScript() {
	ExitApp()
	return
}

Persistent  ;防止脚本自动退出
OnExit ExitFunc  ;注册退出回调
ExitFunc(ExitReason, ExitCode)
{
	displayAllHiddenWindows()
}
;****************************** Tool functions End ******************************

;****************************** Key functions ******************************
;-------------------- Text edit key functions --------------------
key_doNothing() {
	return
}

key_moveLeft() {
	SendInput("{Left}")
	return
}

key_moveLeftWord() {
	SendInput("^{Left}")
	return
}

key_selectLeft() {
	SendInput("+{Left}")
	return
}

key_selectLeftWord() {
	SendInput("^+{Left}")
	return
}

key_altLeft() {
	SendInput("!{Left}")
	return
}

key_ctrlLeft() {
	SendInput("^{Left}")
	return
}

key_ctrlAltLeft() {
	SendInput("^!{Left}")
	return
}

key_ctrlShiftLeft() {
	SendInput("^+{Left}")
	return
}

key_shiftAltLeft() {
	SendInput("+!{Left}")
	return
}

key_moveRight() {
	SendInput("{Right}")
	return
}

key_moveRightWord() {
	SendInput("^{Right}")
	return
}

key_selectRight() {
	SendInput("+{Right}")
	return
}

key_selectRightWord() {
	SendInput("^+{Right}")
	return
}

key_altRight() {
	SendInput("!{Right}")
	return
}

key_ctrlRight() {
	SendInput("^{Right}")
	return
}

key_ctrlAltRight() {
	SendInput("^!{Right}")
	return
}

key_ctrlShiftRight() {
	SendInput("^+{Right}")
	return
}

key_shiftAltRight() {
	SendInput("+!{Right}")
	return
}

key_moveUp() {
	SendInput("{Up}")
	return
}

key_selectUp() {
    SendInput("+{Up}")
	return
}

key_altUp() {
	SendInput("!{Up}")
	return
}

key_ctrlUp() {
	SendInput("^{Up}")
	return
}

key_ctrlAltUp() {
	SendInput("^!{Up}")
	return
}

key_ctrlShiftUp() {
	SendInput("^+{Up}")
	return
}

key_shiftAltUp() {
	SendInput("+!{Up}")
	return
}

key_moveDown() {
	SendInput("{Down}")
	return
}

key_selectDown() {
    SendInput("+{Down}")
	return
}

key_altDown() {
	SendInput("!{Down}")
	return
}

key_ctrlDown() {
	SendInput("^{Down}")
	return
}

key_ctrlAltDown() {
	SendInput("^!{Down}")
	return
}

key_ctrlShiftDown() {
	SendInput("^+{Down}")
	return
}

key_shiftAltDown() {
	SendInput("+!{Down}")
	return
}

key_home() {
	SendInput("{Home}")
	return
}

key_selectHome() {
	SendInput("+{Home}")
	return
}

key_end() {
	SendInput("{End}")
	return
}

key_selectEnd() {
	SendInput("+{End}")
	return
}

key_deleteLine() {
	SendInput("{Home}+{End}{BS}")
	return
}

key_enter() {
	SendInput("{End}{Enter}")
	return
}

key_del() {
	SendInput("{Del}")
	return
}

key_del_word() {
	SendInput("^{Del}")
	return
}

key_bs() {
	SendInput("{BS}")
	return
}

key_bs_word() {
	SendInput("^{BS}")
	return
}

key_angleBracket() {
	wrapAround("<", ">")
	return
}

key_parenthesis() {
	wrapAround("(", ")")
	return
}

key_brace() {
	wrapAround("{", "}")
	return
}

key_squareBracket() {
	wrapAround("[", "]")
	return
}

key_singleQuote() {
	wrapAround("'")
	return
}

key_doubleQuote() {
	wrapAround("`"")
	return
}

key_graveAccent() {
	wrapAround("``")
}
;-------------------- Text edit key functions End --------------------

;-------------------- System key functions --------------------
key_mediaPrev() {
	SendInput("{Media_Prev}")
	return
}

key_mediaNext() {
	SendInput("{Media_Next}")
	return
}

key_mediaPause() {
	SendInput("{Media_Play_Pause}")
	return
}

key_volumeUp() {
	SendInput("{Volume_Up}")
	return
}

key_volumeDown() {
	SendInput("{Volume_Down}")
	return
}

key_volumeMute() {
	SendInput("{Volume_Mute}")
	return
}

;-------------------- System key functions End --------------------


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

;-------------------- System functions --------------------
getUptimeSeconds() {
	uptime_second := A_TickCount // 1000
	return uptime_second
}

; 是否安装鼠标
HasMouse()
{
    return SysGet(19)
}

; 获取活动监视器（即鼠标所在监视器）
; 1. 无监视器，返回 0
; 2. 单监视器，返回 1
; 3. 多监视器，无鼠标，返回 1
; 4. 多监视器，有鼠标，返回鼠标所在的监视器索引
GetActiveMonitor()
{
    MonitorCount := MonitorGetCount()

    if(MonitorCount <= 1)  ; 无/单监视器，直接返回数量
        return MonitorCount

    if(!HasMouse())  ; 多显示，但无鼠标，直接返回监视器 1
        return 1

    CoordMode("Mouse", "Screen")
    MouseGetPos &xpos, &ypos

    Loop MonitorCount {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        if(xpos >= Left and xpos <= Right and ypos >= Top and ypos <= Bottom)
            return A_Index
    }
}

; 指定窗口是否在指定监视器中
; WinId：窗口查询字段
; MonitorIdx：监视器索引号
WinInMonitor(WinId, MonitorIdx)
{
	WinGetPos(&WinX, &WinY, &WinWidth, &WinHeight, WinId)
    MonitorGet(MonitorIdx, &Left, &Top, &Right, &Bottom)

	WinStatus := WinGetMinMax(WinId)  ; -1：最小化；1：最大化；0：其他
	if(WinStatus < 0) ;
	{
		return 0
	}
	else if(WinStatus = 1)
	{
		return WinX = Left and WinY = Top
	}

    WinR := WinX + WinWidth
    WinB := WinY + WinHeight

    ; 反向思考，不相交有4种场景：矩形1在矩形2的左、右、上、下
	isIn := !(WinR < Left or WinX > Right or WinB < Top or WinY > Bottom)
	if(isIn) {
		writeLog('(' Left ',' Top ') (' Right ',' Bottom ')')
	}

    return isIn
}

WinMinimizeAllByMonitor()
{
    ids := WinGetList(,, "任务管理器") ; 所有窗口
    MonitorIdx := GetActiveMonitor()
	writeLog("MonitorIdx：" MonitorIdx)
    for this_id in ids
    {
        this_title := WinGetTitle(this_id)
        if (StrLen(this_title) and WinInMonitor(this_id, MonitorIdx))
            WinMinimize(this_id)
    }
}
;-------------------- System functions End --------------------

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
	WinId := WinGetId("A") ; ID，Cmd 返回窗口句柄；A 代表当前活动窗口
	WinIdStr := getWinIdStr(WinId)

	WinClass := WinGetClass("A")
	if (WinClass == "Progman"
		or WinClass == "WpsDesktopWindow"
		or WinClass == "AutoHotkeyGUI"
	) {
	; 【特殊处理】当前活动窗口为“桌面”或“WPS桌面助手”时跳过
		return
	}

	exeName := WinGetProcessName(WinIdStr)
	if (exeName == 'Evernote.exe') {
	; 【特殊处理】印象笔记，最小化后隐藏，避免其自定义窗体在隐藏后遗留外框残影
		WinMinimize(WinIdStr)
	}

	Title := WinGetTitle(WinIdStr)
	minimizedWindows.Set(WinIdStr, Title)
	WinHide(WinIdStr)

	;ppath := WinGetProcessPath(WinIdStr)
	;TraySetIcon("C:\WINDOWS\system32\notepad.exe", 1, 1)
}

displayAllHiddenWindows() {
	global minimizedWindows
	for WinIdStr in minimizedWindows
		Try
		{
			WinShow(WinIdStr)
		}
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
	; 设置字体：14磅，微软雅黑
	MyGui.SetFont("CPurple S14 bold W700 Q5", "Microsoft YaHei")
	MyGui.MarginX := 0
	MyGui.MarginY := 0

	; -Hdr 隐藏标题行
	; -Multi 禁止多选
	LV := MyGui.AddListView("r16 w600 +Report -Hdr -Multi", ["ID", "Title"])
	; +Grid 显示网格线
	; Background 背景颜色
	LV.Opt("+Grid BackgroundF0F0F0")
	; 添加数据行
	for WinIdStr, title in minimizedWindows
		LV.Add(, WinIdStr, title)
	; 第一列是窗口句柄，列宽设为0（隐藏）
	LV.ModifyCol(1, "0 Integer")
	; 默认选中首行
	LV.Modify(1, "+Focus +Select")
	; 第二列自适应宽度，最后一列会填充剩余宽度
	LV.ModifyCol(2, "AutoHdr")

	; 需要添加隐藏的默认按钮来为 ListView 添加 Enter 键监听
	HB := MyGui.Add("Button", "Hidden Default h0 w0", "OK")

	; 绑定函数对象
	SelectFn := LV_Select.Bind(LV)
	; 双击，窗口恢复显示
	LV.OnEvent("DoubleClick", SelectFn)
	; 默认按钮为 ListView 添加 Enter 键监听
	HB.OnEvent("Click", SelectFn)

	; 绑定函数对象
	CloseFn := CloseWin.Bind(MyGui)
	; 丢失焦点关闭窗口
	; FIXME:
	; 	【场景】**首次**显示隐藏窗口列表时，鼠标点击非窗口区域使焦点丢失
	;	【问题】不能监测到焦点丢失事件，窗口不会关闭
	LV.OnEvent("LoseFocus", CloseFn)
	; 点击 ESC 键关闭窗口
	MyGui.OnEvent("Escape", CloseFn)

	MyGui.Show("AutoSize Center")
}

LV_Select(GuiCtrlObj, *)
{
	LV := GuiCtrlObj.Gui.FocusedCtrl
	RowNumber := LV.GetNext(0, "Focused")

	if (RowNumber = 0)
	{
		return
	}

	global minimizedWindows
	WinIdStr := LV.GetText(RowNumber, 1)

	minimizedWindows.Delete(WinIdStr)
	CloseWin(LV)

	Try
	{
		WinShow(WinIdStr)
		WinActivate(WinIdStr)
	}
}

CloseWin(thisGui, *) {
    WinClose(thisGui)
	return true  ; 阻止后续回调（如果有）
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

key_toggleNumLock() {
	global
	isNumLock := !isNumLock
	return
}

;-------------------- System key functions End --------------------


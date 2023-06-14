;****************************** Tool functions ******************************
runFunc(str) {
	if(!RegExMatch(str, "\)$"))
	{
		%str%()
		return
	}
	if(RegExMatch(str, "(\w+)\((.*)\)$", match))
	{
		func := Func(match1)
		
		if (!match2)
		{
			func.()
			return
		}
		
		params := []
		loop, Parse, match2, CSV
		{
			params.Insert(A_LoopField)
		}
		
		paramsLen := params.MaxIndex()
		
		if(paramsLen == 1)
		{
			func.(params[1])
			return
		}
		if(paramsLen == 2)
		{
			func.(params[1], params[2])
			return
		}
		if(paramsLen == 3)
		{
			func.(params[1], params[2], params[3])
			return
		}
		if(paramsLen > 3) ; 如果参数超过 3 个，必须是可变参数
		{
			func.(params*)
			return
		}
	}
}

runProgram(program) {
	SplitPath, program, name
	Process, Exist, %name%
	if(ErrorLevel = 0)
	{
		Run, %program%, %A_ScriptFullPath%, , Hide
	}
}

openDir(path) {
	if InStr(FileExist(path), "D") { ; FileExist return substring of "RASHNDOCT"
		Run, "explorer" "%path%"
	}
}

log(msg, level := "INFO") {
	FormatTime timestamp, %A_Now%, yyyy/MM/dd HH:mm:ss
	FileAppend %timestamp% [%level%] %msg% `n, Key++.log
}

showHotKey() {
	MsgBox, %A_ThisHotkey%
	return
} 

getSelectedText()
{
	ClipboardTemp := ClipboardAll
	Clipboard := ""
	SendInput, ^{Insert}
	ClipWait, 0.1
	if(!ErrorLevel) {
		selectedText := Clipboard
		Clipboard := ClipboardTemp
		StringRight, lastChar, seletedText, 1
		if(Asc(lastChar) == 10) ; 换行符
		{
			selectedText := ""
		}
		Clipboard := ClipboardTemp
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
	ClipboardTemp := ClipboardAll
	if(originalText)
	{
		Clipboard := charLeft . originalText . charRight
		SendInput, +{Insert}
	}
	else
	{
			Clipboard := charLeft . charRight
			SendInput, +{Insert}{Left %charRightLength%}
	}
	Sleep, 100
	Clipboard := ClipboardTemp
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
	WinGet, WinId, ID, A ; ID，Cmd 返回窗口句柄；A 代表当前活动窗口
	WinGetClass, WinClass, A
	;WinGetTitle, WinTitle, A
	if (WinClass == "Progman" or WinClass == "WpsDesktopWindow") { 
	; 当前活动窗口为“桌面”或“WPS桌面助手”时跳过
		return
	}
	windowQueue[idx] := WinId
	;MsgBox % WinId
}

activeWin(idx) {
	toWin := windowQueue[idx]
	
	if (!toWin) {
		; 尚未存储窗口句柄
		log(idx . "尚未存储窗口")
		return
	}
	
	if !WinExist("ahk_id " . toWin) {
		; 窗口已关闭或隐藏, 重置存储
		windowQueue[idx] := null
		return
	}
	
	WinGetPos, X, Y, Width, Height, A
	WinGet, WinId, ID, A
	; 通常，(X, Y) = (-32000, -32000) 时，即使是活动窗口也是最小化的
	if(WinId == toWin && (X <> -32000 && Y <> -32000)) {
		WinMinimize, ahk_id %toWin%
	} else {
	    WinActivate, ahk_id %toWin%
	}
	
	return
}
;-------------------- GUI functions End --------------------

;-------------------- File .ini functions --------------------
readIniConfig(iniFile) {
	map := {}
	IniRead, sections, %iniFile%
	sectionArray:=StrSplit(sections, "`n")
	for _, sectionName in sectionArray
	{
		map[sectionName] := readSection(iniFile, sectionName)
	}
	
	return map
}

readSection(iniFile, sectionName) {
	map := {}
	IniRead, sectionMap, %iniFile%, %sectionName%
	keyValueArray := StrSplit(sectionMap, "`n")
	for _, keyValue in keyValueArray
	{
		keyOrValue := StrSplit(keyValue, "=")
		key := keyOrValue[1]
		value := keyOrValue[2]
		map[key] := value
	}
	
	return map
}
;-------------------- File .ini functions End --------------------

editScript() {
	; 如果有配置SciTE4AutoHotkey路径，使用
	editor := config["Ext"]["editor"]
	if (editor) {
		IfExist, %editor%
			run, %editor% %A_ScriptFullPath%
			return
	}
	; 否则，尝试使用notepad++
	Run, notepad++ %A_ScriptFullPath%, , UseErrorLevel
	; 失败，使用记事本
	if (%ErrorLevel% = ERROR) {
		Run, notepad %A_ScriptFullPath%
	}
	return
}

reloadScript() {
	Reload
	return
}

pauseScript() {
	Menu, Tray, ToggleCheck, %lang_tray_item_pause%
	Pause, Toggle
	return
}

suspendScript() {
	Menu, Tray, ToggleCheck, %lang_tray_item_suspend%
	Suspend, Toggle
	return
}

exitScript() {
	ExitApp
	return
}
;****************************** Tool functions End ******************************

;****************************** Key functions ******************************
;-------------------- Text edit key functions --------------------
key_doNothing() {
	return
}

key_moveLeft() {
	SendInput, {Left}
	return
}

key_moveLeftWord() {
	SendInput, ^{Left}
	return
}

key_selectLeft() {
	SendInput, +{Left}
	return
}

key_selectLeftWord() {
	SendInput, ^+{Left}
	return
}

key_altLeft() {
	SendInput, !{Left}
	return
}

key_ctrlLeft() {
	SendInput, ^{Left}
	return
}

key_ctrlAltLeft() {
	SendInput, ^!{Left}
	return
}

key_ctrlShiftLeft() {
	SendInput, ^+{Left}
	return
}

key_shiftAltLeft() {
	SendInput, +!{Left}
	return
}

key_moveRight() {
	SendInput, {Right}
	return
}

key_moveRightWord() {
	SendInput, ^{Right}
	return
}

key_selectRight() {
	SendInput, +{Right}
	return
}

key_selectRightWord() {
	SendInput, ^+{Right}
	return
}

key_altRight() {
	SendInput, !{Right}
	return
}

key_ctrlRight() {
	SendInput, ^{Right}
	return
}

key_ctrlAltRight() {
	SendInput, ^!{Right}
	return
}

key_ctrlShiftRight() {
	SendInput, ^+{Right}
	return
}

key_shiftAltRight() {
	SendInput, +!{Right}
	return
}

key_moveUp() {
	SendInput, {Up}
	return
}

key_selectUp() {
    SendInput, +{Up}
	return
}

key_altUp() {
	SendInput, !{Up}
	return
}

key_ctrlUp() {
	SendInput, ^{Up}
	return
}

key_ctrlAltUp() {
	SendInput, ^!{Up}
	return
}

key_ctrlShiftUp() {
	SendInput, ^+{Up}
	return
}

key_shiftAltUp() {
	SendInput, +!{Up}
	return
}

key_moveDown() {
	SendInput, {Down}
	return
}

key_selectDown() {
    SendInput, +{Down}
	return
}

key_altDown() {
	SendInput, !{Down}
	return
}

key_ctrlDown() {
	SendInput, ^{Down}
	return
}

key_ctrlAltDown() {
	SendInput, ^!{Down}
	return
}

key_ctrlShiftDown() {
	SendInput, ^+{Down}
	return
}

key_shiftAltDown() {
	SendInput, +!{Down}
	return
}

key_home() {
	SendInput, {Home}
	return
}

key_selectHome() {
	SendInput, +{Home}
	return
}

key_end() {
	SendInput, {End}
	return
}

key_selectEnd() {
	SendInput, +{End}
	return
}

key_deleteLine() {
	SendInput, {Home}+{End}{BS}
	return
}

key_enter() {
	SendInput, {End}{Enter}
	return
}

key_del() {
	SendInput, {Del}
	return
}

key_del_word() {
	SendInput, ^{Del}
	return
}

key_bs() {
	SendInput, {BS}
	return
}

key_bs_word() {
	SendInput, ^{BS}
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
	wrapAround("""")
	return
}

key_graveAccent() {
	wrapAround("``")
}
;-------------------- Text edit key functions End --------------------

;-------------------- System key functions --------------------
key_mediaPrev() {
	SendInput, {Media_Prev}
	return
}

key_mediaNext() {
	SendInput, {Media_Next}
	return
}

key_mediaPause() {
	SendInput, {Media_Play_Pause}
	return
}

key_volumeUp() {
	SendInput, {Volume_Up}
	return
}

key_volumeDown() {
	SendInput, {Volume_Down}
	return
}

key_volumeMute() {
	SendInput, {Volume_Mute}
	return
}

key_loadApp1() {
	SendInput, {Launch_App1}
	return
}

key_loadApp2() {
	SendInput, {Launch_App2}
	return
}
;-------------------- System key functions End --------------------
;-------------------- Develop key function --------------------
key_develop() {
	WinGet, WinId, ID, A
	windowQueue.Insert(WinId)
}

key_develop2() {
	; WinActivate, ahk_id, windowQueue[1]
	toWin := windowQueue[1]
	WinActivate, ahk_id %toWin%
}
;-------------------- Develop key function End --------------------
;****************************** Key functions End ******************************

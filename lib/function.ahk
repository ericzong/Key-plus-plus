;****************************** Tool functions ******************************
runFunc(str) {
	if(!RegExMatch(str, "\)$"))
	{
		%str%()
		return
	}
	if(RegExMatch(str, "(\w+)\((.*)\)$", &match))
	{
		func := %match[1]%
		
		if (!match[2])
		{
			func.()
			return
		}
		
		params := []
		Loop Parse, match[2], "CSV"
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
		if(paramsLen > 3) ; 濡傛灉鍙傛暟瓒呰繃 3 涓紝蹇呴』鏄彲鍙樺弬鏁?
		{
			func.(params*)
			return
		}
	}
}

runProgram(program) {
	SplitPath(program, &name)
	ErrorLevel := ProcessExist(name)
	if(ErrorLevel = 0)
	{
		Run(program, A_ScriptFullPath, , &Hide)
	}
}

openDir(path) {
	if InStr(FileExist(path), "D") { ; FileExist return substring of "RASHNDOCT"
		Run("`"explorer`" `"" path "`"")
	}
}

log(msg, level := "INFO") {
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
	Errorlevel := !ClipWait(0.1)
	if(!ErrorLevel) {
		selectedText := A_Clipboard
		A_Clipboard := ClipboardTemp
		lastChar := SubStr(seletedText, -1*(1))
		if(Ord(lastChar) == 10) ; 鎹㈣绗?
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
	WinId := WinGetID("A") ; ID锛孋md 杩斿洖绐楀彛鍙ユ焺锛汚 浠ｈ〃褰撳墠娲诲姩绐楀彛
	WinClass := WinGetClass("A")
	;WinGetTitle, WinTitle, A
	if (WinClass == "Progman" or WinClass == "WpsDesktopWindow") { 
	; 褰撳墠娲诲姩绐楀彛涓衡€滄闈⑩€濇垨鈥淲PS妗岄潰鍔╂墜鈥濇椂璺宠繃
		return
	}
	windowQueue[idx] := WinId
	;MsgBox % WinId
}

activeWin(idx) {
	toWin := windowQueue[idx]
	
	if (!toWin) {
		; 灏氭湭瀛樺偍绐楀彛鍙ユ焺
		log(idx . "灏氭湭瀛樺偍绐楀彛")
		return
	}
	
	if !WinExist("ahk_id " . toWin) {
		; 绐楀彛宸插叧闂垨闅愯棌, 閲嶇疆瀛樺偍
		windowQueue[idx] := null
		return
	}
	
	WinGetPos(&X, &Y, &Width, &Height, "A")
	WinId := WinGetID("A")
	; 閫氬父锛?X, Y) = (-32000, -32000) 鏃讹紝鍗充娇鏄椿鍔ㄧ獥鍙ｄ篃鏄渶灏忓寲鐨?
	if(WinId == toWin && (X <> -32000 && Y <> -32000)) {
		WinMinimize("ahk_id " toWin)
	} else {
	    WinActivate("ahk_id " toWin)
	}
	
	return
}
;-------------------- GUI functions End --------------------

;-------------------- File .ini functions --------------------
readIniConfig(iniFile) {
	map := {}
	sections := IniRead(iniFile)
	sectionArray:=StrSplit(sections, "`n")
	for _, sectionName in sectionArray
	{
		map[sectionName] := readSection(iniFile, sectionName)
	}
	
	return map
}

readSection(iniFile, sectionName) {
	map := {}
	sectionMap := IniRead(iniFile, sectionName)
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
	; 濡傛灉鏈夐厤缃甋ciTE4AutoHotkey璺緞锛屼娇鐢?
	editor := config["Ext"]["editor"]
	if (editor) {
		if FileExist(editor)
			Run(editor " " A_ScriptFullPath)
			return
	}
	; 鍚﹀垯锛屽皾璇曚娇鐢╪otepad++
	{   ErrorLevel := "ERROR"
	   Try ErrorLevel := Run("notepad++ " A_ScriptFullPath, , "", )
	}
	; 澶辫触锛屼娇鐢ㄨ浜嬫湰
	if (%ErrorLevel% = ERROR) {
		Run("notepad " A_ScriptFullPath)
	}
	return
}

reloadScript() {
	Reload()
	return
}

pauseScript() {
	Tray:= A_TrayMenu
	Tray.ToggleCheck(lang_tray_item_pause)
	Pause(-1)
	return
}

suspendScript() {
	Tray.ToggleCheck(lang_tray_item_suspend)
	Suspend(-1)
	return
}

exitScript() {
	ExitApp()
	return
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
	wrapAround("""")
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

key_loadApp1() {
	SendInput("{Launch_App1}")
	return
}

key_loadApp2() {
	SendInput("{Launch_App2}")
	return
}
;-------------------- System key functions End --------------------
;-------------------- Develop key function --------------------
key_develop() {
	WinId := WinGetID("A")
	windowQueue.Insert(WinId)
}

key_develop2() {
	; WinActivate, ahk_id, windowQueue[1]
	toWin := windowQueue[1]
	WinActivate("ahk_id " toWin)
}
;-------------------- Develop key function End --------------------
;****************************** Key functions End ******************************

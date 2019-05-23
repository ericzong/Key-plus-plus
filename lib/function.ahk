;****************************** Tool functions ******************************
runFunc(str) {
	%str%()
	return
}

runProgram(program) {
	SplitPath, program, name
	Process, Exist, %name%
	if(ErrorLevel = 0)
	{
		Run, %program%, %A_ScriptFullPath%, , Hide
	}
}

showHotKey() {
	MsgBox, %A_ThisHotkey%
	return
}

;-------------------- Time functions --------------------
getUptimeSeconds() {
	uptime_second := A_TickCount // 1000
	return uptime_second
}
;-------------------- Time functions End --------------------

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
	SendInput, {Alt Up}^{Left}
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

key_moveUp() {
	SendInput, {Up}
	return
}

key_moveDown() {
	SendInput, {Down}
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
	SendInput, {Home 2}+{End}{BS}{BS}
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

key_bs() {
	SendInput, {BS}
	return
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
;-------------------- System key functions End --------------------
;****************************** Key functions End ******************************

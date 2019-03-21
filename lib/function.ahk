
runFunc(str) {
	%str%()
	return
}

showHotKey() {
	MsgBox, %A_ThisHotkey%
	return
}

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

editScript() {
	; 如果有配置SciTE4AutoHotkey路径，使用
	editor := config["Ext"]["editor"]
	if (editor) {
		IfExist, %editor%
			run, %editor% %A_ScriptFullPath%
			return
	}
	; 否则，尝试使用notepad++
	Run, notepad++ %A_ScriptFullPath%, , Hide | UseErrorLevel
	; 失败，使用记事本
	if (ErrorLevel) {
		Run, notepad %A_ScriptFullPath%
	}
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
;-------------------------------------------------- Key functions --------------------------------------------------
key_doNothing() {
	return
}

key_exit() {
	ExitApp
	return
}

key_moveLeft() {
	SendInput, {Left}
	return
}
key_moveRight() {
	SendInput, {Right}
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

key_end() {
	SendInput, {End}
	return
}

key_deleteLine() {
	SendInput, {Home}{Home}+{End}{BS}{BS}
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

; -------------------------------------------------

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

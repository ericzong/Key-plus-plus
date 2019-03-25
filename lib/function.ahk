
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
	; ���������SciTE4AutoHotkey·����ʹ��
	editor := config["Ext"]["editor"]
	if (editor) {
		IfExist, %editor%
			run, %editor% %A_ScriptFullPath%
			return
	}
	; ���򣬳���ʹ��notepad++
	Run, notepad++ %A_ScriptFullPath%, , Hide | UseErrorLevel
	; ʧ�ܣ�ʹ�ü��±�
	if (ErrorLevel) {
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
;-------------------------------------------------- Key functions --------------------------------------------------
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

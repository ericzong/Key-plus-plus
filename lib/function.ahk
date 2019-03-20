
runFunc(str) {
	%str%()
	return
}

showHotKey() {
	MsgBox, %A_ThisHotkey%
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

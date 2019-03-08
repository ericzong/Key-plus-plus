
runFunc(str) {
	%str%()
	return
}

key_doNothing() {
	return
}

key_moveLeft() {
	SendInput, {Left}
	return
}
key_moveRight() {
	SendInput, {Right}
}

key_moveUp() {
	SendInput, {Up}
}

key_moveDown() {
		SendInput, {Down}
}
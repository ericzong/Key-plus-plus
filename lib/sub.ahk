PauseHandler(ItemName, ItemPos, MyMenu) {
	pauseScript()
}

SuspendHandler(ItemName, ItemPos, MyMenu) {
	suspendScript()
}

EditHandler(ItemName, ItemPos, MyMenu) {
	editScript()
}

ReloadHandler(ItemName, ItemPos, MyMenu) {
	reloadScript()
}

ExitHandler(ItemName, ItemPos, MyMenu) {
	exitScript()
}

OpenAutorunHandler(ItemName, ItemPos, MyMenu) {
	autorunFolder := rootDir . "\autorun"
	openDir(autorunFolder)
}
PauseHandler:
pauseScript()
return

SuspendHandler:
suspendScript()
return

EditHandler:
editScript()
return

ReloadHandler:
reloadScript()
return

ExitHandler:
exitScript()
return

OpenAutorunHandler:
autorunFolder := rootDir . "\autorun"
openDir(autorunFolder)
return
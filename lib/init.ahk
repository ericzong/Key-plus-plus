SetTimer, init, -3000

return

init:
Suspend, On

uptimeSeconds := getUptimeSeconds()
if(uptimeSeconds < 60) {
	autoruns := config["Autorun"]
	for _, program in autoruns
	{
		runProgram(program)
	}
	
	Loop, autorun\*.lnk, , 1
	{
		Run, %A_LoopFileFullPath%
	}
}

Suspend, Off
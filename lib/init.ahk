SetTimer, init, -3000

return

init:
Suspend, On

uptimeSecond := getUptimeSeconds()
if(uptimeSeond < 60) {
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
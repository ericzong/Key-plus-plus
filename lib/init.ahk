SetTimer, init, -5000

return

init:
Suspend, On

uptimeSeconds := getUptimeSeconds()
if(uptimeSeconds < 600) { ; in 10min
	Loop, %0%
	{
		param := %A_Index%
		If (param = "-startup")
		{
			Loop, autorun\*.lnk, , 1
			{
				Run, %A_LoopFileFullPath%
			}
			
			autoruns := config["Autorun"]
			for _, program in autoruns
			{
				runProgram(program)
			}
		}
	}
}

Suspend, Off
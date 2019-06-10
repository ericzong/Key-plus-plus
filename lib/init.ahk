SetTimer, init, -5000

return

init:
Suspend, On

uptimeSeconds := getUptimeSeconds()
if(uptimeSeconds < 600) { ; in 10min
	Loop, %0% ; command line argument
	{
		param := %A_Index%
		If (param = "-startup") ; start autorun program
		{
			; in autorun folder
			Loop, autorun\*.lnk, , 1
			{
				Run, %A_LoopFileFullPath%
			}
			; in config file Autorun section
			autoruns := config["Autorun"]
			for _, program in autoruns
			{
				runProgram(program)
			}
		}
	}
}

Suspend, Off
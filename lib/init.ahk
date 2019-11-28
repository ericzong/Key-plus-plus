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
				idx := Instr(A_LoopFileName, "~")
				If (idx <> 1) {
					Run, %A_LoopFileFullPath%
					msg := "启动自启动链接："  A_LoopFileName
					
					log(msg)
				} else {
					msg := "禁用自启动链接："  A_LoopFileName
					
					log(msg, "WARNING")
				}
			}
			; in config file Autorun section
			autoruns := config["Autorun"]
			for _, program in autoruns
			{
				runProgram(program)
				msg := "启动配置项程序：" program
				log(msg)
			}
		}
	}
}

Suspend, Off
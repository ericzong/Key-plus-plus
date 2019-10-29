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
				FormatTime timestamp, %A_Now%, yyyy/MM/dd HH:mm:ss
				If (idx <> 1) {
					Run, %A_LoopFileFullPath%
					msg := "启动自启动链接："  A_LoopFileName "`n"
					FileAppend %timestamp% %msg%, Key++.log
				} else {
					msg := "禁用自启动链接："  A_LoopFileName "`n"
					FileAppend %timestamp% %msg%, Key++.log
				}
				; FileAppend %timestamp% %msg%, Key++.log
			}
			; in config file Autorun section
			autoruns := config["Autorun"]
			for _, program in autoruns
			{
				FormatTime timestamp, %A_Now%, yyyy/MM/dd HH:mm:ss
				runProgram(program)
				msg := "启动配置项程序：" program "`n"
				FileAppend %timestamp% %msg%, Key++.log
			}
		}
	}
}

Suspend, Off
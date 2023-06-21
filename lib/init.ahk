SetTimer(init,-5000)

return

init()
{ ; V1toV2: Added bracket
Suspend(true)

uptimeSeconds := getUptimeSeconds()
} ; V1toV2: Added bracket before function
if(uptimeSeconds < 600) { ; in 10min
	Loop 0 ; command line argument
	{
		param := %A_Index%
		If (param = "-startup") ; start autorun program
		{
			; in autorun folder
			Loop Files, "autorun\*.lnk", "R"
			{
				idx := InStr(A_LoopFileName, "~")
				If (idx <> 1) {
					Run(A_LoopFilePath)
					msg := "鍚姩鑷惎鍔ㄩ摼鎺ワ細"  A_LoopFileName
					
					log(msg)
				} else {
					msg := "绂佺敤鑷惎鍔ㄩ摼鎺ワ細"  A_LoopFileName
					
					log(msg, "WARNING")
				}
			}
			; in config file Autorun section
			autoruns := config["Autorun"]
			for _, program in autoruns
			{
				runProgram(program)
				msg := "鍚姩閰嶇疆椤圭▼搴忥細" program
				log(msg)
			}
		}
	}
}

Suspend(false)

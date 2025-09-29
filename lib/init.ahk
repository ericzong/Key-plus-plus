SetTimer(init,-5000)

return

init()
{
	Suspend(true)
	autorun()
	hotstringConfig()
	Suspend(false)
}

autorun()
{
	global writeLog
	Loop (A_Args.Length) ; command line argument
	{
		param := A_Index
		If (A_Args[param] = "-startup") ; start autorun program
		{
			; in autorun folder
			Loop Files, "autorun\*.lnk", "R"
			{
				idx := Instr(A_LoopFileName, "~")
				If (idx !== 1) {
					Run (A_LoopFileFullPath)
					msg := "启动自启动链接："  A_LoopFileName

					writeLog(msg)
				} else {
					msg := "禁用自启动链接："  A_LoopFileName

					writeLog(msg, "WARNING")
				}
			}
			; in config file Autorun section
			autoruns := config["Autorun"]
			for _, program in autoruns
			{
				runProgram(program)
				msg := "启动配置项程序：" program
				writeLog(msg)
			}
		}
	}
}

hotstringConfig()
{
	global writeLog
	hotstrings := config["Hotstring"]
	for h, s in hotstrings
	{
		if (RegExMatch(h, "^::.*"))
		{
			Hotstring(h, s)
		} else
		{
			writeLog("不支持的热字符串配置：" . h, "WARNING")
		}
	}
}
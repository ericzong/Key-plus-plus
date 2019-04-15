SetTimer, init, -3000

return

init:
Suspend, On

autoruns := config["Autorun"]

for _, program in autoruns
{
	runProgram(program)
}

Suspend, Off
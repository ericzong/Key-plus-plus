
global lastestPathes := Array()

savePath(dir, filepath := "")
{
	if(filepath)
	{
		if(RegExMatch(filepath, "[a-zA-Z]:") = 1)
		{
			path := filepath
		}
		else
		{
			path := dir "\" filepath
		}
	}
	else
	{
		if(DirExist(dir))
		{
			path := dir
		}
		else
		{
			return
		}
	}
	lastestPathes.InsertAt(1, path)
	lastestPathes.Capacity := 10
}

#HotIf WinActive("ahk_class #32770")  ; 文件对话框激活
!g::
{
	global fileDialogId := WinExist("A")
	; helpText := "最近使用"
	contextMenu := Menu()

	; contextMenu.Add(helpText, MenuHandler)
	; contextMenu.Disable(helpText)
	; contextMenu.Add

	for path in lastestPathes
	{
		contextMenu.Add(path, MenuHandler)
		contextMenu.setIcon(path, "shell32.dll", 44)
	}

	if(lastestPathes.Length > 0)
	{
		contextMenu.Default := lastestPathes[1]
	}

	ControlGetPos(&x, &y, &w, &h, "Edit1", "A")
	contextMenu.Show(x + w/2, y + h/2)
	contextMenu.Delete
}

!f::
{
	global fileDialogId := WinExist("A")
	SendInput("!d")
	Sleep 50
	dir := ControlGetText("Edit2", "A")
	path := ControlGetText("Edit1", "A")
	savePath(dir, path)
	ControlFocus("Edit1", "ahk_id" fileDialogId)
}

~!d::
{
	Sleep 50
	dir := ControlGetText("Edit2", "A")
	savePath(dir)
}

#HotIf

MenuHandler(ItemName, ItemPos, MyMenu)
{
	WinActivate("ahk_id" fileDialogId)
	ControlFocus("Edit1", "ahk_id" fileDialogId)
	ControlSetText(ItemName, "Edit1", "ahk_id" fileDialogId)
}

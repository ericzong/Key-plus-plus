
global lastestPathes := Array()  ; 记录路径的数组

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
{   ; 显示路径候选列表，并从中选择恢复
	ShowList(SelectMenuHandler)
}

!r::
{
	; 显示路径候选列表，并从中选择删除
	ShowList(RemoveMenuHandler)
}

!c::
{
	; 清空路径候选列表
	lastestPathes.Capacity := 0
}

!f::
{	; 收藏文件路径（如果有，否则为路径）
	global fileDialogId := WinExist("A")
	SendInput("!d")  ; Alt+D：激活地址栏
	; 地址栏平时显示的是面包屑路径，路径变更时，对应的地址栏文本框不会实时刷新
	; 所以，需要激活地址栏文本框，刷新路径
	; FAQ：Alt+D 快捷键可能被第三方应用劫持，可能导致路径获取错误
	Sleep 50
	dir := ControlGetText("Edit2", "A")  ; 地址栏文本框
	path := ControlGetText("Edit1", "A")  ; 文件名
	savePath(dir, path)
	ControlFocus("Edit1", "ahk_id" fileDialogId)
}

~!d::
{	; 收藏路径
	Sleep 50
	dir := ControlGetText("Edit2", "A")
	savePath(dir)
}

#HotIf

ShowList(handler)
{
	global fileDialogId := WinExist("A")
	contextMenu := Menu()

	; helpText := "最近使用"
	; contextMenu.Add(helpText, handler)
	; contextMenu.Disable(helpText)
	; contextMenu.Add

	for path in lastestPathes
	{
		contextMenu.Add(path, handler)
		contextMenu.setIcon(path, "shell32.dll", 44)
	}

	if(lastestPathes.Length > 0)
	{
		; 第1项是默认选项，标识粗体
		contextMenu.Default := lastestPathes[1]
	}

	; 路径候选列表，显示在文件名文本框中间位置
	ControlGetPos(&x, &y, &w, &h, "Edit1", "A")
	contextMenu.Show(x + w/2, y + h/2)
	contextMenu.Delete
}

SelectMenuHandler(ItemName, ItemPos, MyMenu)
{
	WinActivate("ahk_id" fileDialogId)
	ControlFocus("Edit1", "ahk_id" fileDialogId)
	ControlSetText(ItemName, "Edit1", "ahk_id" fileDialogId)
}

RemoveMenuHandler(ItemName, ItemPos, MyMenu)
{
	lastestPathes.RemoveAt(ItemPos)
}

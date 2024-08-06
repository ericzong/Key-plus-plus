; 【功能】系统文件对话框活动时，增加收藏、恢复路径等快捷键
; 【操作逻辑说明】
; 系统文件对话框地址栏平时显示的是面包屑路径，路径变更时，对应的地址栏文本框只在获得焦点时刷新
; 需要 Alt+D 快捷键激活地址栏文本框，刷新路径
; 【遗留问题】
; 1. Alt+D 快捷键可能被第三方应用劫持（无解）
; 2. 触发快捷键发送的上、下导航，不能选择弹出菜单

global lastestPathes := Array()  ; 记录路径的数组

global filenameText := "Edit1"
global dirText := "Edit2"

#HotIf WinActive("ahk_class #32770")  ; 文件对话框激活
!g::
{   ; 显示路径候选列表，并从中选择恢复
	ShowList(SelectMenuHandler)
}

!r::
{   ; 显示路径候选列表，并从中选择删除
	ShowList(RemoveMenuHandler)
}

!c::
{   ; 清空路径候选列表
	lastestPathes.Capacity := 0
}

!f::
{	; 收藏文件路径（如果有，否则为路径）
	dir := getDir()
	path := ControlGetText(filenameText, "A")  ; 文件名
	savePath(dir, path)
	ControlFocus(filenameText, "A")
}

~!d::
{	; 收藏路径
	dir := getDir()
	savePath(dir)
}

!t::
{
	MsgBox(ControlGetText(dirText, "A"))
}

#HotIf

ShowList(handler)
{
	global fileDialogId := WinExist("A")
	contextMenu := Menu()

	; helpText := "最近使用"
	; contextMenu.Add(helpText)
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
	ControlGetPos(&x, &y, &w, &h, filenameText, "A")
	contextMenu.Show(x + w/2, y + h/2)
	contextMenu.Delete
}

SelectMenuHandler(ItemName, ItemPos, MyMenu)
{
	if(RegExMatch(ItemName, "[a-zA-Z]:") = 0)
	{  ; 非常规路径
		paths := StrSplit(ItemName, '\',, 2)
		dir := paths[1]

		SendInput("!d")
		Sleep 50
		ControlSetText(dir, dirText, "A")
		ControlFocus(dirText, "A")
		ControlSend("{Enter}", dirText, "A")

		if(paths.length = 2)
		{
			path := paths[2]
			ControlFocus(filenameText, "A")
			ControlSetText(path, filenameText, "A")
		}
	}
	else
	{
		ControlFocus(filenameText, "A")
		ControlSetText(ItemName, filenameText, "A")
	}
}

RemoveMenuHandler(ItemName, ItemPos, MyMenu)
{
	lastestPathes.RemoveAt(ItemPos)
}

getDir()  ; 从地址栏获取目录地址
{
	SendInput("!d")
	Sleep 50
	dir := ControlGetText(dirText, "A")
	return dir
}

savePath(dir, filepath := "")
{
	dir := RTrim(dir, "\")  ; 目录统一去掉尾 \，要拼路径时统一加
	if(filepath)
	{
		filepath := "\" . filepath
	}
	path := dir . filepath
	lastestPathes.InsertAt(1, path)
	lastestPathes.Capacity := 10
}

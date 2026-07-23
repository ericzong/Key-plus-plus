; 【功能】系统文件对话框活动时，增加收藏、恢复路径等快捷键
; 【操作逻辑说明】
; 1. 地址栏说明
; 系统文件对话框地址栏平时显示的是面包屑路径，路径变更时，对应的地址栏文本框只在获得焦点时刷新
; 需要 Alt+D 快捷键激活地址栏文本框，刷新路径
; 使用 ControlSend 直接向对话框窗口发送按键消息，避免被第三方全局键盘钩子拦截
; 【遗留问题】
; 2. 用自定义 GUI（ListBox）替代 Menu.Show()
; Menu.Show() 是阻塞调用，会暂停脚本，导致 #HotIf isCapsLockPressed 热键无法触发。
; 用 GUI，脚本不阻塞，CapsLock+j/k 发送的 {Up}/{Down} 会自然作用于 ListBox。

global lastestPathes := Array()  ; 记录路径的数组

global filenameText := "Edit1"
global dirText := "Edit2"

global pathListGui := ""      ; 路径候选列表 GUI
global pathListBox := ""      ; GUI 中的 ListBox 控件
global pathListHandler := ""  ; 当前列表项选中后的回调函数名
global pathListGuiHwnd := 0   ; 路径候选列表 GUI 窗口句柄
global pathListTimerObj := "" ; 焦点检测定时器回调对象

#HotIf IsFileDialog()  ; 精确识别文件对话框
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
{	; 收藏文件路径（附带文件名）
	dir := getDir()  ; 向对话框发送 Alt+D 激活地址栏，读取目录
	path := ControlGetText(filenameText, "A")  ; 文件名
	savePath(dir, path)
	ControlFocus(filenameText, "A")
}

~!d::
{	; 收藏路径（Alt+D 通过 ~ 前缀透传到对话框，激活地址栏）
	dir := getDir()
	savePath(dir)
}

!t::
{
	MsgBox(ControlGetText(dirText, "A"))
}

#HotIf

; 路径候选列表激活时，回车键确认选择
#HotIf IsPathListActive()
Enter::PathListConfirm()
#HotIf

; 精确判断是否为系统文件对话框
; 通过检查标准的文件对话框控件来避免误识别
IsFileDialog()
{
    ; 1. 窗口类必须是标准对话框类
    if !WinActive("ahk_class #32770")
        return false

    try
    {
        ; 2. 检查文件对话框的标志性控件是否存在
        ;    Edit1 = 文件名输入框, Edit2 = 路径输入框
        ;    ！！！对于没有 Customize 按钮的旧版对话框，可能没有 Edit2，所以 Edit1 更可靠
        if ControlGetHwnd("Edit1", "A")
            return true
    }
    catch
    {
        return false
    }

    return false
}

ClosePathList(*)
{
	global pathListGui, pathListBox, pathListHandler, pathListGuiHwnd, pathListTimerObj
	; 停止焦点检测定时器
	try {
		if (pathListTimerObj)
			SetTimer(pathListTimerObj, 0)
	} catch {
		; ignore timer stop failure
	}
	pathListTimerObj := ""
	pathListGuiHwnd := 0
	pathListHandler := ""
	pathListBox := ""
	try pathListGui.Destroy()
	pathListGui := ""
}

; 定时器回调：检测路径候选列表 GUI 是否失去焦点，若失去则自动关闭
CheckPathListFocus()
{
	global pathListGuiHwnd, pathListTimerObj
	if (!pathListGuiHwnd)
		return

	try {
		if (!WinExist("ahk_id " pathListGuiHwnd)) {
			pathListGuiHwnd := 0
			pathListTimerObj := ""
			return
		}
	} catch {
		return
	}

	try {
		activeId := WinGetID("A")
	} catch {
		activeId := 0
	}

	; 活动窗口仍是 GUI 时不关闭
	if (activeId = pathListGuiHwnd)
		return

	ClosePathList()
}

ShowList(handler)
{
	global pathListGui, pathListBox, pathListHandler, pathListGuiHwnd, pathListTimerObj, fileDialogId

	; 如果已有路径候选列表 GUI，先关闭
	ClosePathList()

	fileDialogId := WinExist("A")
	pathListHandler := handler

	count := lastestPathes.Length
	if count = 0
		return

	; 获取对话框文件名文本框位置，用于计算 GUI 显示位置
	ControlGetPos(&x, &y, &w, &h, filenameText, "ahk_id " fileDialogId)
	WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " fileDialogId)

	guiWidth := 400
	maxVisible := 20
	visibleCount := Min(count, maxVisible)
	guiHeight := visibleCount * 20 + 10

	guiX := winX + x + w/2 - guiWidth/2
	guiY := winY + y + h/2 - guiHeight/2

	; 创建 GUI（非阻塞，脚本继续运行，因此 #HotIf isCapsLockPressed 热键仍可触发）
	pathListGui := Gui("+AlwaysOnTop +ToolWindow -Caption +Border +Theme +Owner" fileDialogId, "路径候选列表")
	pathListGui.MarginX := 0
	pathListGui.MarginY := 0
	pathListGui.BackColor := "White"

	; 创建 ListBox
	pathListBox := pathListGui.Add("ListBox", "r" visibleCount " w" guiWidth " Choose1", lastestPathes)

	; 事件绑定
	pathListBox.OnEvent("DoubleClick", PathListSelect)
	pathListGui.OnEvent("Escape", ClosePathList)
	pathListGui.OnEvent("Close", ClosePathList)

	; 显示 GUI 并激活（让 ListBox 获得焦点，自然接收 CapsLock+j/k 发送的 {Up}/{Down}）
	pathListGui.Show("x" guiX " y" guiY)
	pathListGuiHwnd := pathListGui.Hwnd
	pathListBox.Focus()

	; 启动焦点检测定时器（LoseFocus 事件在 +Owner 模式下不触发，改用轮询）
	SetTimer(CheckPathListFocus, 200)
	pathListTimerObj := CheckPathListFocus
}

PathListSelect(GuiObj, Info)
{
	global pathListBox, pathListHandler, fileDialogId, lastestPathes

	if !pathListHandler || !pathListBox
		return

	selected := pathListBox.Text
	selIndex := pathListBox.Value
	if !selected
		return

	handler := pathListHandler
	ClosePathList()

	; 激活文件对话框，确保后续 ControlSend 能正确操作
	WinActivate("ahk_id " fileDialogId)
	Sleep 50

	handler(selected, selIndex, "")
}

; 供 function.ahk 中 key_enter() 调用，确认路径候选列表的选择
PathListConfirm()
{
	global pathListBox, pathListHandler, fileDialogId, lastestPathes

	if !pathListHandler || !pathListBox
		return

	selected := pathListBox.Text
	selIndex := pathListBox.Value
	if !selected
		return

	handler := pathListHandler
	ClosePathList()

	WinActivate("ahk_id " fileDialogId)
	Sleep 50

	handler(selected, selIndex, "")
}

; 供 function.ahk 中 key_enter() 调用，检测路径候选列表是否激活
IsPathListActive()
{
	global pathListGui
	return pathListGui != "" && WinExist("ahk_id " pathListGui.Hwnd)
}

SelectMenuHandler(ItemName, ItemPos, MyMenu)
{
	if(RegExMatch(ItemName, "[a-zA-Z]:") = 0)
	{  ; 非常规路径
		paths := StrSplit(ItemName, '\',, 2)
		dir := paths[1]

		; 使用 ControlSend 代替 SendInput，避免被第三方全局键盘钩子拦截
		ControlSend("!d", , "A")
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
	; 使用 ControlSend 代替 SendInput，直接发送窗口消息，
	; 避免被第三方全局键盘钩子拦截
	ControlSend("!d", , "A")
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

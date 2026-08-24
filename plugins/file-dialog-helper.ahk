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
	try {
		; 注意：Array 没有 Clear 方法（那是 Map 的），需循环移除全部元素
		while (lastestPathes.Length > 0)
			lastestPathes.RemoveAt(lastestPathes.Length)
		persistSavedPaths()
	} catch Error as err {
		LogError("Alt+C 清空路径候选列表", err)
	}
}

!f::
{	; 收藏文件路径（附带文件名）
	try {
		dir := getDir()  ; 向对话框发送 Alt+D 激活地址栏，读取目录
		path := ControlGetText(filenameText, "A")  ; 文件名
		savePath(dir, path)
		ControlFocus(filenameText, "A")
	} catch Error as err {
		LogError("Alt+F 收藏文件路径", err)
	}
}

~!d::
{	; 收藏路径（Alt+D 通过 ~ 前缀透传到对话框，激活地址栏）
	try {
		dir := getDir()
		savePath(dir)
	} catch Error as err {
		LogError("Alt+D 收藏路径", err)
	}
}

!t::
{
	try {
		MsgBox(ControlGetText(dirText, "A"))
	} catch Error as err {
		LogError("Alt+T 读取路径", err)
	}
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
	if (pathListGui != "") {
		try {
			pathListGui.Destroy()
		} catch {
			; ignore destroy failure
		}
	}
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

	count := lastestPathes.Length
	if count = 0
		return

	fileDialogId := WinExist("A")
	pathListHandler := handler

	; 获取对话框文件名文本框位置，用于计算 GUI 显示位置
	try {
		ControlGetPos(&x, &y, &w, &h, filenameText, "ahk_id " fileDialogId)
		WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " fileDialogId)
	} catch Error as err {
		; 对话框可能已关闭或控件不可用，无需继续
		LogError("ShowList 定位控件", err)
		pathListHandler := ""
		return
	}

	guiWidth := 400
	maxVisible := 20
	visibleCount := Min(count, maxVisible)
	guiHeight := visibleCount * 20 + 10

	guiX := winX + x + w/2 - guiWidth/2
	guiY := winY + y + h/2 - guiHeight/2

	; 创建 GUI（非阻塞，脚本继续运行，因此 #HotIf isCapsLockPressed 热键仍可触发）
	try {
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
	} catch Error as err {
		LogError("ShowList 创建 GUI", err)
		ClosePathList()
	}
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
	try {
		WinActivate("ahk_id " fileDialogId)
		Sleep 50
		handler(selected, selIndex, "")
	} catch Error as err {
		LogError('选择路径 "' selected '"', err)
	}
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

	try {
		WinActivate("ahk_id " fileDialogId)
		Sleep 50
		handler(selected, selIndex, "")
	} catch Error as err {
		LogError('确认路径 "' selected '"', err)
	}
}

; 供 function.ahk 中 key_enter() 调用，检测路径候选列表是否激活
IsPathListActive()
{
	global pathListGui, pathListGuiHwnd
	; 直接使用句柄判断，避免访问已销毁 GUI 的 Hwnd 属性时抛错
	return pathListGuiHwnd != 0 && WinExist("ahk_id " pathListGuiHwnd)
}

SelectMenuHandler(ItemName, ItemPos, MyMenu)
{
	try {
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
	} catch Error as err {
		LogError('选择路径 "' ItemName '"', err)
	}
}

RemoveMenuHandler(ItemName, ItemPos, MyMenu)
{
	try {
		if (ItemPos >= 1 && ItemPos <= lastestPathes.Length)
			lastestPathes.RemoveAt(ItemPos)
		persistSavedPaths()
	} catch Error as err {
		LogError("删除路径候选", err)
	}
}

getDir()  ; 从地址栏获取目录地址
{
	; 使用 ControlSend 代替 SendInput，直接发送窗口消息，
	; 避免被第三方全局键盘钩子拦截
	try {
		ControlSend("!d", , "A")
		Sleep 50
		dir := ControlGetText(dirText, "A")
		return dir
	} catch Error as err {
		writeLog("getDir 读取目录失败：" err.Message, "ERROR")
		return ""
	}
}

savePath(dir, filepath := "")
{
	; 输入校验：目录为空、不含盘符时直接忽略
	if (!dir || !RegExMatch(dir, "^[a-zA-Z]:"))
	{
		writeLog("忽略无效路径收藏：" (dir ? dir : "(空)"), "WARNING")
		return
	}

	dir := RTrim(dir, "\")  ; 目录统一去掉尾 \，要拼路径时统一加
	if(filepath)
	{
		filepath := "\" . filepath
	}
	path := dir . filepath

	; 去重：已存在相同路径时，移除旧项再插入到最前
	; 注意：Array 没有 IndexOf 方法（那是 Map 的），需手动循环查找
	dupIndex := 0
	for idx, item in lastestPathes
	{
		if (item = path)
		{
			dupIndex := idx
			break
		}
	}
	if (dupIndex)
		lastestPathes.RemoveAt(dupIndex)

	; 限制容量：超出上限时删除最旧的一项
	if (lastestPathes.Length >= 10)
		lastestPathes.RemoveAt(lastestPathes.Length)

	lastestPathes.InsertAt(1, path)
	try {
		persistSavedPaths()
	} catch Error as err {
		writeLog("保存路径失败：" err.Message, "ERROR")
	}
}

; 统一错误记录：日志 + 非静默失败时弹窗提示
LogError(action, err)
{
	global writeLog
	writeLog(action "失败：" err.File "(" err.Line ") " err.Message, "ERROR")
	if (err.Message = "Control") ; 控件不存在等环境问题，静默记录即可
		return
	ToolTip(action "失败：" err.Message, 0, 0)
	SetTimer(() => ToolTip(), -3000)
}

; 从 config.ini 加载已保存的路径到 lastestPathes
loadSavedPaths()
{
	global lastestPathes
	try {
		; 清空现有数组
		while (lastestPathes.Length > 0)
			lastestPathes.RemoveAt(lastestPathes.Length)
		; 按序号读取（最多10条）
		Loop 10
		{
			val := IniRead("config\config.ini", "plugin.file-dialog-helper.paths", A_Index, "")
			if (val)
				lastestPathes.Push(val)
		}
	} catch Error as err {
		writeLog("loadSavedPaths 读取配置失败：" err.Message, "ERROR")
	}
}

; 将 lastestPathes 全量写入 config.ini
persistSavedPaths()
{
	global lastestPathes
	try {
		; 先清除旧数据（1~10）
		Loop 10
			IniWrite("", "config\config.ini", "plugin.file-dialog-helper.paths", A_Index)
		; 写入当前数据
		for idx, path in lastestPathes
			IniWrite(path, "config\config.ini", "plugin.file-dialog-helper.paths", idx)
	} catch Error as err {
		writeLog("persistSavedPaths 写入配置失败：" err.Message, "ERROR")
	}
}

; 插件加载时自动从 config.ini 恢复已保存的路径
loadSavedPaths()

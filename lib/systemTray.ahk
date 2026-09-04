Tray:= A_TrayMenu
Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning ; 删除托盘标准菜单
try {
    TraySetIcon("ico\hotkey.ico")
} catch Error as err {
    writeLog("设置托盘图标失败：" err.Message, "ERROR")
}
A_IconTip := productionName . " `n  v" . version
SetTimer(ShowStartupTip, -2000) ; 延迟显示，确保初始化完成
addMenus()

;PauseHandler(ItemName, ItemPos, MyMenu) {
;	pauseScript()
;}

SuspendHandler(ItemName, ItemPos, MyMenu) {
	suspendScript()
}

EditHandler(ItemName, ItemPos, MyMenu) {
	editScript()
}

ReloadHandler(ItemName, ItemPos, MyMenu) {
	reloadScript()
}

OpenAutorunHandler(ItemName, ItemPos, MyMenu) {
	autorunFolder := rootDir . "\autorun"
	openDir(autorunFolder)
}

ExitHandler(ItemName, ItemPos, MyMenu) {
	destroyHud()
	exitScript()
}

ShowStartupTip()
{
    ; Windows 10+ 管理员权限下 TrayTip 不可靠，使用自定义 GUI 通知
    ShowTrayNotification(productionName, "已启动  v" . version)
}

ShowTrayNotification(Title, Text, Duration := 5)
{
    ; 在屏幕右下角系统托盘区域创建一个半透明通知弹窗
    try {
        notif := Gui("+AlwaysOnTop -Caption +ToolWindow +Border -SysMenu +DPIScale")
        notif.BackColor := "F5F5F5"
        notif.SetFont("s10 w700", "Segoe UI")
        notif.AddText("x12 y8 w240 h24", Title)
        notif.SetFont("s9 w400", "Segoe UI")
        notif.AddText("x12 y34 w240 h28", Text)
        notif.Show("x" . A_ScreenWidth - 290 . " y" . A_ScreenHeight - 180 . " w264 h70")
        notif.Opt("+LastFound")
        WinSetTransparent(200) ; 200/255 ≈ 80% 透明度

        ; 2秒后开始淡出
        SetTimer((*) => FadeOutNotification(notif), -2000)
    } catch Error as err {
        writeLog("显示启动通知失败：" err.Message, "ERROR")
    }
}

FadeOutNotification(notif)
{
    loop 12
    {
        try {
            WinSetTransparent(255 - (A_Index * 20), notif.Hwnd)
        } catch {
            ; GUI 已被用户关闭，停止淡出
            break
        }
        Sleep 30
    }
    try {
        notif.Destroy()
    } catch {
        ; ignore destroy failure
    }
}

addMenus()
{
	global
	try {
		;Tray.Add(lang_tray_item_pause, PauseHandler)
		Tray.Add(lang_tray_item_suspend, SuspendHandler)
		Tray.Add()
		Tray.Add(lang_tray_item_edit, EditHandler)
		Tray.Add(lang_tray_item_reload, ReloadHandler)
		Tray.Add()
		Tray.Add(lang_tray_item_open_autorun, OpenAutorunHandler)
		Tray.Add()
		Tray.Add(lang_tray_item_exit, ExitHandler)
	} catch Error as err {
		writeLog("添加托盘菜单失败：" err.Message, "ERROR")
	}
}
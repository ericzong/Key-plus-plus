Tray:= A_TrayMenu
Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning ; 删除托盘标准菜单
TraySetIcon("ico\hotkey.ico")
A_IconTip := productionName . " `n  v" . version
SetTimer(ShowStartupTip, -2000) ; 延迟显示，确保初始化完成
addMenus()

ShowStartupTip()
{
    ; Windows 10+ 管理员权限下 TrayTip 不可靠，使用自定义 GUI 通知
    ShowTrayNotification(productionName, "已启动  v" . version)
}

ShowTrayNotification(Title, Text, Duration := 5)
{
    ; 在屏幕右下角系统托盘区域创建一个半透明通知弹窗
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
}

FadeOutNotification(notif)
{
    loop 12
    {
        WinSetTransparent(255 - (A_Index * 20), notif.Hwnd)
        Sleep 30
    }
    notif.Destroy()
}

addMenus()
{
	global
	;Tray.Add(lang_tray_item_pause, PauseHandler)
	Tray.Add(lang_tray_item_suspend, SuspendHandler)
	Tray.Add()
	Tray.Add(lang_tray_item_edit, EditHandler)
	Tray.Add(lang_tray_item_reload, ReloadHandler)
	Tray.Add()
	Tray.Add(lang_tray_item_open_autorun, OpenAutorunHandler)
	Tray.Add()
	Tray.Add(lang_tray_item_exit, ExitHandler)
}
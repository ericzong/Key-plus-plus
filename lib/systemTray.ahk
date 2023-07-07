Tray:= A_TrayMenu
Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning ; 删除托盘标准菜单
TrayTip(productionName, version, 1) ; 10s消失，显示信息图标
A_IconTip := productionName . " v" . version
TraySetIcon("ico\hotkey.ico")
addMenus()

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
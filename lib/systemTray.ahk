Tray:= A_TrayMenu
Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning ; 鍒犻櫎鎵樼洏鏍囧噯鑿滃崟
TrayTip(productionName, version, 1) ; 10s娑堝け锛屾樉绀轰俊鎭浘鏍?
Tray.Tip(productionName)
Tray.Icon("hotkey.png")

Tray.Add(lang_tray_item_pause, PauseHandler)
Tray.Add(lang_tray_item_suspend, SuspendHandler)
Tray.Add()
Tray.Add(lang_tray_item_edit, EditHandler)
Tray.Add(lang_tray_item_reload, ReloadHandler)
Tray.Add()
Tray.Add(lang_tray_item_open_autorun, OpenAutorunHandler)
Tray.Add()
Tray.Add(lang_tray_item_exit, ExitHandler)

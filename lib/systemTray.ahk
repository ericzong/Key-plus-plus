Menu, Tray, NoStandard ; 删除托盘标准菜单
TrayTip, %productionName%, %version%, 10, 1 ; 10s消失，显示信息图标
Menu, Tray, Tip, %productionName%
Menu, Tray, Icon, hotkey.png

Menu, Tray, Add, %lang_tray_item_pause%, PauseHandler
Menu, Tray, Add, %lang_tray_item_suspend%, SuspendHandler
Menu, Tray, Add
Menu, Tray, Add, %lang_tray_item_edit%, EditHandler
Menu, Tray, Add, %lang_tray_item_reload%, ReloadHandler
Menu, Tray, Add
Menu, Tray, Add, %lang_tray_item_exit%, ExitHandler

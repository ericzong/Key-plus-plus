
#Requires AutoHotkey v2.0
err_msg := ''
try {
    gui := Gui('+AlwaysOnTop -Caption +ToolWindow')
    gui.BackColor := '1a1b26'
    gui.SetFont('s20 w700 c7aa2f7', 'Segoe UI')
    gui.AddText('v hudText', 'test')
    gui.Show('Hide')
} catch Error as err {
    err_msg := err.Message
}
FileAppend(err_msg, 'test_error.txt')
ExitApp()

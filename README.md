# 概述

[Key++](https://github.com/ericzong/Key-plus-plus) 是一个基于 `Capslock` 键的快捷键效率工具。它可以让你在任意的编辑器中感受到类似 `vim` 的编辑体验，尽管它的功能不仅限于编辑器中。

# 快捷键

Key++ 使用 `Capslock` 键作为快捷键掩码，因此，它会“几乎无感”地影响 `Capslock` 的功能。

当短按（0.2 秒内）`Capslock` 时，依然是切换大小写功能；长按松开将不会执行任何操作，除非同时按下了下面定义的快捷键：

| 快捷键                       | 功能                             | 说明                                                         |
| ---------------------------- | -------------------------------- | ------------------------------------------------------------ |
| `ESC`                        | 退出脚本                         |                                                              |
| `F2`                         | 编辑主脚本                       | 如果配置文件中有指定 SciTE4AutoHotkey 编辑器的路径，则会使用它；<br>否则，尝试使用 notepad++；<br>否则，使用记事本。<br>仅从源代码运行时可编辑主脚本，另见 [运行源代码](#运行源代码) 部分。 |
| `F5`                         | 重新加载脚本，即重启             |                                                              |
| `b`                          | Backspace                        |                                                              |
| `Ctrl`+`b`                   | 删除光标左侧的单词               | 等效于 `Ctrl` + `Backspace`                                  |
| `d`                          | 删除当前行                       |                                                              |
| `x`                          | Delete                           |                                                              |
| `Ctrl`+`x`                   | 删除光标右侧的单词               | 等效于 `Ctrl` + `Del`                                        |
| `h`                          | 左移                             | 支持加 `Ctrl`、`Alt`、`Shift` 以及加三者两两组合             |
| `j`                          | 下移                             | 支持加 `Ctrl`、`Alt`、`Shift` 以及加三者两两组合             |
| `k`                          | 上移                             | 支持加 `Ctrl`、`Alt`、`Shift` 以及加三者两两组合             |
| `l`                          | 右移                             | 支持加 `Ctrl`、`Alt`、`Shift` 以及加三者两两组合             |
| `u`                          | 左移一个“单词”                   |                                                              |
| `p`                          | 右移一个“单词”                   |                                                              |
| `y`                          | 转到行首                         | `Home`                                                       |
| `;`                          | 转到行尾                         | `End`                                                        |
| `Shift`+`h`                  | 向左选择一个字符                 |                                                              |
| `Shift`+`l`                  | 向右选择一个字符                 |                                                              |
| `Shift` + `j`                | 向下选择一行                     | 等效于 `Shift` + `↓`                                         |
| `Shift` + `k`                | 向上选择一行                     | 等效于 `Shift` + `↑`                                         |
| `Shift`+`u`                  | 向左选择一个“单词”               |                                                              |
| `Shift`+`p`                  | 向右选择一个“单词”               |                                                              |
| `Shift`+`y`                  | 向左选择到行首                   |                                                              |
| `Shift`+`;`                  | 向右选择到行尾                   |                                                              |
| `Enter`                      | 任意位置换行                     |                                                              |
| `Shift`+`,`                  | 当前选择文本两边加尖括号         | \<text\>                                                     |
| `Shift`+`9`                  | 当前选择文本两边加圆括号         | (text)                                                       |
| `[`                          | 当前选择文本两边加方括号         | [text]                                                       |
| `Shift`+`[`                  | 当前选择文本两边加花括号         | {text}                                                       |
| `'`                          | 当前选择文本两边加单引号         | 'text'                                                       |
| `Shift`+`'`                  | 当前选择文本两边加双引号         | "text"                                                       |
| <code>&#96;</code>           | 当前选择文本两边加重音号         | "&#96;text&#96;"                                             |
| `Ctrl`+`1`~`5`               | 将当前活动窗口存储在相应的索引下 | 注意：显然，这会跳过桌面                                     |
| `1`~`5`                      | 激活相应索引中存储的窗口         | 注意：当存储的窗口已关闭，或是隐藏（比如，最小化到托盘），那么，该窗口通常不能被激活。 |
| `Ctrl` + `F5`                | 多媒体暂停/播放                  |                                                              |
| `Ctrl` + `↑`                 | 音量 +                           |                                                              |
| `Ctrl` + `↓`                 | 音量 -                           |                                                              |
| `Ctrl` + `←`                 | 多媒体上一首                     |                                                              |
| `Ctrl` + `→`                 | 多媒体下一首                     |                                                              |
| `w`                          | 隐藏当前活动窗口                 |                                                              |
| `Alt` + `w`                  | 显示隐藏窗口列表                 | 鼠标双击或按 `Enter` 键显示隐藏的窗口（注：如果没有隐藏窗口则无任何响应） |
| `Shift` + `w`                | 显示所有隐藏窗口                 |                                                              |
| `Ctrl` + `Shift` + `Alt` + n | 切换小键盘锁定开关               | 初始关闭。开启后会映射以下键位：j(1), k(2), l(3), u(4), i(5), o(6), n(0), ,(×), m(÷) |

# 配置

Key++ 的配置文件位于 `<Key++>/config/config.ini`，其内容大致如下：

```ini
[Ext]
editor=path/to/SciTE4AutoHotkey

[Autorun]
aName=path/to/startfile
```

`editor` ：指定了 SciTE4AutoHotkey 编辑器的路径，用以编辑脚本文件。注意：仅从源代码运行时可编辑主脚本，另见 [运行源代码](#运行源代码) 部分。

`[Autorun]`：用以配置自启动的程序（后续章节介绍）。其下的配置项名称是任意的。

> 注意：不要任意改变配置文件结构，这可能导致程序错误。

# 自启动

## 随系统启动Key++

你可以使用 Key++ 来管理随系统启动的程序，而只需要让 Key++ 随系统启动即可。简单地说，你需要创建一个快捷方式，其“目标”属性如下：

```
path\to\AutoHotkeyU64.exe path\to\Key++.ahk -startup
```

然后，将该快捷方式放在启动目录 `C:\Users\用户名\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\` 下，这样就能实现 Key++ 自启动了。

## 配置启动项

配置自启动程序有两处地方，一则是上文提及的 `config.ini` 文件的 `[Autorun]` 部分；另一处则是 `<Key++>/autorun` 目录，可将需要自启动的程序的快捷方式放在该目录下。这样，就可以实现程序自启动。

> `[Autorun]` 配置目前只支持直接可执行的文件，比如 .exe 文件。而 `autorun` 目录放置快捷方式就灵活很多，只要是合法的快捷方式都可以正确执行——而且优先于 `[Autorun]` 配置启动。

## 临时禁用

有时，我们会想临时禁用 `autorun` 文件夹下某个链接的自启，但又不想删除或移动备份该链接以方便稍后恢复。这时，只需要将链接文件名添加 `~` 前缀，则可以跳过自启了。

# 运行源代码

Key++ 程序使用 [Autohotkey](https://www.autohotkey.com/) 编写，因此，如果想要直接从源代码运行需要先安装 Autohotkey，然后执行根目录下的 `Key++.ahk` 文件来启动 Key++ 即可。

如果你会使用 Autohotkey 编写脚本，并想修改或加强 Key++ 的功能，可以直接运行源代码。否则，建议下载发布的可执行文件版本进行使用。

> 当你运行源代码启动 Key++ 时，从上文说明中可知，`F2` 快捷键此时可用，可以快速打开主脚本进行编辑，并且还支持配置脚本编辑器。

# 附录

## 关于启动链接

对于启动程序而言，如果仅是单纯地执行其 `.exe` 文件，那么很可能在启动时会弹出一大堆窗口。

为了能“静默”地启动，大多数应用都提供了相应的参数，下面列举几种常用的应用程序的启动参数：

```powershell
# OneDrive 后台启动
.../OneDrive.exe /background
# Free Download Manager 最小化启动
.../fdm.exe --minimized
```

# FAQ

## Key++ 无法自启动

将 Key++ 的快捷方式置于启动目录，以使 Key++ 自启动，这在 Win7 下通常是有效的。

但是，在 Win10 下，某些情况会导致 Key++ 不能自启动。这时，我们需要将 Key++ 配置到自启相关的注册表项。

不过，经过实验，也并非所有的自启注册表项都有效，目前看来下面的配置是最保险的：

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run]
"Key++"="\"X:\\path\\to\\Key++.exe\" -startup"
```

> 将以上脚本拷贝到一个纯文本文件中（记得改 Key++ 的路径），并将文件保存为 `.reg` 后缀，双击合并入注册表即可。


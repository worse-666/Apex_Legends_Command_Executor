#NoEnv
#SingleInstance, Force
#Persistent
#KeyHistory, 0
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
SetBatchLines,-1
ListLines, Off



Gui, SettingGui:Font, s18 cBABABA, System
Gui, SettingGui:Color, 0x101114
Gui, SettingGui:Add, Tab3, x0 y0 w500 h500 gFocus_Edit vTab_Name, Console|Misc
Gui, SettingGui:Font, s20 cBABABA

Gui, SettingGui:Tab, Console
Gui, SettingGui:Add, Edit, cBABABA ReadOnly r25 w450 vEdit_console_log
Gui, SettingGui:Add, Edit, c101114 WantReturn r1 w392 vEdit_str
Gui, SettingGui:Add, Button, Default h24 x+0 gButton_Enter, Enter

Gui, SettingGui:Tab, Misc
Gui, SettingGui:Add, Button, -Default w220 Section gButton_cl_showpos, cl_showpos
Gui, SettingGui:Add, Button, -Default w220 x+10 gButton_cl_showfps, cl_showfps
Gui, SettingGui:Add, Button, -Default w220 xs gButton_shownet_enabled, shownet_enabled
Gui, SettingGui:Add, Button, -Default w220 x+10 gButton_Disconnect, Disconnect
Gui, SettingGui:Add, Checkbox, xs gSubmit vCheckbox_Spam_Ping, Spam Ping


Gui, SettingGui:Show, x480 y270 w500 h500, Apex Legends Command Executor
ControlFocus, Edit2, Apex Legends Command Executor



ExecuteConsoleCommand(ByRef str) {
    length := StrLen(str)
    VarSetCapacity(m_pCommand, length, 0)
    Loop % length {
        NumPut(Asc(SubStr(str, A_Index, 1)), m_pCommand, A_Index-1, "char")
    }
    VarSetCapacity(COPYDATASTRUCT, 0x24, 0)
    NumPut(0, COPYDATASTRUCT, 0x0, "ptr")
    NumPut(length * 2 + 1, COPYDATASTRUCT, 0x8, "ptr")
    NumPut(&m_pCommand, COPYDATASTRUCT, 0x10, "ptr")
    SendMessage, 0x004A,, &COPYDATASTRUCT,, ahk_exe r5apex.exe
    return ErrorLevel = "FAIL" ? :true
}

Loop {
    if (Checkbox_Spam_Ping) {
        ExecuteConsoleCommand("ping_specific_type ENEMY; ping_specific_type LOOTING")
        ExecuteConsoleCommand("ping_specific_type LOOTING; ping_specific_type GOING")
        ExecuteConsoleCommand("ping_specific_type GOING; ping_specific_type DEFENDING")
        ExecuteConsoleCommand("ping_specific_type DEFENDING; ping_specific_type WATCHING")
        ExecuteConsoleCommand("ping_specific_type WATCHING; ping_specific_type ENEMY")
    }
    DllCall("Sleep", "int", 1)
}


Focus_Edit: 
Gui, SettingGui:Submit, NoHide
if (Tab_Name = "Console") { 
    ControlFocus, Edit2, Apex Legends Command Executor 
} 
Return

Button_cl_showpos:
ExecuteConsoleCommand("toggle cl_showpos 1 0")
return

Button_cl_showfps:
ExecuteConsoleCommand("toggle cl_showfps 1 0")
return

Button_shownet_enabled:
ExecuteConsoleCommand("toggle shownet_enabled 2 1 0")
return

Button_Disconnect:
ExecuteConsoleCommand("disconnect")
return

Submit:
Gui, SettingGui:Submit, NoHide
return

Button_Enter:
Gui, SettingGui:Submit, NoHide
if (Edit_str = "")
    return
result := ExecuteConsoleCommand(Edit_str)
GuiControl, SettingGui:, Edit_console_log, % Edit_console_log . "`n" . (result ? Edit_str:"Execution failed!")
ControlSend, Edit1, ^{END}, Apex Legends Command Executor
GuiControl, SettingGui:, Edit_str,
return




SettingGuiGuiClose:
Exitapp
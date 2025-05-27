#Requires AutoHotkey v2.0

^!v::{
    Send('{Ctrl up}{Alt up}')
    Sleep 50
    SendEvent('{Text}' A_Clipboard)
}

^!Enter::{
    Send('{Ctrl up}{Alt up}')
    Sleep 50
    SendEvent('{Text}' A_Clipboard)
    Send('{Enter}')
}
#Requires AutoHotkey v2.0

clicking := false

F6::
{
    global clicking  ; Declare the global variable inside the function
    clicking := !clicking
    if clicking {
        SetTimer ClickLoop, 10
    } else {
        SetTimer ClickLoop, 0
    }
}

ClickLoop() {
    Click
}

Esc::ExitApp
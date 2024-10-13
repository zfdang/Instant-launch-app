#Requires AutoHotkey v2.0


; Use Shift+CapsLock to toggle CapsLock on and off 
+CapsLock::CapsLock
; Remap CapsLock to HyperKey; 
CapsLock::
{
    SetKeyDelay(-1)
    Send("{Blind}{Ctrl DownR}{Alt DownR}{Shift DownR}")
}
CapsLock UP::
{
    SetKeyDelay(-1)
    Send("{Blind}{Shift Up}{Alt Up}{Ctrl Up}")
}


; 2.1 Open / Show / Hide App based on AppAddress: the address to the .exe (Eg: "C:\Windows\System32\SnippingTool.exe")

OpenOrShowOrHideAppBasedOnExeName(AppAddress)
{
    AppExeName := SubStr(AppAddress, InStr(AppAddress, "\", false, -1) + 1)

    if WinExist("ahk_exe " . AppExeName)
    {
        if WinActive("ahk_exe " . AppExeName)
        {
            WinMinimize
            Return
        } else {
            WinActivate
            Return
        }
    }
    else
    {
        try
            Run(AppAddress)
        catch
            MsgBox("App " . AppAddress . " does not exist.")
        return
    }
}

; 2.2 Open / Show / Hide App based on AppClass: AHK CLASS (Eg: "CabinetWClass")

OpenOrShowOrHideAppBasedOnClass(AppClass)
{
    if WinExist("ahk_class " . AppClass)
    {
        if WinActive("ahk_class " . AppClass)
        {
            WinMinimize
            Return
        } else {
            WinActivate
            Return
        }
    }
    else
    {
        try
            Run(AppClass)
        catch
            MsgBox("AppClass " . AppClass . " does not exist.")

        return
    }
}

; 2.3 Switch windows within the same app

SwitchWindowsWithSameClass() {
    AppClass := WinGetClass("A")
    ids := WinGetList("ahk_class" . AppClass)
    if (ids.Length >=2 ) {
        last_id := ids[ids.Length]
        WinActivate last_id
    }
}

; 2.4 Show AppExeName & AppClass for active App

ShowInfoForActiveApp()
{
        AppClass := WinGetClass("A")
        AppProcessName := WinGetProcessName("A")
        AppProcessPath := WinGetProcessPath("A")
 
        info := "Information about active App:`nAppClass: " . AppClass . "`nProcessName: " . AppProcessName . "`nProcessPath: " . AppProcessPath
        A_Clipboard := info
        Send "^c"
        ClipWait  ; Wait for the clipboard to contain text.
        MsgBox(info)
}

;
; 3. HyperKey + ` - hotkey to activate last Window of same type of the current App
;
^+!`::
{
    SwitchWindowsWithSameClass()
}


;
; 4. enable HyperKey to launch apps
;

; HyperKey + i -- Show App information
^+!i::ShowInfoForActiveApp()

; HyperKey + c -- launch chrome
^+!c::OpenOrShowOrHideAppBasedOnExeName("C:\Program Files\Google\Chrome\Application\chrome.exe")

; HyperKey + t -- launch thunder
^+!t::OpenOrShowOrHideAppBasedOnExeName("D:\Software\迅雷_11.1.12.1692_去广告SVIP绿色精简最终版\Thunder\Program\Thunder.exe")

; HyperKey + f -- explorer
^+!f::OpenOrShowOrHideAppBasedOnClass("CabinetWClass")

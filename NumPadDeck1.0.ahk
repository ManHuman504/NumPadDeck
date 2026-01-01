#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ==============================================================================
 * NUMPAD DECK ENGINE (v2.1)
 * Clean base for GitHub projects. 
 * Allows turning a Numpad into a multi-profile macro pad.
 * ==============================================================================
 */

; --- CONFIGURATION ---
global DeckMode        := false
global CurrentProfile  := 1
global ProfileCount    := 3 
global ProfileNames    := Map(1, "SYSTEM", 2, "GAMING", 3, "MACROS")

; --- OSD SETTINGS ---
global GuiW := 220, GuiH := 50
global PosX := (A_ScreenWidth - GuiW) / 2, PosY := 0
global Transparency := 255

; --- GUI SETUP ---
global MyGui := Gui("-Caption +AlwaysOnTop +ToolWindow +LastFound")
MyGui.BackColor := "111111"
MyGui.SetFont("s12 w700 cWhite", "Segoe UI")
global MyText := MyGui.Add("Text", "Center 0x200 x0 y0 w" GuiW " h" GuiH, "DECK START")

; Rounded corners
WinSetRegion("0-0 " GuiW "-0 " GuiW "-" (GuiH-15) " " (GuiW-15) "-" GuiH " 15-" GuiH " 0-" (GuiH-15) " 0-0", MyGui)

; ==============================================================================
; HOTKEYS
; ==============================================================================

NumLock:: {
    global DeckMode := !DeckMode
    ShowOSD(DeckMode ? "DECK MODE: ON" : "NUMPAD MODE", DeckMode ? "42FF42" : "FF4B4B")
}

#HotIf DeckMode
*NumpadDiv::  ChangeProfile(-1)
*NumpadMult:: ChangeProfile(1)

; Capture all Numpad keys
*Numpad0::
*Numpad1::
*Numpad2::
*Numpad3::
*Numpad4::
*Numpad5::
*Numpad6::
*Numpad7::
*Numpad8::
*Numpad9::
*NumpadAdd::
*NumpadSub::
*NumpadEnter::
*NumpadDot::
*SC053::
*NumpadIns::
*NumpadEnd::
*NumpadDown::
*NumpadPgDn::
*NumpadLeft::
*NumpadClear::
*NumpadRight::
*NumpadHome::
*NumpadUp::
*NumpadPgUp::
*NumpadDel::
{
    KeyLogic(A_ThisHotkey, false)
}

; Capture Releases
*Numpad0 Up::
*Numpad1 Up::
*Numpad2 Up::
*Numpad3 Up::
*Numpad4 Up::
*Numpad5 Up::
*Numpad6 Up::
*Numpad7 Up::
*Numpad8 Up::
*Numpad9 Up::
*NumpadAdd Up::
*NumpadSub Up::
*NumpadEnter Up::
*NumpadDot Up::
*SC053 Up::
*NumpadIns Up::
*NumpadEnd Up::
*NumpadDown Up::
*NumpadPgDn Up::
*NumpadLeft Up::
*NumpadClear Up::
*NumpadRight Up::
*NumpadHome Up::
*NumpadUp Up::
*NumpadPgUp Up::
*NumpadDel Up::
{
    KeyLogic(A_ThisHotkey, true)
}
#HotIf

; ==============================================================================
; CORE ENGINE
; ==============================================================================

KeyLogic(hk, isUp) {
    ; Normalize key names
    clean := StrReplace(StrReplace(StrReplace(hk, "*", ""), "Numpad", ""), " Up", "")
    static m := Map(
        "Ins","0","End","1","Down","2","PgDn","3",
        "Left","4","Clear","5","Right","6","Home","7",
        "Up","8","PgUp","9","Del","Dot","SC053","Dot"
    )
    if m.Has(clean)
        clean := m[clean]

    ; --- PROFILE HANDLER ---
    
    ; PROFILE 1: SYSTEM
    if (CurrentProfile == 1) {
        if (!isUp) {
            switch clean {
                case "1": MsgBox("Profile 1 - Key 1 pressed")
                case "2": return
            }
        }
    }
    
    ; PROFILE 2: GAMING (Supports holding keys)
    else if (CurrentProfile == 2) {
        switch clean {
            case "8": (isUp) ? Send("{w Up}") : Send("{w Down}")
            case "4": (isUp) ? Send("{a Up}") : Send("{a Down}")
            case "5": (isUp) ? Send("{s Up}") : Send("{s Down}")
            case "6": (isUp) ? Send("{d Up}") : Send("{d Down}")
        }
    }
    
    ; PROFILE 3: MACROS
    else if (CurrentProfile == 3) {
        if (!isUp) {
            switch clean {
                case "5": Run("notepad.exe")
            }
        }
    }
}

; ==============================================================================
; SYSTEM FUNCTIONS
; ==============================================================================

ChangeProfile(offset) {
    global CurrentProfile
    CurrentProfile += offset
    if (CurrentProfile > ProfileCount)
        CurrentProfile := 1
    else if (CurrentProfile < 1)
        CurrentProfile := ProfileCount
    ShowOSD(ProfileNames[CurrentProfile], "59B2FF")
}

ShowOSD(txt, clr := "White") {
    global Transparency
    SetTimer(DoFade, 0) 
    Transparency := 255
    MyText.Opt("c" clr)
    MyText.Value := txt
    WinSetTransparent(255, MyGui)
    MyGui.Show("x" PosX " y" PosY " NoActivate")
    SetTimer(() => SetTimer(DoFade, 20), -800)
}

DoFade() {
    global Transparency
    if (Transparency <= 0) {
        SetTimer(DoFade, 0)
        MyGui.Hide()
    } else {
        Transparency -= 15
        if (Transparency < 0)
            Transparency := 0
        WinSetTransparent(Transparency, MyGui)
    }
}

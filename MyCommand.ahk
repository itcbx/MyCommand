;==============================================================================
;
;     FileName: MyCommand.ahk
;         Desc: Some shortcut for windows system depend on Autohotkey
;
;       Author: Itcbx
;        Email: cbx945@gmail.com
;     HomePage: http://www.itcbx.com 
;
;      Created: 2012-01-16 13:10:06
;      Version: 1.0
;      History:
;
;==============================================================================


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
#Include brightness.ahk

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; =============================================================================
; 脚本自动运行
; =============================================================================

FileInstall MyCommand.ini, MyCommand.ini

GoSub MenuInit
GoSub SystemHotKeyInit
GoSub FolderInit
GoSub ProgramInit
Return

MenuInit:
Menu Tray, NoStandard
Menu Tray, Tip, MyCommand
;Menu Tray, Default, MyCommand
Menu Tray, Add
Menu Tray, Add, 修改热键, MenuEditHotKey
Menu, Tray, Add, 退出, MenuExit
Return
MenuEditHotKey:
RunWait %A_ScriptDir%\MyCommand.ini
Reload
Return
MenuExit:
ExitApp
Return
; -----------------------------------------------------------------------------
; 系统快捷键绑定初始化
SystemHotKeyInit:
IniRead VolumeUp, MyCommand.ini, System, VolumeUp
IniRead VolumeDown, MyCommand.ini, System, VolumeDown
IniRead BrightnessUp, MyCommand.ini, System, BrightnessUp
IniRead BrightnessDown, MyCommand.ini, System, BrightnessDown
IniRead BrightnessMiddle, MyCommand.ini, System, BrightnessMiddle
IniRead DisplayShutdown, MyCommand.ini, System, DisplayShutdown
KeyPre = ^!
; 配置提高音量热键
HotKey %KeyPre%%VolumeUp%, VolumeUpLabel, On
; 配置降低音量热键
HotKey %KeyPre%%VolumeDown%, VolumeDownLabel, On

; 配置提高屏幕亮度热键
HotKey %KeyPre%%BrightnessUp%, BrightnessUpLabel, On
; 配置降低屏幕亮度热键
HotKey %KeyPre%%BrightnessDown%, BrightnessDownLabel, On
; 配置将屏幕亮度设为中间值热键
HotKey %KeyPre%%BrightnessMiddle%, BrightnessMiddleLabel, On
; 配置关闭显示器
HotKey %KeyPre%%DisplayShutdown%, DisplayShutdownLabel, On

Return
; -----------------------------------------------------------------------------
; 快捷键启动文件夹参数初始化
FolderInit:
Global FolderNameArr
Global FolderPathArr
FolderNameArr := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
FolderPathArr := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
loopI = 0
While loopI <= 9
{
	IniRead Temp, MyCommand.ini, Folder, % loopI
	If Temp <> ""
	{
		FolderNameArr[loopI] := []
		FolderPathArr[loopI] := []
		Loop Parse, Temp, `;
		{
			Tempa := Object()
			StringSplit Tempa, A_LoopField, =
			If Tempa0 = 2
			{
				FolderNameArr[loopI].Insert(Tempa1)
				FolderPathArr[loopI].Insert(Tempa2)
			}
		}
	}
	++loopI
}
While loopI <= 35
{
	IniRead Temp, MyCommand.ini, Folder, % Chr(loopI+55)
	If Temp <> ""
	{
		FolderNameArr[loopI] := []
		FolderPathArr[loopI] := []
		Loop Parse, Temp, `;
		{
			Tempa := Object()
			StringSplit Tempa, A_LoopField, =
			FolderNameArr[loopI].Insert(Tempa1)
			FolderPathArr[loopI].Insert(Tempa2)
		}
	}
	++loopI
}
Return
; -----------------------------------------------------------------------------
; 快捷键启动程序参数初始化
ProgramInit:
Global ProgramNameArr
Global ProgramPathArr
ProgramNameArr := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
ProgramPathArr := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
loopI = 0
While loopI <= 9
{
	IniRead Temp, MyCommand.ini, Program, % loopI
	If Temp <> ""
	{
		ProgramNameArr[loopI] := []
		ProgramPathArr[loopI] := []
		Loop Parse, Temp, `;
		{
			Tempa := Object()
			StringSplit Tempa, A_LoopField, =
			If Tempa0 = 2
			{
				ProgramNameArr[loopI].Insert(Tempa1)
				ProgramPathArr[loopI].Insert(Tempa2)
			}
		}
	}
	++loopI
}
While loopI <= 35
{
	IniRead Temp, MyCommand.ini, Program, % Chr(loopI+55)
	If Temp <> ""
	{
		ProgramNameArr[loopI] := []
		ProgramPathArr[loopI] := []
		Loop Parse, Temp, `;
		{
			Tempa := Object()
			StringSplit Tempa, A_LoopField, =
			ProgramNameArr[loopI].Insert(Tempa1)
			ProgramPathArr[loopI].Insert(Tempa2)
		}
	}
	++loopI
}
Return
; =============================================================================
; 系统增强热键
; =============================================================================
; 增加系统音量
VolumeUpLabel:
SendEvent {Volume_Up}
Return

; 减少系统音量
VolumeDownLabel:
SendEvent {Volume_Down}
Return
; -----------------------------------------------------------------------------
; 隐藏或显示隐藏文件
; Ctrl+h
#If (WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass"))
	^h::
	RegRead REG_HIDDEN, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
	If REG_HIDDEN = 2 ; 如果当前状态为隐藏, 则显示出来
	{
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 1
		TrayTip 状态, 显示隐藏文件夹, 1
	}
	Else If REG_HIDDEN = 1 ; 如果当前状态为显示, 则隐藏起来
	{
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
		RegWrite REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, ShowSuperHidden, 0
		TrayTip 状态, 隐藏隐藏文件夹, 1
	}
	Send {F5} ; 刷新
	Return
#If
; -----------------------------------------------------------------------------
; 增加屏幕亮度
BrightnessUpLabel:
b := GetScreenBrightness() + 1
If(SetScreenBrightness(b))
	TrayTip setbrightness, %b%
Else
	TrayTip setbrightness, 无法设置该值:%b%
Return
; 降低屏幕亮度
BrightnessDownLabel:
b := GetScreenBrightness() - 1
if(SetScreenBrightness(b))
	TrayTip setbrightness, %b%
else
	TrayTip setbrightness, 无法设置该值:%b%
Return

; 设定屏幕为正常亮度
BrightnessMiddleLabel:
b := 128
If(SetScreenBrightness(b))
	TrayTip setbrightness, %b%
Else
	TrayTip setbrightness, 无法设置该值:%b%
Return
; -----------------------------------------------------------------------------
; 关闭显示器
DisplayShutdownLabel:
;Sleep 1000
SendMessage, 0x112, 0xF170, 2,, Program Manager
Return

; =============================================================================
; 快捷键启动文件夹
; =============================================================================
FolderChoose()
{
	Global FolderName
	Global FolderPath
	Global FolderNameArr
	Global FolderPathArr
	StringRight Tmp, A_ThisHotkey, 1
	If Tmp > 9 
		Tmp := Asc(Tmp) - 87
	FolderName := FolderNameArr[Tmp]
	FolderPath := FolderPathArr[Tmp]
	IfWinExist ahk_class AutoHotkeyGUI
		Gui Destroy
	if % FolderPath.MaxIndex() = 1
		Run % FolderPath[1]
	else if % FolderPath.MaxIndex() > 1
	{
		Loop % FolderName.MaxIndex() 
		{
			If A_Index <= 9
				Tmp := A_Index . " "
			Else
				Tmp := Chr(A_Index) . " "
			Gui Add, Text, , % Tmp . FolderName[A_Index]
		}
		Gui Add, Edit, vFolderIndex gFolderLabel
		Gui Show, , 文件夹选择
	}
}
FolderLabel:
Gui Submit
If FolderIndex >= 9
	FolderIndex := Asc(FolderIndex) - 87
If FolderIndex <= % FolderPath.MaxIndex()
{
	Run % FolderPath[FolderIndex]
}
Gui Destroy
Return
; -----------------------------------------------------------------------------
!#0::
!#1::
!#2::
!#3::
!#4::
!#5::
!#6::
!#7::
!#8::
!#9::
!#a::
!#b::
!#c::
!#d::
!#e::
!#f::
!#g::
!#h::
!#i::
!#j::
!#k::
!#l::
!#m::
!#n::
!#o::
!#p::
!#q::
!#r::
!#s::
!#t::
!#u::
!#v::
!#w::
!#x::
!#y::
!#z::
FolderChoose()
Return
; =============================================================================
; 快捷键启动程序
; =============================================================================
ProgramChoose()
{
	Global ProgramName
	Global ProgramPath
	Global ProgramNameArr
	Global ProgramPathArr
	StringRight Tmp, A_ThisHotkey, 1
	If Tmp > 9 
		Tmp := Asc(Tmp) - 87
	ProgramName := ProgramNameArr[Tmp]
	ProgramPath := ProgramPathArr[Tmp]
	IfWinExist ahk_class AutoHotkeyGUI
		Gui Destroy
	if % ProgramPath.MaxIndex() = 1
		Run % ProgramPath[1]
	else if % ProgramPath.MaxIndex() > 1
	{
		Loop % ProgramName.MaxIndex() 
		{
			If A_Index <= 9
				Tmp := A_Index . " "
			Else
				Tmp := Chr(A_Index) . " "
			Gui Add, Text, , % Tmp . ProgramName[A_Index]
		}
		Gui Add, Edit, vProgramIndex gProgramLabel
		Gui Show, , 程序选择
	}
}
ProgramLabel:

Gui Submit
If ProgramIndex >= 9
	ProgramIndex := Asc(ProgramIndex) - 87
If ProgramIndex <= % ProgramPath.MaxIndex()
{
	Run % ProgramPath[ProgramIndex]
}
Gui Destroy

Return
; ------------------------------------------------------------------------------
^#0::
^#1::
^#2::
^#3::
^#4::
^#5::
^#6::
^#7::
^#8::
^#9::
^#a::
^#b::
^#c::
^#d::
^#e::
^#f::
^#g::
^#h::
^#i::
^#j::
^#k::
^#l::
^#m::
^#n::
^#o::
^#p::
^#q::
^#r::
^#s::
^#t::
^#u::
^#v::
^#w::
^#x::
^#y::
^#z::
AppsKey & 0::
AppsKey & 1::
AppsKey & 2::
AppsKey & 3::
AppsKey & 4::
AppsKey & 5::
AppsKey & 6::
AppsKey & 7::
AppsKey & 8::
AppsKey & 9::
AppsKey & a::
AppsKey & b::
AppsKey & c::
AppsKey & d::
AppsKey & e::
AppsKey & f::
AppsKey & g::
AppsKey & h::
AppsKey & i::
AppsKey & j::
AppsKey & k::
AppsKey & l::
AppsKey & m::
AppsKey & n::
AppsKey & o::
AppsKey & p::
AppsKey & q::
AppsKey & r::
AppsKey & s::
AppsKey & t::
AppsKey & u::
AppsKey & v::
AppsKey & w::
AppsKey & x::
AppsKey & y::
AppsKey & z::
ProgramChoose()
Return
GuiClose:
GuiEscape:
Gui Destroy
return

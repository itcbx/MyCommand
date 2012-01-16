/* brightness.ahk    屏幕亮度函数库
Written by wz520[wingzero1040 at gmail dot com]
Last Update: 2011-02-18

使用 Windows API 的 GetDeviceGammaRamp/SetDeviceGammaRamp 设置屏幕亮度。
参考资料: http://www.nirsoft.net/vc/change_screen_brightness.html

PS: 不是所有显卡都支持。

脚本编写及测试环境：
	WinXP SP2
	AutoHotKey 1.0.48.05

Autohotkey_L 兼容性：
	AutoHotkey_L 1.0.91.05 测试通过
*/

/* 设置屏幕亮度。
参数 {
	brightness {
		<128: 变暗
		=128: 正常亮度
		>128: 变亮
	}
}
最小为 0，最大视显卡而定。
返回值 {
	True:  成功
	False: 失败
}
*/
SetScreenBrightness(brightness)
{
	if ( (hDesktopDC := DllCall("GetDC", uint, 0, uint)) = 0 )
		return False

	arraysize := 256*2 ;256*sizeof(WORD)
	VarSetCapacity(ramp, 3*arraysize, 0) ;WORD ramp[3][256]

	Loop, 256 {
		arrayvalue := (A_Index-1)*(brightness+128)
		if (arrayvalue>65535)
			arrayvalue := 65535

		NumPut(arrayvalue, ramp,             (A_Index-1)*2, "UShort") ;r
		NumPut(arrayvalue, ramp,   arraysize+(A_Index-1)*2, "UShort") ;g
		NumPut(arrayvalue, ramp, arraysize*2+(A_Index-1)*2, "UShort") ;b
	}

	retvalue := DllCall("SetDeviceGammaRamp", uint, hDesktopDC, uint, &ramp)

	DllCall("ReleaseDC", uint, 0, uint, hDesktopDC)

	return retvalue
}

; 获取屏幕亮度。返回值可以传给 SetScreenBrightness()
GetScreenBrightness()
{
	if ( (hDesktopDC := DllCall("GetDC", uint, 0, uint)) = 0 )
		return False

	arraysize := 256*2 ;256*sizeof(WORD)
	VarSetCapacity(ramp, 3*arraysize, 0) ;WORD ramp[3][256]

	retvalue := DllCall("GetDeviceGammaRamp", uint, hDesktopDC, uint, &ramp, uint)
	DllCall("ReleaseDC", uint, 0, uint, hDesktopDC)
	if (retvalue != 1)
		return False
	else
		; 取 ramp[0][1] 的值，然后减 128。
		; 其实这只是红色的 gamma 校正。
		; 但是因为 SetScreenBrightness() 把红绿蓝的 gamma 都设成一样，所以本函数认为单取红色的 gamma 就可以决定亮度。
		; 要获取绿色的 gamma 校正： NumGet(ramp,   arraysize+2) - 128
		; 要获取蓝色的 gamma 校正： NumGet(ramp, arraysize*2+2) - 128
		return NumGet(ramp, 2, "UShort") - 128
}

; vim: ts=4:noet

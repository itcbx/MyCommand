/* brightness.ahk    ��Ļ���Ⱥ�����
Written by wz520[wingzero1040 at gmail dot com]
Last Update: 2011-02-18

ʹ�� Windows API �� GetDeviceGammaRamp/SetDeviceGammaRamp ������Ļ���ȡ�
�ο�����: http://www.nirsoft.net/vc/change_screen_brightness.html

PS: ���������Կ���֧�֡�

�ű���д�����Ի�����
	WinXP SP2
	AutoHotKey 1.0.48.05

Autohotkey_L �����ԣ�
	AutoHotkey_L 1.0.91.05 ����ͨ��
*/

/* ������Ļ���ȡ�
���� {
	brightness {
		<128: �䰵
		=128: ��������
		>128: ����
	}
}
��СΪ 0��������Կ�������
����ֵ {
	True:  �ɹ�
	False: ʧ��
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

; ��ȡ��Ļ���ȡ�����ֵ���Դ��� SetScreenBrightness()
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
		; ȡ ramp[0][1] ��ֵ��Ȼ��� 128��
		; ��ʵ��ֻ�Ǻ�ɫ�� gamma У����
		; ������Ϊ SetScreenBrightness() �Ѻ������� gamma �����һ�������Ա�������Ϊ��ȡ��ɫ�� gamma �Ϳ��Ծ������ȡ�
		; Ҫ��ȡ��ɫ�� gamma У���� NumGet(ramp,   arraysize+2) - 128
		; Ҫ��ȡ��ɫ�� gamma У���� NumGet(ramp, arraysize*2+2) - 128
		return NumGet(ramp, 2, "UShort") - 128
}

; vim: ts=4:noet

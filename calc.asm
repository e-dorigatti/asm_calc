.386
.model flat,stdcall
option casemap:none
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

include variables.asm
include utilities.asm
include wndproc.asm

.code
CreateControls    proto, hWnd: HWND
aggiungiTestoNum  proto, num: DWORD
cancellaTestoNum  proto
stringToNum       proto, lpStr: DWORD, lpNum: DWORD
potenza           proto, base: DWORD, exp: DWORD
reversaStr        proto, lpStr: DWORD
numToStr          proto, num: DWORD, lpStr: DWORD

main:
	invoke GetModuleHandle, NULL
	mov    hInstance,eax
	invoke WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	local wc:WNDCLASSEX
	local msg:MSG
	local hwnd:HWND

	mov   wc.cbSize,SIZEOF WNDCLASSEX
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra,NULL
	mov   wc.cbWndExtra,NULL
	push  hInst
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_BTNFACE+1
	mov   wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL, IDI_APPLICATION
	mov   wc.hIcon,eax
	mov   wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax
	invoke RegisterClassEx, addr wc
	invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,ADDR appName,\
           WS_OVERLAPPEDWINDOW or WS_MAXIMIZEBOX,
           CW_USEDEFAULT,CW_USEDEFAULT,380, 280,NULL,NULL,\
           hInst,NULL
	mov   hwnd,eax
	invoke ShowWindow, hwnd,SW_SHOWNORMAL
	invoke UpdateWindow, hwnd

winmain_loop:
      invoke GetMessage, ADDR msg,NULL,0,0
      cmp   eax, 0
      je    fine_loop
      invoke TranslateMessage, ADDR msg
      invoke DispatchMessage, ADDR msg
      jmp   winmain_loop

fine_loop:
	mov     eax,msg.wParam
	ret
WinMain endp

end main

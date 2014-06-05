.386
.model flat,stdcall
option casemap:none
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
ClassName         db    "shellWinClass",0
appName           db    "Calc - by Emilio!",0
overflowText      db    "overflow/underflow!",0
divZeroText       db    "divisione per zero!", 0

editClassName     db    "edit", 0
buttonClassName   db    "button", 0

;     testo dei controlli
btn0Text          db    "0", 0
btn1Text          db    "1", 0
btn2Text          db    "2", 0
btn3Text          db    "3", 0
btn4Text          db    "4", 0
btn5Text          db    "5", 0
btn6Text          db    "6", 0
btn7Text          db    "7", 0
btn8Text          db    "8", 0
btn9Text          db    "9", 0
btnUgualeText     db    "=", 0
btnPiuText        db    "+", 0
btnMenoText       db    "-", 0
btnDivisoText     db    "/", 0
btnPerText        db    "*", 0
btnClearText      db    "C", 0
btnCancText       db    "del", 0
txtNumText        db    "0", 0
btnSegnoText      db    "+/-", 0
btnPotenzaText    db    "x^y", 0
testNum           dword 0

.data?
buffer            db          1024 dup (?)
num1              DWORD       ?
num2              DWORD       ?
operazione        DWORD       ?
hInstance         HINSTANCE   ?

; handle dei controlli
txtNumWnd         HWND        ?
btn0Wnd           HWND        ?
btn1Wnd           HWND        ?
btn2Wnd           HWND        ?
btn3Wnd           HWND        ?
btn4Wnd           HWND        ?
btn5Wnd           HWND        ?
btn6Wnd           HWND        ?
btn7Wnd           HWND        ?
btn8Wnd           HWND        ?
btn9Wnd           HWND        ?
btnUgualeWnd      HWND        ?
btnPiuWnd         HWND        ?
btnMenoWnd        HWND        ?
btnPerWnd         HWND        ?
btnDivisoWnd      HWND        ?
btnClearWnd       HWND        ?
btnCancWnd        HWND        ?
btnSegnoWnd       HWND        ?
btnPotenzaWnd     HWND        ?

.const
buttonHeight      equ         30
buttonWidth       equ         75
buttonStyle       equ         WS_CHILD or WS_VISIBLE
opSomma           equ         1
opDifferenza      equ         2
opProdotto        equ         3
opQuoziente       equ         4
opPotenza         equ         5

; ID dei controlli
btn0ID            equ         1000
btn1ID            equ         1001
btn2ID            equ         1002
btn3ID            equ         1003
btn4ID            equ         1004
btn5ID            equ         1005
btn6ID            equ         1006
btn7ID            equ         1007
btn8ID            equ         1008
btn9ID            equ         1009
txtNumID          equ         1010
btnPiuID          equ         1011
btnMenoID         equ         1012
btnPerID          equ         1013
btnDivisoID       equ         1014
btnUgualeID       equ         1015
btnClearID        equ         1016
btnCancID         equ         1017
btnSegnoID        equ         1018
btnPotenzaID      equ         1019

.code
; dichiarazione funzioni
CreateControls    proto, hWnd: HWND
aggiungiTestoNum  proto, num: DWORD
cancellaTestoNum  proto
stringToNum       proto, lpStr: DWORD, lpNum: DWORD
potenza           proto, base: DWORD, exp: DWORD
reversaStr        proto, lpStr: DWORD
svuotaTxtNum      proto
numToStr          proto, num: DWORD, lpStr: DWORD

; entry point del programma
start:
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
	invoke LoadIcon,NULL, h IDI_APPLICATION
	mov   wc.hIcon,eax
	mov   wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax
	invoke RegisterClassEx, addr wc
	invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,ADDR appName,\
           WS_OVERLAPPEDWINDOW or WS_MAXIMIZEBOX,
           CW_USEDEFAULT,CW_USEDEFAULT,370, 270,NULL,NULL,\
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

; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤
;     WndProc
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
      mov   eax, uMsg
      cmp   eax, WM_DESTROY                           ; messaggio WM_DSTROY
      jne   test_create
		invoke PostQuitMessage,NULL
      jmp   fine

test_create:
      cmp   eax, WM_CREATE                            ; messaggio WM_CREATE
      jne   test_command
            Invoke CreateControls, hWnd
            jmp   fine

test_command:                                         ; messaggio WM_COMMAND
      cmp   eax, WM_COMMAND
      jne   gestisci_default
      mov   eax, wParam
      and   eax, 0ffffh
      mov   edx, eax
      and   edx, 0ffffh
      shr   edx, 16
      cmp   edx, BN_CLICKED
      jne   fine
      
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
;     switch per decidere il pulsante, ax = ID
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

      cmp   eax, txtNumID                             ; se è la casella di testo lascia fare a winzoz
      je    gestisci_default
            
      cmp   eax, btn9ID                               ; bel trucco per decidere se è un numero
      jg    nonNumero                                 ; e, se lo è, qual'è. si basa sul fatto che
      sub   eax, btn0ID                               ; gli ID dei numeri vanno da 1000 a 1009
      invoke aggiungiTestoNum, eax                    ; e sono in ordine (0 -> 1000, 1-> 1001 ecc)
      pop   eax
      jmp   fine
      
nonNumero:                                            ; pulsante "canc", toglie ultimo numero
      cmp   eax, btnCancID
      jne   prova_clear
      invoke cancellaTestoNum
      jmp   fine

prova_clear:                                          ; pulsante "c", ripristina il testo a "0"
      cmp   eax, btnClearID
      jne   provaSegno
      invoke SetWindowText, txtNumWnd, addr txtNumText
      jmp   fine

provaSegno:                                           ; cambia da numero positivo a numero negativo
      cmp   eax, btnSegnoID
      jne   prova_uguale
      invoke GetWindowText, txtNumWnd, addr buffer, 1023
      invoke lstrcmp, addr btn0Text, addr buffer
      cmp   eax, 0
      je    fine
      mov   esi, offset buffer
      mov   al, btnMenoText
      cmp   al, [esi]
      je    CambiaSegnoInPositivo
      invoke reversaStr, esi
      invoke lstrcat, esi, addr btnMenoText
      invoke reversaStr, esi
      invoke SetWindowText, txtNumWnd, esi
      jmp   fine
      
CambiaSegnoInPositivo:
      inc   esi
      invoke SetWindowText, txtNumWnd, esi
      jmp   fine
      
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
;     se è stato premuto l'uguale fai l'operazione
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
; arrivati a questo punto il testo verrà di sicuro salvato, evita che
; txtNum.Text = NULL

prova_uguale:
      push  eax
      invoke GetWindowText, txtNumWnd, addr buffer, 1023
      cmp   eax, 0
      jne   converti_to_string
      invoke SetWindowText, txtNumWnd, addr txtNumText
      invoke lstrcpy, addr buffer, addr txtNumText
      
converti_to_string:
      invoke stringToNum, addr buffer, addr num2
      pop   eax
      
      cmp   eax, btnUgualeID
      jne   isOperazione
      mov   edx, operazione
      mov   eax, num1
      cmp   edx, 0
      je    fine
      
      cmp   edx, opSomma
      jne   prova_fai_differenza
      add   eax, num2                                 ; somma
      jmp   mostra_risultato
            
prova_fai_differenza:
      cmp   edx, opDifferenza
      jne   prova_fai_prodotto
      sub   eax, num2                                 ; differenza
;      jc    overflow
      jmp   mostra_risultato

prova_fai_prodotto:
      cmp   edx, opProdotto
      jne   fai_divisione
      mul   num2                                      ; prodotto
      jc    overflow
      shl   edx, 16
      add   eax, edx
      jmp   mostra_risultato

fai_divisione:
      cmp   edx, opQuoziente
      jne   fai_potenza
      mov   ecx, num2
      cmp   ecx, 0
      je    divByZero
      xor   edx, edx
      div   cx                                        ; quoziente

fai_potenza:
      cmp   edx, opPotenza
      jne   fine
      invoke potenza, num1, num2

mostra_risultato:
      invoke numToStr, eax, addr buffer
      invoke SetWindowText, txtNumWnd, addr buffer
      jmp   fine

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
;     arrivati qui deve per forza essere una delle 4 operazioni
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

isOperazione:
      push  eax
      invoke GetWindowText, txtNumWnd, addr buffer, 1023
      invoke stringToNum, addr buffer, addr num1
      invoke SetWindowText, txtNumWnd, addr txtNumText
      pop   eax

prova_somma:                                          ; somma                       
      cmp   eax, btnPiuID
      jne   prova_differenza
      push  opSomma
      pop   operazione
      jmp   fine

prova_differenza:                                     ; differenza
      cmp   eax, btnMenoID
      jne   prova_prodotto
      push  opDifferenza
      pop   operazione
      jmp   fine

prova_prodotto:                                       ; prodotto
      cmp   eax, btnPerID
      jne   prova_quoziente
      push  opProdotto
      pop   operazione
      jmp   fine

prova_quoziente:                                      ; quoziente
      cmp   eax, btnDivisoID
      jne   prova_potenza
      push  opQuoziente
      pop   operazione
      jmp   fine

prova_potenza:
      cmp   eax, btnPotenzaID
      jne   fine
      push  opPotenza
      pop   operazione
      jmp   fine

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««
;     tutti i pulsanti processati
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

gestisci_default:
      invoke DefWindowProc,hWnd,uMsg,wParam,lParam
      ret


overflow:
      add   esp, 4
      invoke MessageBox, hWnd, addr overflowText, addr appName, MB_OK or MB_ICONSTOP
      invoke SetWindowText, txtNumWnd, addr txtNumText
      push  dword ptr 0
      pop   num2
      jmp   fine

divByZero:
      invoke MessageBox, hWnd, addr divZeroText, addr appName, MB_OK or MB_ICONSTOP
      invoke SetWindowText, txtNumWnd, addr txtNumText

fine:
	xor    eax,eax
	ret
WndProc endp

; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤
;     AggiungiTestoNum
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

aggiungiTestoNum proc, num: DWORD
; aggiunge il numero 'num' alla fine del testo
; in txtNum

      push  edx
      push  esi
      push  eax
      mov   esi, offset buffer
      
      invoke GetWindowText, txtNumWnd, addr buffer, 1023
      push  eax
      invoke lstrcmp, addr buffer, addr txtNumText
      jnz   aggiungi_testo
      xor   edx, edx
      mov   [esi], edx
      dec   esi

aggiungi_testo:
      pop   eax
      pop   edx
      add   edx, 30h
      add   esi, eax
      mov   [esi], dx
      pop   esi
      invoke SetWindowText, txtNumWnd, addr buffer
      mov   eax, edx
      pop   edx
      
      ret
aggiungiTestoNum endp

; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤
;     CancellaTestoNum
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

cancellaTestoNum proc
; cancella il primo numero di txtNum
; mette "0" se quello è l'unico numero

      push  eax
      push  esi
      invoke GetWindowText, txtNumWnd, addr buffer, 1023
      dec   eax
      jz    tutto_cancellato
      mov   esi, offset buffer
      add   esi, eax
      xor   eax, eax
      mov   [esi], al
      
cancella_testo_num_imposta_testo:
      invoke SetWindowText, txtNumWnd, addr buffer
      pop   esi
      pop   eax
      ret

tutto_cancellato:
      invoke lstrcpy, addr buffer, addr txtNumText
      jmp   cancella_testo_num_imposta_testo
cancellaTestoNum endp

; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤
;     StringToNum
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

stringToNum proc, lpStr: DWORD, lpNum: DWORD
; converte la stringa puntata da lpStr
; in numero in base 10, salva il risultato
; nella var puntata da lpNum

      push  esi
      push  edi
      push  eax
      push  ebx
      push  ecx
      push  edx

      invoke lstrcmp, addr txtNumText, lpStr
      jz    isZero_stringToNum

      mov   esi, lpStr
      mov   bl, [esi]
      cmp   bl, btnMenoText
      jne   stringToNum_positivo_1
      mov   esi, lpNum
      xor   ebx, ebx
      dec   ebx
      mov   [esi], ebx
      inc   lpStr

stringToNum_positivo_1:      
      invoke reversaStr, lpStr
      invoke lstrlen, lpStr
      
      xor   ebx, ebx
      dec   eax
      mov   ecx, eax
      mov   esi, lpStr
      add   esi, eax
      
loop_str2num_calcola:
      xor   edx, edx
      mov   dl, [esi]
      sub   dl, 30h
      invoke potenza, 0ah, ecx            ; eax = 10 ^ ecx
      mul   dx                            ; eax *= dx 
      shl   edx, 16
      add   eax, edx
      add   ebx, eax
      dec   esi
      dec   ecx
      jns   loop_str2num_calcola

      mov   esi, lpNum
      mov   eax, [esi]
      cmp   eax, 0ffffffffh
      jne   stringToNum_positivo_2
      neg   ebx
      
stringToNum_positivo_2:
      mov   [esi], ebx

fine_stringToNum:
      pop   edx
      pop   ecx
      pop   ebx
      pop   eax
      pop   edi
      pop   esi
      ret

isZero_stringToNum:
      mov   ebx, lpNum
      xor   eax, eax
      mov   [ebx], eax
      jmp   fine_stringToNum
stringToNum endp

; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤
;     ReversaStr
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

reversaStr proc, lpStr: DWORD
; reversa la stringa
; abcdef -> fedcba

      push  edi
      push  esi
      push  eax
      push  ecx
      push  edx
      
      invoke lstrlen, lpStr
      cmp   eax, 1
      jbe   fine_reversaStr
      dec   eax
      
      mov   edi, lpStr
      mov   esi, edi
      add   edi, eax
      dec   edi
      mov   ecx, eax
      mov   edx, 2
      
      shr   ecx, 2
      jnc   loop_reversaStr
      inc   ecx

loop_reversaStr:
      mov   ax, word ptr [esi]
      mov   bx, word ptr [edi]
      xchg  al, ah
      xchg  bl, bh
      mov   word ptr [esi], bx
      mov   word ptr [edi], ax
      add   esi, edx
      sub   edi, edx
      sub   ecx, edx
      cmp   ecx, 0
      jbe    loop_reversaStr

fine_reversaStr:
      pop   edx
      pop   ecx
      pop   eax
      pop   esi
      pop   edi
      ret
reversaStr endp

; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤
;     Potenza
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

potenza proc, base: DWORD, exp: DWORD
; eax = base ^ exp

      push  ebx
      push  ecx
      push  edx
      
      mov   ecx, exp
      cmp   ecx, 0
      jb    exp_neg
      mov   ebx, base
      cmp   ebx, 0
      jge   continua
      neg   ebx
      
continua:
      xor   eax, eax
      inc   eax
      cmp   ecx, 0
      je    fine_potenza
      
loop_exp:
      mul   bx
      shl   edx, 16
      add   eax, edx
      dec   ecx
      jnz   loop_exp

fine_potenza:
      pop   edx
      pop   ecx
      pop   ebx
      ret

exp_neg:
      xor   eax,eax
      jmp   fine_potenza
potenza endp

; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤
;     NumToStr
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

numToStr proc, num:DWORD, lpStr: DWORD
;     converte 'num' in stringa
;     salvando il risultato in
;     lpStr (char *)

      push  eax
      push  ebx
      push  ecx
      push  edx
      push  esi

      mov   eax, num
      mov   esi, lpStr
      cmp   eax, 0
      jz    isZero_numToStr
      jg    isPositivo_numToStr
      mov   bl, btnMenoText
      mov   [esi], bl
      inc   esi
      neg   eax
      mov   lpStr, esi

isPositivo_numToStr:      
      mov   ebx, 0ah
      mov   ecx, 30h

strToNum_loop:
      cmp   eax, 0
      je    fine_divisione
      xor   edx, edx
      jb    fine_divisione
      div   bx
      add   edx, ecx
      mov   [esi], edx
      inc   esi
      jmp   strToNum_loop

isZero_numToStr:
      invoke lstrcpy, lpStr, addr txtNumText
      jmp   tutto_finito_numToStr

fine_divisione:
      invoke reversaStr, lpStr

tutto_finito_numToStr:
      pop   esi
      pop   edx
      pop   ecx
      pop   ebx
      pop   eax
      ret
numToStr endp

; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤
;     CreateControls
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

CreateControls proc, hWnd: HWND
;     crea i controlli del form

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnPerText, buttonStyle, 270, 155,buttonWidth, buttonHeight, hWnd, btnPerID, hInstance, NULL
      mov   btnPerWnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnDivisoText, buttonStyle, 270, 120, buttonWidth, buttonHeight, hWnd, btnDivisoID, hInstance, NULL 
      mov   btnDivisoWnd, eax
            
      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnMenoText, buttonStyle, 270, 84, buttonWidth, buttonHeight, hWnd, btnMenoID, hInstance, NULL
      mov   btnMenoWnd, eax
            
      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnPiuText, buttonStyle, 270, 48, buttonWidth, buttonHeight, hWnd, btnPiuID, hInstance, NULL
      mov   btnPiuWnd, eax
            
      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnUgualeText, buttonStyle, 270, 12, buttonWidth, buttonHeight, hWnd, btnUgualeID, hInstance, NULL
      mov   btnUgualeWnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn0Text, buttonStyle, 96, 160, buttonWidth, buttonHeight, hWnd, btn0ID, hInstance, NULL
      mov   btn0Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn1Text, buttonStyle, 12, 48, buttonWidth, buttonHeight, hWnd, btn1ID, hInstance, NULL
      mov   btn1Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn2Text, buttonStyle, 96, 48, buttonWidth, buttonHeight, hWnd, btn2ID, hInstance, NULL
      mov   btn2Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn3Text, buttonStyle, 180, 48, buttonWidth, buttonHeight, hWnd, btn3ID, hInstance, NULL
      mov   btn3Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn4Text, buttonStyle, 12, 84, buttonWidth, buttonHeight, hWnd, btn4ID, hInstance, NULL
      mov   btn4Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn5Text, buttonStyle, 96, 84, buttonWidth, buttonHeight, hWnd, btn5ID, hInstance, NULL
      mov   btn5Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn6Text, buttonStyle, 180, 84, buttonWidth, buttonHeight, hWnd, btn6ID, hInstance, NULL
      mov   btn6Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn7Text, buttonStyle, 12, 120, buttonWidth, buttonHeight, hWnd, btn7ID, hInstance, NULL
      mov   btn7Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn8Text, buttonStyle, 96, 120, buttonWidth, buttonHeight, hWnd, btn8ID, hInstance, NULL
      mov   btn8Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btn9Text, buttonStyle, 180, 120, buttonWidth, buttonHeight, hWnd, btn9ID, hInstance, NULL
      mov   btn9Wnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnClearText, buttonStyle, 12, 160, buttonWidth, buttonHeight, hWnd, btnClearID, hInstance, NULL
      mov   btnClearWnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnCancText, buttonStyle, 180, 160, buttonWidth, buttonHeight, hWnd, btnCancID, hInstance, NULL
      mov   btnCancWnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnSegnoText, buttonStyle, 180, 196, buttonWidth, buttonHeight, hWnd, btnSegnoID, hInstance, NULL
      mov   btnSegnoWnd, eax

      invoke CreateWindowEx, NULL, addr buttonClassName, addr btnPotenzaText, buttonStyle, 96, 196, buttonWidth, buttonHeight, hWnd, btnPotenzaID, hInstance, NULL
      mov   btnPotenzaWnd, eax

      invoke CreateWindowEx, NULL, addr editClassName, addr txtNumText, buttonStyle or ES_NUMBER or WS_BORDER or ES_RIGHT, 12, 12, 243, 30, hWnd, txtNumID, hInstance, NULL
      mov   txtNumWnd, eax
      
      ret
CreateControls     endp

end start

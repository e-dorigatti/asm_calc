.386
option casemap:none

.code
CreateControls    proto, hWnd: HWND
aggiungiTestoNum  proto, num: DWORD
cancellaTestoNum  proto
stringToNum       proto, lpStr: DWORD, lpNum: DWORD
potenza           proto, base: DWORD, exp: DWORD
reversaStr        proto, lpStr: DWORD
numToStr          proto, num: DWORD, lpStr: DWORD

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

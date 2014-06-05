.386
option casemap:none

; д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д
;     WndProc
; д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д=ў=д

.code
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
      
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;     switch per decidere il pulsante, ax = ID
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

      cmp   eax, txtNumID                             ; se ш la casella di testo lascia fare a winzoz
      je    gestisci_default
            
      cmp   eax, btn9ID                               ; bel trucco per decidere se ш un numero
      jg    nonNumero                                 ; e, se lo ш, qual'ш. si basa sul fatto che
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

provaSegno:
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
      
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;     se ш stato premuto l'uguale fai l'operazione
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; arrivati a questo punto il testo verrр di sicuro salvato, evita che
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

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;     arrivati qui deve per forza essere una delle 4 operazioni
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

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

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;     tutti i pulsanti processati
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

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

.386
option casemap:none

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
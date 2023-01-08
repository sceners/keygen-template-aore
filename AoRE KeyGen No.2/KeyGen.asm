;#####################################################
;#  ART of REVERSE ENGINEERING - AoRE		         # 
;#####################################################
;#      			  		                         #
;# Keygen / Keygenme Template   		             #
;# Coded by azmo / AoRE 			                 #
;#						                             #
;#####################################################
;# 													 #
;#  Thx to Goppit and to reversing.be				 #
;#												     #
;#####################################################


.386 
.model flat,stdcall 
option casemap:none 

include		windows.inc 
include		kernel32.inc 
include		user32.inc 
include         gdi32.inc  
include         shell32.inc

includelib	kernel32.lib
includelib	user32.lib 
includelib 	gdi32.lib
includelib 	shell32.lib

DlgProc			proto		 :DWORD,:DWORD,:DWORD,:DWORD 
aboutwndproc  	proto		 :DWORD,:DWORD,:DWORD,:DWORD


.data
noname		db "Please insert your name",0
format       	db "%d",0

.data? 
hInstance	HINSTANCE	?  
NameBuffer	db		32 dup(?) 
SerialBuffer	db		32 dup(?)
Transparency		dd		?

.const
IDD_KEYGEN	equ		1001
IDC_NAME	equ		1002
IDC_SERIAL	equ		1003
IDC_GENERATE	equ		1004
IDC_COPY	equ		1005 
IDC_ABOUT	equ		1006
IDD_ABOUT	equ		1007
AoREIcon	equ		2001


.code 
start: 
    invoke GetModuleHandle, NULL 
    mov    hInstance,eax 
    invoke DialogBoxParam, hInstance, IDD_KEYGEN, NULL, addr DlgProc, NULL 
    invoke ExitProcess,eax 
    
DlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
.if uMsg == WM_INITDIALOG
	invoke 	LoadBitmap, hInstance, 23 
	invoke 	SendDlgItemMessage, hWnd, IDC_GENERATE, BM_SETIMAGE, IMAGE_BITMAP, eax
	invoke 	LoadBitmap, hInstance, 24 
	invoke 	SendDlgItemMessage, hWnd, IDC_COPY, BM_SETIMAGE, IMAGE_BITMAP, eax
	invoke 	LoadBitmap, hInstance, 25
	invoke 	SendDlgItemMessage, hWnd, IDC_ABOUT, BM_SETIMAGE, IMAGE_BITMAP, eax
	invoke	LoadIcon,hInstance,AoREIcon
	invoke	SendMessage,hWnd,WM_SETICON,1,eax
	invoke 	GetDlgItem,hWnd,IDC_NAME
	invoke 	SetFocus,eax 
	
	
.elseif uMsg==WM_CTLCOLOREDIT
	mov eax, lParam
	invoke SetTextColor, wParam, White
	invoke CreateSolidBrush,000000h
	invoke SetBkColor, wParam, 000000h
	invoke CreateSolidBrush, 000000h
	ret

.elseif uMsg==WM_CTLCOLORSTATIC
	mov eax, lParam
	invoke SetTextColor, wParam, White
	invoke SetBkMode, wParam, TRANSPARENT
	invoke CreateSolidBrush,  000000h
	invoke SetBkColor, wParam, eax
	invoke CreateSolidBrush,  000000h
    ret
        
.elseif uMsg == WM_COMMAND
	mov	eax,wParam
	.if eax==IDC_GENERATE
		invoke GetDlgItemText,hWnd,IDC_NAME,addr NameBuffer,32
		test	eax, eax
		jnz	@genkey
		invoke SendDlgItemMessage, hWnd, IDC_SERIAL, WM_SETTEXT, NULL, addr noname
		jmp @skip_algo
		@genkey:
		call Generate
		invoke SetDlgItemText,hWnd,IDC_SERIAL,addr SerialBuffer
		@skip_algo:
	.elseif eax==IDC_COPY
		invoke SendDlgItemMessage,hWnd,IDC_SERIAL,EM_SETSEL,0,-1
		invoke SendDlgItemMessage,hWnd,IDC_SERIAL,WM_COPY,0,0
	.elseif eax==IDC_ABOUT
		invoke DialogBoxParam, hInstance, IDD_ABOUT, hWnd, addr aboutwndproc, NULL
	.endif
.elseif	uMsg == WM_CLOSE
	invoke	EndDialog,hWnd,0
.endif        
    xor	eax,eax
    ret 
DlgProc endp 

aboutwndproc PROC ahWnd:HWND, auMsg:UINT, awParam:WPARAM, alParam:LPARAM

.if auMsg==WM_CLOSE
	invoke EndDialog, ahWnd, NULL

.elseif auMsg==WM_CTLCOLORDLG
	invoke CreateSolidBrush,  000000h
	ret

.elseif auMsg==WM_CTLCOLORSTATIC
	mov eax, alParam
	invoke SetTextColor, awParam, White
	invoke SetBkMode, awParam, TRANSPARENT
	invoke CreateSolidBrush, 000000h
	invoke SetBkColor, awParam, eax
	invoke CreateSolidBrush,  000000h
	ret

.else
	mov eax, FALSE
	ret
.endif
	mov eax, TRUE
	ret
	
aboutwndproc ENDP

Generate proc

push eax
push ebx
push ecx
push edx

invoke lstrlen, addr NameBuffer
mov ecx, eax
mov	eax, offset NameBuffer
mov edx, 1
xor 	ebx, ebx

@addnamechar:
	mov bl, byte ptr [eax]
	add edx, ebx
	inc eax
	dec ecx
	JNZ @addnamechar

mov eax, edx
shl eax, 6
add eax, edx
lea ecx, dword ptr ds:[eax+eax*8]
lea ebx, dword ptr ds:[edx+ecx*4+15E15h]
invoke wsprintf, addr SerialBuffer, addr format, ebx

pop edx
pop ecx
pop ebx
pop eax

ret

Generate endp

end start 
;#####################################################
;#  ART of REVERSE ENGINEERING - AoRE		         # 
;#####################################################
;#      			  		                         #
;# Keygen / Keygenme Template   		             #
;# Coded by azmo / AoRE 			                 #
;#						                             #
;#####################################################
;# 													 #
;#  Thx to Goppit, reversing.be, Canterwood [N-GEN]  # 
;#  and Angel-55 [FOFF]							     #
;#													 #
;#####################################################


.386 
.model flat,stdcall 
option casemap:none 

include		windows.inc 
include		kernel32.inc 
include		user32.inc 
include     gdi32.inc  
include     shell32.inc
include		ufmodapi.inc
include		masm32.inc

includelib	kernel32.lib
includelib	user32.lib 
includelib 	gdi32.lib
includelib 	shell32.lib
includelib	uFMOD.lib
includelib	winmm.lib
includelib 	masm32.lib

DlgProc			proto		 :DWORD,:DWORD,:DWORD,:DWORD 

.data
include chiptune.inc
xmSize equ $ - table

.data? 
hInstance		HINSTANCE	? 
SerialBuffer	db	22 dup(?) 
handle			dd		?
.const
IDD_KEYGEN		equ		1001
IDC_SERIAL		equ		1003
IDC_GENERATE	equ		1004
IDC_EXIT		equ		1008
AoREIcon		equ		2001


.code 
start: 
    invoke GetModuleHandle, NULL 
    mov    hInstance,eax 
    invoke DialogBoxParam, hInstance, IDD_KEYGEN, NULL, addr DlgProc, NULL 
    invoke ExitProcess,eax 
    
DlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
.if uMsg == WM_INITDIALOG
		
	invoke 	LoadBitmap, hInstance, 10 
	invoke 	SendDlgItemMessage, hWnd, IDC_GENERATE, BM_SETIMAGE, IMAGE_BITMAP, eax
	invoke 	LoadBitmap, hInstance, 11 
	invoke 	SendDlgItemMessage, hWnd, IDC_EXIT, BM_SETIMAGE, IMAGE_BITMAP, eax
	invoke	LoadIcon,hInstance,AoREIcon
	invoke  uFMOD_PlaySong, addr table, xmSize, XM_MEMORY 
	invoke  AnimateWindow,hWnd,3500,AW_BLEND+AW_ACTIVATE
	
.elseif uMsg==WM_LBUTTONDOWN							
		invoke SendMessage,hWnd,WM_NCLBUTTONDOWN,HTCAPTION,lParam

.elseif uMsg==WM_CTLCOLORSTATIC
	mov eax, lParam
	invoke SetTextColor, wParam, 00B0FFh 
	invoke SetBkMode, wParam, TRANSPARENT
	invoke CreateSolidBrush,  000000h
	invoke SetBkColor, wParam, eax
	invoke CreateSolidBrush,  000000h
    ret
        
.elseif uMsg == WM_COMMAND
	mov	eax,wParam
	.if eax==IDC_GENERATE
		call 	Generate
		invoke 	SetDlgItemText,hWnd,IDC_SERIAL, addr SerialBuffer

	.elseif eax==IDC_EXIT 
		invoke	SendMessage,hWnd,WM_CLOSE,0,0
		
	.endif
	
.elseif	uMsg == WM_CLOSE
	invoke  uFMOD_PlaySong,0,0,0 
	invoke 	AnimateWindow,hWnd,2000,AW_BLEND+AW_HIDE
	invoke	EndDialog,hWnd,0
.endif        
    xor	eax,eax
    ret 
DlgProc endp 

Generate proc

push eax
push ebx
push ecx
push edx
push edi

xor ecx,ecx

@loop:
   push ecx
   call Randomd
   pop	ecx 
   mov  byte ptr[SerialBuffer+ecx], al
   inc  ecx 
   cmp	ecx, 22
   jnz	@loop  

pop	edi
pop edx
pop ecx
pop ebx
pop eax

ret

Generate endp
Randomd Proc

   INVOKE Sleep,5                                
   INVOKE GetTickCount                              
   INVOKE nseed,EAX                               
   INVOKE nrandom,0FFFFFFFFh                    

   INVOKE nseed,EAX                 
@Again:
   INVOKE nrandom,39h                            
   CMP 	  EAX,31h                                   
   JL 	  @Again1
   JMP 	  @ENDN                                
@Again1:
   INVOKE nrandom,5Ah                            
   CMP 	  EAX,41h                               
   JL 	  @Again
@ENDN:                                      
   RET

Randomd EndP

end start

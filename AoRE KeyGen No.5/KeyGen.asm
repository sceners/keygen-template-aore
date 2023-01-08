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
include     gdi32.inc  
include     shell32.inc
include		ufmodapi.inc

includelib	kernel32.lib
includelib	user32.lib 
includelib 	gdi32.lib
includelib 	shell32.lib
includelib	uFMOD.lib
includelib	winmm.lib


DlgProc			proto		 :DWORD,:DWORD,:DWORD,:DWORD 


.data
include chiptune.inc
xmSize equ $ - table

noname			db  "Please insert your name",0
AboutStr		db	"SandMan KeyGen Template",10,13
				db	"~Coded by azmo[aore]~",10,13,10,13
				db	"Greetz fly to:",10,13
				db	"ColdFever, Sgr2001, NoLimit, TALLFAZ and Jifriz", 10, 13
				db	"and to all AoRE forum members ...", 10, 13, 10, 13
				db  "http://www.aoreteam.com/vb", 10, 13
				db	"http://azmoaore.reversedcode.com", 0
				
AboutCap		db	"About",0

format       	db  "%X",0
fixedstr		db	"40R3-7348-",0

.data? 
hInstance		HINSTANCE	?  
NameBuffer		db		32 dup(?) 
SerialBuffer	db		32 dup(?)

.const
IDD_KEYGEN		equ		1001
IDC_NAME		equ		1002
IDC_SERIAL		equ		1003
IDC_GENERATE	equ		1004
IDC_ABOUT		equ		1006
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
		
	invoke 	LoadBitmap, hInstance, 23 
	invoke 	SendDlgItemMessage, hWnd, IDC_GENERATE, BM_SETIMAGE, IMAGE_BITMAP, eax
	invoke 	LoadBitmap, hInstance, 25 
	invoke 	SendDlgItemMessage, hWnd, IDC_ABOUT, BM_SETIMAGE, IMAGE_BITMAP, eax
	invoke 	LoadBitmap, hInstance, 26 
	invoke 	SendDlgItemMessage, hWnd, IDC_EXIT, BM_SETIMAGE, IMAGE_BITMAP, eax
	invoke	LoadIcon,hInstance,AoREIcon
	invoke	SendMessage,hWnd,WM_SETICON,1,eax
	invoke 	GetDlgItem,hWnd,IDC_NAME
	invoke 	SetFocus,eax
	invoke  uFMOD_PlaySong, addr table, xmSize, XM_MEMORY 
	invoke  AnimateWindow,hWnd,2500,AW_BLEND+AW_ACTIVATE
	
.elseif uMsg==WM_LBUTTONDOWN							
		invoke SendMessage,hWnd,WM_NCLBUTTONDOWN,HTCAPTION,lParam
.elseif uMsg==WM_CTLCOLOREDIT
	mov eax, lParam
	invoke SetTextColor, wParam, 0070FFh
	invoke CreateSolidBrush,000000h
	invoke SetBkColor, wParam, TRANSPARENT
	invoke CreateSolidBrush, 000000h
	ret

.elseif uMsg==WM_CTLCOLORSTATIC
	mov eax, lParam
	invoke SetTextColor, wParam, 0070FFh
	invoke SetBkMode, wParam, TRANSPARENT
	invoke CreateSolidBrush,  000000h
	invoke SetBkColor, wParam, eax
	invoke CreateSolidBrush,  000000h
    ret
        
.elseif uMsg == WM_COMMAND
	mov	eax,wParam
	.if eax==IDC_GENERATE
	
		invoke 	GetDlgItemText,hWnd,IDC_NAME,addr NameBuffer,32
		test	eax, eax
		jnz		@genkey
		invoke 	SendDlgItemMessage, hWnd, IDC_SERIAL, WM_SETTEXT, NULL, addr noname
		jmp 	@skip_algo
		@genkey:
		call 	Generate
		invoke 	SetDlgItemText,hWnd,IDC_SERIAL,addr fixedstr
		@skip_algo:
		
	.elseif eax==IDC_ABOUT
	
		invoke MessageBox,hWnd,addr AboutStr,addr AboutCap,MB_ICONINFORMATION
		
	.elseif eax==IDC_EXIT 
	
		invoke	SendMessage,hWnd,WM_CLOSE,0,0
		
	.endif
	
.elseif	uMsg == WM_CLOSE
	invoke  uFMOD_PlaySong,0,0,0 
	invoke 	AnimateWindow,hWnd,2500,AW_BLEND+AW_HIDE
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

	mov eax, offset fixedstr
	mov byte ptr [eax+0Ah], 00h
	xor	eax, eax 
	xor	edi, edi
	mov	ecx, offset NameBuffer
	mov	al, byte ptr [ecx]
	
@nextcalc:

	cmp al, 61h
	jl 	@Space
	cmp al, 7Ah
	jg 	@Space
	add al, 0E0h
	
@Space:

	cmp al,20h
	je	@nextchar
	cmp al,0Dh
	je	@nextchar
	cmp al,0Ah	
	je	@nextchar
	lea edx,DWORD PTR [edi*8]
	movsx eax, al
	sub edx, edi
	add edx, eax
	mov edi, edx
	
@nextchar:	

	mov al, byte ptr [ecx+1]
	inc	ecx
	test al, al
	jnz	@nextcalc
	
	mov esi, 68EDB63Eh
	lea eax, dword ptr [edi+edi*2]
	add esi, eax
	jns @step
	neg esi
	
@step:

	invoke wsprintf, addr SerialBuffer, addr format, esi
	invoke lstrcat, addr fixedstr,addr SerialBuffer

pop	edi
pop edx
pop ecx
pop ebx
pop eax

ret

Generate endp

end start
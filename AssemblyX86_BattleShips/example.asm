.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf:proc
extern scanf:proc
includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "VAPORASE",0
area_width EQU 1280
area_height EQU 720
area DD 0
mesaj1 db "m si n? ",13,10,0
text1 db "%d",0
text3a db "%d",13,10,0
text5 db "%d ",0
text6 db 13,10,0
px dd 0 ;; pentru matricea cu vapoare
py dd 0 ;;
oct dd 0
lungime_patratel_div_n dd 0
latime_patratel_div_m dd 0
 b5 dd 4
 b4 dd 3
 b31 dd 2
 b32 dd 2
 b2 dd 1
 err dd 0
ar_mat dd 0
adrmat dd 0
adrfin dd 0
adrrev dd 0
counter DD 0 ; numara evenimentele de tip timer
conclick dd 0
arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20
text3 db "ceva care este: %d",13,10,0
symbol_width EQU 10
pl_ar_x1 dd 335
pl_ar_y1 dd 59
pl_ar_x2 dd 937
pl_ar_y2 dd 660
pl_ar_lat dd 600
pl_ar_lat_patrat dd 602
ship_parts dd 0
ratari dd 0
succes dd 0
m dd 0
n dd 0
zx dd 0
zy dd 0
mn_ok dd 0
symbol_height EQU 20

include digits.inc
include letters.inc

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
afisare macro adrmat,area,texta,textb
local buclafor,bucla_while


mov esi,0
buclafor:
mov edi,0

bucla_while:
mov eax, esi
shl eax,2
add eax, adrmat
 ;;;
;mov ebx,dword ptr [eax]
mov ebx, eax
push ebx
push offset texta
call printf
add esp,8
;;;
inc esi
inc edi
cmp edi,n
jne bucla_while
;;;
push offset textb
call printf
add esp,4
cmp esi,area
jne buclafor

endm

nr_part_barca macro adrmat,ar

local buclafor3,pas
mov esi,0
buclafor3:

mov eax, esi
shl eax,2
add eax, adrmat
mov ebx,dword ptr [eax]

cmp ebx,1
jne pas
inc ship_parts
pas:
inc esi
cmp esi,ar
jne buclafor3

endm
initi_mat macro adrmat,area
local buclafor2
mov esi,0
buclafor2:

mov eax, esi
shl eax,2
add eax, adrmat
mov dword ptr [eax],0

inc esi
cmp esi,area
jne buclafor2
endm

make_boat macro adr,b,n,m,adrfin,adrmat,er
	local afar2,bucla_barca,in_jos,in_dreapta,in_dreapta2,in_stanga,in_stanga2,in_sus,in_sus2,afar
	mov eax,adr
	mov ecx,0
	bucla_barca:
	mov ebx,m
	cmp ebx,b
	jl in_stanga
	in_jos:
	add eax,n
	add eax,n
	add eax,n
	add eax,n
	cmp eax,adrfin
	ja in_sus
	mov esi, dword ptr [eax]
	cmp esi,1
	je in_sus
	mov dword ptr [eax],1
	inc ecx
	cmp ecx,b
	jne in_jos
	
	;;; in cazul in care pune barca in jos  cu totul vad daca am terminat construirea ei
	cmp ecx,b
	je afar2
	
	in_sus:
	mov eax,adr
	in_sus2:
	sub eax,n
	sub eax,n
	sub eax,n
	sub eax,n
	cmp eax,adrmat
	jb in_stanga
	;jb afar
	mov esi, dword ptr [eax]
	cmp esi,1
	je in_stanga
	;je afar
	mov dword ptr [eax],1
	inc ecx
	cmp ecx,b
	jne in_sus2
	
	cmp ecx,b
	je afar2
	
	in_stanga:
	;; observ ca pozitia ce-a mai din stanga in matrice se imparte exact la n
	mov eax,adr
	mov oct,4
	in_stanga2:
	sub eax,oct
	mov edx,0
	mov ebx,n
	dec ebx
	div ebx
	cmp edx,0
	jz in_dreapta
	mov eax,adr
	sub eax,oct
	mov esi,dword ptr [eax]
	cmp esi,1
	jz in_dreapta
	cmp eax, adrmat
	jb in_dreapta
	mov dword ptr [eax],1
	add oct,4
	inc ecx 
	cmp ecx,b
	jne in_stanga2
	
	cmp ecx,b
	je afar2
	
	in_dreapta:
	mov eax,adr
	mov oct,4
	in_dreapta2:
	add eax,oct
	mov edx,0
	mov ebx,n
	div ebx
	cmp edx,0
	je afar
	mov eax,adr
	add eax,oct
	mov esi, dword ptr [eax]
	cmp esi,1
	je afar
	mov dword ptr [eax],1 
	add oct,4
	inc ecx
	cmp ecx,b
	jne in_dreapta2
	
	cmp ecx,b
	je afar2
	
	afar:
 mov er,1
 afar2:
 
	endm
	
	
gen_macro macro nrG,adrmat,adrrev
	local bucla_generare 
	mov ecx,0
	bucla_generare:
 mov edx,0
 mov eax,0
 mov ebx,0
 ;;;;;;
 rdtsc 
 add ebx, eax
 rdtsc
 add ebx, eax
 rdtsc
 add ebx,eax
 rdtsc
 add ebx,eax
 rdtsc
 add ebx,eax
 mov eax, ebx
 
 ;;;;
  mov ebx,ar_mat
  mov edx,0
  div ebx
  ;;;; aflarea poz in mat;;;
	
	mov eax,edx
	shl eax,2
	add eax,adrmat
	;;;; validare generare;;;
	
	mov edi,dword ptr[eax]
	cmp edi,1
	je bucla_generare
	;;; mutare nr validat in mat;;;
	mov dword ptr [eax],1
	mov adrrev,eax
	inc ecx
	cmp ecx,nrG
	jne bucla_generare
	
	endm
	


make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0CCCCCCh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

make_vertical_lin macro x,y,len,color
local bucla
	mov eax,y
	mov ebx, area_width
	mul ebx	
	add eax,x
	shl eax,2
	add eax, area
	mov ecx, len
	bucla:
	mov dword ptr[eax],color
	add eax, area_width*4
	loop bucla
endm
make_horizontal_lin macro x,y,len,color
local bucla
	mov eax,y
	mov ebx, area_width
	mul ebx	
	add eax,x
	shl eax,2
	add eax, area
	mov ecx, len
	bucla:
	mov dword ptr[eax],color
	add eax, 4
	loop bucla
endm


make_patrat macro x,y,pxlin,nrl,color
local bucla1,finp,desenare

mov ecx,nrl
bucla1:
	mov eax,y
	add eax,ecx
	mov ebx, area_width
	mul ebx	
	add eax,x
	shl eax,2
	add eax, area
	mov edx,0
	mov edx,pxlin
	
	desenare:
cmp edx,0

jz	finp
	mov dword ptr[eax],color
	add eax, 4
	dec edx
	jmp desenare
	finp:
	
	loop bucla1
endm

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc

	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	
	;;;;-background-;;;;;
	make_vertical_lin 195,0,719,666666h
	make_vertical_lin 1083,0,719,666666h
	make_patrat 0,0,195,719,0CCCCCCh
	make_patrat 1084,0,196,719,0CCCCCCh
	make_patrat 196,0,887,719,66D4F7h
	
	;;;;;;;;;;;;;;;;;;;;;
	; dreptunghiul GRI stanga de la 0 la 195
	; dreptunghiul GRI dreapta de la 1083 pana la 1279
	; dreptunghi CYAN de la 196 pana la 1082
	;;;;;;-play area la (335, 59) (x,y)-;;;;
	make_vertical_lin pl_ar_x1,pl_ar_y1,pl_ar_lat,0000FFh
	make_horizontal_lin pl_ar_x1,pl_ar_y1,pl_ar_lat_patrat,0000FFh
	make_vertical_lin pl_ar_x2,pl_ar_y1,pl_ar_lat_patrat,0000FFh
	make_horizontal_lin pl_ar_x1,pl_ar_y2,pl_ar_lat_patrat,0000FFh
	
	make_text_macro 'L', area, 48, 120
	make_text_macro 'O', area, 58, 120
	make_text_macro 'V', area, 68, 120
	make_text_macro 'I', area, 78, 120
	make_text_macro 'T', area, 88, 120
	make_text_macro 'U',area, 98,120
	make_text_macro 'R',area, 108,120
	make_text_macro 'I',area, 118,120
	
	make_text_macro 'R',area,1140,120
	make_text_macro 'A',area,1150,120
	make_text_macro 'T',area,1160,120
	make_text_macro 'A',area,1170,120
	make_text_macro 'R',area,1180,120
	make_text_macro 'I',area,1190,120
	
	make_text_macro 'S',area,1140,250
	make_text_macro 'U',area,1150,250
	make_text_macro 'C',area,1160,250
	make_text_macro 'C',area,1170,250
	make_text_macro 'E',area,1180,250
	make_text_macro 'S',area,1190,250
	
	make_text_macro 'P',area,1144,350
	make_text_macro 'A',area,1154,350
	make_text_macro 'R',area,1164,350
	make_text_macro 'T',area,1174,350
	make_text_macro 'I',area,1184,350
	
	make_text_macro 'R',area,1140,380
	make_text_macro 'A',area,1150,380
	make_text_macro 'M',area,1160,380
	make_text_macro 'A',area,1170,380
	make_text_macro 'S',area,1180,380
	make_text_macro 'E',area,1190,380
	
	;;;;- afisare celule-;;;;
	;;;--- 1 coloane ---;;;
	mov esi,0
	mov eax,pl_ar_x1
	mov zx,eax
	mov eax,pl_ar_y1
	mov zy,eax
	mov eax,0
bucla_coloane:
make_vertical_lin zx,zy,pl_ar_lat, 0000FFh 
mov eax,zx
	add eax,lungime_patratel_div_n
	mov zx,eax
inc esi
cmp esi,n
jne bucla_coloane
	
	;;;; ---- 2 linii ---;;;
		mov esi,0
	mov eax,pl_ar_x1
	mov zx,eax
	mov eax,pl_ar_y1
	mov zy,eax
	mov eax,0
bucla_coloane1:
make_horizontal_lin zx,zy,pl_ar_lat, 0000FFh 
mov eax,zy
	add eax,latime_patratel_div_m
	mov zy,eax
inc esi
cmp esi,m
jne bucla_coloane1
	
	
	
	;;;;; nr lovituri;;;;
	; cifra unitatilor
	mov eax,conclick
	mov ebx,10
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 88, 140
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 78, 140
	
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 68, 140	
	
	;;;; nr ratari;;
	mov eax,ratari
	mov ebx,10
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1185, 150
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1175, 150
	
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1165, 150	
	
	;;; succes;;;
	mov eax,succes
	mov ebx,10
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1185, 280
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1175, 280
	
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1165, 280
	
	
	;;; nr parti vapor;;;
	mov ebx, 10
	mov eax,0
	mov eax, ship_parts
	mov edx,0
	; cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1185, 415
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1175, 415
	
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1165, 415
	
	
	
evt_click:

cmp ar_mat,17
jl prea_mic
cmp ar_mat,2500
ja prea_mare
	mov eax,ship_parts
	cmp eax,0
	jz victorie
	mov eax, [ebp+arg2]
	cmp eax, pl_ar_x1
	jl ar_fail
	cmp eax, pl_ar_x2
	ja ar_fail
	mov eax, [ebp+arg3]
	cmp eax, pl_ar_y1
	jl ar_fail
	cmp eax, pl_ar_y2
	ja ar_fail
	
	mov eax,[ebp+arg2]  ; eax=x
	sub eax,pl_ar_x1 ; eax= x- 335
	mov edx,0
	mov ebx,lungime_patratel_div_n
	div ebx   ; eax = (x-335): lungime_patratel_div_n - multiplier care imi da la ce celula as fi
	
	mov px,eax
	
	mov ebx,0
	mov ebx,lungime_patratel_div_n
	mov edx,0
	mul ebx   ; eax = lungime_patratel_div_n x multiplier
	add eax, 335
	
	mov zx,eax
	
	mov eax,[ebp+arg3]  ; eax=y
	sub eax,pl_ar_y1 ; eax= y- 59
	mov edx,0
	mov ebx,latime_patratel_div_m
	div ebx   ; eax = (y-59): latime_patratel_div_m - multiplier care imi da la ce celula as fi
	
	mov py,eax
	
	mov ebx,0
	mov ebx,latime_patratel_div_m
	mov edx,0
	mul ebx   ; eax = latime_patratel_div_m x multiplier
	add eax, 59
	
	mov zy,eax
	
	mov eax,zx; se va verifica daca zx+lungime_patratel_div_n va iesi din matrice
	add eax,lungime_patratel_div_n
	cmp eax,pl_ar_x2
	ja ar_fail
	
	mov eax,zy
	add eax,latime_patratel_div_m
	cmp eax,pl_ar_y2
	ja ar_fail
	
	mov eax,py
	mov edx,0
	mov ebx,n
	mul ebx
	add eax,px
	shl eax,2
	add eax,adrmat
	
	mov esi,dword ptr [eax]
	cmp esi,1
	jne patrat_albastru
	mov dword ptr [eax],3
	make_patrat zx,zy,lungime_patratel_div_n,latime_patratel_div_m,0FC4242h
	inc succes
	inc conclick
	dec ship_parts
	jmp ar_fail
	
	patrat_albastru:
	mov eax,py
	mov edx,0
	mov ebx,n
	mul ebx
	add eax,px
	shl eax,2
	add eax,adrmat
	
	mov esi,dword ptr [eax]
	cmp esi,0
	jne ar_fail
	mov dword ptr [eax],2
	make_patrat zx,zy,lungime_patratel_div_n,latime_patratel_div_m,3887e8h
	inc conclick
	inc ratari
	ar_fail:
	
	;; nr lovituri;;
	mov ebx, 10
	mov eax, conclick
	cmp eax,999
	jl cif
	mov eax,0
	mov conclick,0
	cif:
	; cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 88, 140
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 78, 140
	
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 68, 140
	
	;;; nr parti vapor;;;
	mov ebx, 10
	mov eax,0
	mov edx,0
	mov eax, ship_parts
	cmp eax,0
	; cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1185, 415
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1175, 415
	
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1165, 415
	
	;;;; nr ratari;;
	mov eax,ratari
	mov ebx,10
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1185, 150
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1175, 150
	
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1165, 150
	
	;;; succes;;;
	mov eax,succes
	mov ebx,10
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1185, 280
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1175, 280
	
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 1165, 280
	
evt_timer:
	inc counter
	
	;;;;- afisare celule-;;;;
	;;;--- 1 coloane ---;;;
	mov esi,0
	mov eax,pl_ar_x1
	mov zx,eax
	mov eax,pl_ar_y1
	mov zy,eax
	mov eax,0
bucla_coloane2:
make_vertical_lin zx,zy,pl_ar_lat, 0000FFh 
mov eax,zx
	add eax,lungime_patratel_div_n
	mov zx,eax
inc esi
cmp esi,n
jne bucla_coloane2
	
	;;;; ---- 2 linii ---;;;
		mov esi,0
	mov eax,pl_ar_x1
	mov zx,eax
	mov eax,pl_ar_y1
	mov zy,eax
	mov eax,0
bucla_coloane3:
make_horizontal_lin zx,zy,pl_ar_lat, 0000FFh 
mov eax,zy
	add eax,latime_patratel_div_m
	mov zy,eax
inc esi
cmp esi,m
jne bucla_coloane3
	
	;;;;;;-play area la (335, 59) (x,y)-;;;;
	make_vertical_lin pl_ar_x1,pl_ar_y1,pl_ar_lat,0000FFh
	make_horizontal_lin pl_ar_x1,pl_ar_y1,pl_ar_lat_patrat,0000FFh
	make_vertical_lin pl_ar_x2,pl_ar_y1,pl_ar_lat_patrat,0000FFh
	make_horizontal_lin pl_ar_x1,pl_ar_y2,pl_ar_lat_patrat,0000FFh
	
cmp ar_mat,17
jl prea_mic
cmp ar_mat,2500
ja prea_mare
	mov eax,ship_parts
	cmp eax,0
	jz victorie
afisare_litere:
	
	
	make_text_macro 'L', area, 48, 120
	make_text_macro 'O', area, 58, 120
	make_text_macro 'V', area, 68, 120
	make_text_macro 'I', area, 78, 120
	make_text_macro 'T', area, 88, 120
	make_text_macro 'U',area, 98,120
	make_text_macro 'R',area, 108,120
	make_text_macro 'I',area, 118,120
	
	make_text_macro 'R',area,1140,120
	make_text_macro 'A',area,1150,120
	make_text_macro 'T',area,1160,120
	make_text_macro 'A',area,1170,120
	make_text_macro 'R',area,1180,120
	make_text_macro 'I',area,1190,120
	
	make_text_macro 'S',area,1140,250
	make_text_macro 'U',area,1150,250
	make_text_macro 'C',area,1160,250
	make_text_macro 'C',area,1170,250
	make_text_macro 'E',area,1180,250
	make_text_macro 'S',area,1190,250
	
	make_text_macro 'P',area,1144,350
	make_text_macro 'A',area,1154,350
	make_text_macro 'R',area,1164,350
	make_text_macro 'T',area,1174,350
	make_text_macro 'I',area,1184,350
	
	make_text_macro 'R',area,1140,380
	make_text_macro 'A',area,1150,380
	make_text_macro 'M',area,1160,380
	make_text_macro 'A',area,1170,380
	make_text_macro 'S',area,1180,380
	make_text_macro 'E',area,1190,380
	jmp final_draw

 victorie:
		 make_patrat 196,20,887,30,0CCCCCCh
		make_text_macro 'V',area,568,25
		make_text_macro 'I',area,578,25
		make_text_macro 'C',area,588,25
		make_text_macro 'T',area,598,25
		make_text_macro 'O',area,608,25
		make_text_macro 'R',area,618,25
		make_text_macro 'I',area,628,25
		make_text_macro 'E',area,638,25
		jmp final_draw
	prea_mic:
	make_patrat 196,20,887,30,0CCCCCCh
	make_text_macro 'P',area,548,25
	make_text_macro 'R',area,558,25
	make_text_macro 'E',area,568,25
	make_text_macro 'A',area,578,25
	
	make_text_macro 'A',area,638,25
	make_text_macro 'P',area,648,25
	make_text_macro 'R',area,658,25
	make_text_macro 'O',area,668,25
	make_text_macro 'A',area,678,25
	make_text_macro 'P',area,688,25
	make_text_macro 'E',area,698,25
	jmp final_draw
	
	prea_mare:
	make_patrat 196,20,887,30,0CCCCCCh
	make_text_macro 'P',area,548,25
	make_text_macro 'R',area,558,25
	make_text_macro 'E',area,568,25
	make_text_macro 'A',area,578,25
	
	make_text_macro 'D',area,638,25
	make_text_macro 'E',area,648,25
	make_text_macro 'P',area,658,25
	make_text_macro 'A',area,668,25
	make_text_macro 'R',area,678,25
	make_text_macro 'T',area,688,25
	make_text_macro 'E',area,698,25
	jmp final_draw
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
		push offset mesaj1
		call printf
		add esp,4
	
		push offset m
		push offset text1
		call scanf
		add esp,8
		push offset n
		push offset text1
		call scanf
		add esp,8
		
		
		
		mov edx,0
		mov ebx,0
		mov ebx,n
		mov eax,600
		div ebx
		mov lungime_patratel_div_n,eax
	
		
		mov edx,0
		mov ebx,m
		mov eax,600
		div ebx
		mov  latime_patratel_div_m,eax
		
		
		mov edx,0
		mov eax,m
		mov ebx,n
		mul ebx
		mov ar_mat,eax
		
		
		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov ebx,ar_mat
shl ebx,2
push ebx
call malloc
add esp,4
mov adrmat,eax

mov eax, ar_mat
shl eax,2
add eax,adrmat
sub eax,4
mov adrfin,eax

initi_mat adrmat,ar_mat
	mov ebx,ar_mat
		cmp ebx,17
		jl mn_dimdif
		cmp ebx,10000
		ja mn_dimdif
		
		mov mn_ok,1
		
		
		
		mov adrrev,0
	gen_macro 1,adrmat,adrrev
	make_boat adrrev,b5,n,m,adrfin,adrmat,err
	
	mov adrrev,0
	gen_macro 1,adrmat,adrrev
	make_boat adrrev,b4,n,m,adrfin,adrmat,err
	
	mov adrrev,0
	gen_macro 1,adrmat,adrrev
	make_boat adrrev,b32,n,m,adrfin,adrmat,err
	
	mov adrrev,0
	gen_macro 1,adrmat,adrrev
	make_boat adrrev,b31,n,m,adrfin,adrmat,err
	
	 mov adrrev,0
	 gen_macro 1,adrmat,adrrev
	 make_boat adrrev,b2,n,m,adrfin,adrmat,err
	 
		nr_part_barca adrmat,ar_mat
		
		;afisare adrmat,ar_mat,text5,text6
		
	;alocam memorie pentru zona de desenat
	
	mn_dimdif:
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;					optimized		     			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;													;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Source: matrix.S 								;
;													;
;	@author: Luis Blázquez Miñambres				;
;			 Samuel Gómez Sánchez					;
;													;
;	@version: 1.0									;
;													;
;	@date: 09/04/2019								;
;													;
;	@brief: Programa de desarrollo y optimización   ;
;			del siguiente cálculo mátematico con 	;
;			matrices:								;
;													;
;	 				1								;
;	M = (A x B) * -----  + C * n					;
;				 |A + B|						    ;
;													;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.data
;---------------------------------------------------;
				; Espacio de datos

; Matrix A
A:		.float		 1.500000,		2.750000,		3.257000
		.float		21.002000,		2.658000,		2.157000
		.float		56.251000,		3.154000,		3.255000

; Matrix B
B:		.float		 3.500000,		3.500000,		2.500000
		.float		 4.500000,		4.500000,		6.500000
		.float		 5.500000,		1.500000,		2.500000

; Matrix C
C:		.float		15.000000,		17.000000,		14.000000
		.float		17.000000,		15.000000,		17.000000
		.float		14.000000,		17.000000,		15.000000

; Float number alpha
Alpha:	.float 		1.235

num:	.float		1.0

; Matrix M
M:		.float		0,		0,		0
		.float		0,		0,		0
		.float		0,		0,		0

;---------------------------------------------------;
				; Fin Espacio de datos



	.text
;---------------------------------------------------;
				; Espacio de código

				.global main
				
; Note: M[i][j] = M + (12*i + 4*j)
; or, with usual math notation: mij = M + [12*(i-1) + 4*(j-1)]
;
;                 AxB -> Stored in F0 - F8
; Products of |A + B| -> Stored in F9 - F14
; Registers from F15 and further: temporary data and operations

main:

	lf			f15,A 			; a11
	lf  		f16,B 			; b11
	
	multf		f0,f15,f16	    ; a11 * b11
	
	lf			f17,B+4 		; b12
	
	addf		f9,f15,f16	    ; a11 + b11
	
	movf		f13,f9          ; Maybe not here, we will see <<<<<<<<<<<<<<<<<
	lf			f18,A+4         ; a12
	
	multf		f1,f15,f17	    ; a11 * b12
    
    lf          f19,A+12        ; a21
    
    addf        f11,f17,f18     ; a12 + b12
    
    lf          f20,B+8         ; b13
    
    multf       f3,f16,f19      ; b11 * a21
    
    lf          f21,A+24        ; a31
    lf          f22,B+12        ; b21
    movf        f14,f11
    
    addf        f10,f19,f21     ; a21 + b21
	
	trap 0
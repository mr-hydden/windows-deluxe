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

; A + B matrix
AplusB: .float      0,      0,      0
        .float      0,      0,      0
        .float      0,      0,      0

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

	lf			f16,A 			; a11
	lf  		f17,B 			; b11
	lf			f18,B+4 		; b12
	
	multf		f0,f16,f17	    ; a11 * b11
	
	addf		f31,f16,f17	    ; a11 + b11
	
    lf          f19,A+4         ; a12
	sf          AplusB,f31      ; store(a11 + b11)
    
    multf       f1,f16,f18     ; a11 * b12
    addf        f31,f18,f19     ; a12 + b12
    
    lf          f20,B+8         ; b13
    sf          AplusB+4,f31    ; store(a12 + b12)
    
    multf        f2,f16,f20     ; a11 * b13
    
    lf          f21,A+8         ; a13
    lf          f22,A+12        ; a21
    lf          f23,B+12        ; b21
    
    addf        f31,f20,f21     ; a13 + b13
    multf        f4,f18,f22     ; a21 * b12
    
    sf          AplusB+8,f31    ; store(a13 + b13)
    
    addf        f31,f22,f23     ; a21 + b21
    
    lf          f24,A+24        ; a31
    
    multf        f5,f20,f22     ; a21 * b13
    
    lf          f25,B+24        ; b31
    sf          AplusB+12,f31   ; store(a21 + b21)
    lf          f16,B+16        ; b22
    
    addf        f31,f24,f25     ; a31 + b31
    multf        f3,f17,f22     ; a21 * b11
    
    lf          f26,A+16        ; a22
    sf          AplusB+24,f31   ; store(a31 + b31)
    lf          f27,A+20        ; b23
    
    addf        f30,f16,f26     ; a22 + b22
    multf        f6,f17,f24     ; a31 * b11
    
    lf          f22,A+20        ; a23
    sf          AplusB+16,F30   ; store(a22 + b22)
    lf          f28,A+28        ; a32
    
    addf        f31,f22,f27     ; a23 + b23
    multf        f9,f19,f23     ; a12 * b21
    
    lf          f17,B+28        ; b32
    sf          AplusB+20,F31   ; store(a23 + b23)
    lf          f29,A+32        ; a33
    
    addf        f31,f17,f28     ; a32 + b32
    multf       f10,f16,f19     ; a12 * b22
    
    lf          f29,B+32        ; b33
    sf          AplusB+28,F31   ; store (a32 + b32)
    
    trap 0 ; DEBUG
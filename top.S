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
	
	addf		f31,f16,f17	    ; a11 + b11
	multf		f0,f16,f17	    ; a11 * b11
	
    lf          f19,A+4         ; a12
	sf          AplusB,f31      ; store(a11 + b11)
    lf          f20,B+8         ; b13
    
    addf        f31,f18,f19     ; a12 + b12
    multf        f1,f16,f18     ; a11 * b12
    
    lf          f21,A+8         ; a13
    sf          AplusB+4,f31    ; store(a12 + b12)
    lf          f22,A+12        ; a21
    
    addf        f31,f20,f21     ; a13 + b13
    multf        f2,f16,f20     ; a11 * b13
    
    lf          f23,B+12        ; b21
    sf          AplusB+8,f31    ; store(a13 + b13)
    lf          f24,A+24        ; a31
    
    addf        f31,f22,f23     ; a21 + b21
    multf        f4,f18,f22     ; a21 * b12

    lf          f25,B+24        ; b31
    sf          AplusB+12,f31   ; store(a21 + b21)
    lf          f16,B+16        ; b22
    
    addf        f31,f24,f25     ; a31 + b31
    multf        f5,f20,f22     ; a21 * b13
    
    lf          f26,A+16        ; a22
    sf          AplusB+24,f31   ; store(a31 + b31)
    lf          f27,B+20        ; b23
    
    addf        f31,f16,f26     ; a22 + b22
    multf        f3,f17,f22     ; a21 * b11
    
    lf          f22,A+20        ; a23
    sf          AplusB+16,F31   ; store(a22 + b22)
    lf          f28,A+28        ; a32
    
    addf        f31,f22,f27     ; a23 + b23
    multf        f9,f19,f23     ; a12 * b21
    
    lf          f29,B+28        ; b32
    sf          AplusB+20,F31   ; store(a23 + b23)
    lf          f30,A+32        ; a33
    
    addf        f31,f28,f29     ; a32 + b32
    multf        f6,f17,f24     ; a31 * b11
    
    lf          f15,B+32        ; b33
    sf          AplusB+28,F31   ; store(a32 + b32)
	
	addf        f31,f15,f30     ; a33 + b33
    multf       f10,f16,f19     ; a12 * b22
	
	sf          AplusB+32,F31   ; store(a33 + b33)
	
	addf        f0,f0,f9        ; a11·b11 + a12·b21
	multf       f11,f19,f27     ; a12·b23
	addf        f1,f1,f10       ; a11·b12 + a12·b22
	multf       f9,f23,f26      ; a22 * b21
	addf        f2,f2,f11       ; a11·b13 + a12·b23
	multf       f10,f16,f26     ; a22 * b22
	addf        f3,f3,f9        ; a21·b11 + a22·b21
	multf       f11,f26,f27     ; a22 * b23
	addf        f4,f4,f10       ; a21·b12 + a22·b22
	multf       f9,f23,f28      ; a32 * b21
	addf        f5,f5,f11       ; a21·b13 + a22·b23
	multf       f10,f21,f29     ; a13 * b32 ; No podemos sobreescribir F9 ni esperar por F11
	
	lf          f17,AplusB
	lf          f19,AplusB+4
	lf          f26,AplusB+8
	lf          f23,AplusB+12
	
	addf        f6,f6,f9        ; a31·b11 + a32·b21
	multf       f11,f15,f21     ; a13 * b33
	addf        f1,f1,f10       ; a11b12 + a12b22 + a13b32
	multf       f9,f21,f25      ; a13 * b31
	addf        f2,f2,f11       ; a11b13 + a12b23 + a13b33
	multf       f10,f22,f29     ; a23*b32
	addf        f0,f0,f9        ; a11b11 + a12b21 + a13b31
	multf       f11,f15,f22     ; a23 * b33
	addf        f4,f4,f10       ; a21b12 + a22b22 + a23b32
	multf       f9,f22,f25      ; a23 * b31
	addf        f5,f5,f11       ; a21b13 + a22b23 + a23b33
	multf       f10,f25,f30     ; a33 * b31
	addf        f3,f3,f9        ; a21b11 + a22b21 + a23b31
	multf       f7,f18,f24      ; a31 * b12
	addf        f6,f6,f10       ; a31b11 + a32b21 + a33b31
	multf       f11,f16,f28     ; a32 * b22
	
	lf          f21,AplusB+16
	lf          f22,AplusB+20
	lf          f14,AplusB+24
	lf          f13,AplusB+28
	
	addf        f7,f7,f11       ; a31·b12 + a32·b22
	multf       f9,f29,f30      ; a33 * b32
	
	lf          f12,AplusB+32
	
	addf        f7,f7,f9        ; a31b12 + a32b22 + a33b32
	multf       f8,f20,f24      ; a31 * b13
	multf       f9,f27,f28      ; a32 * b23
	multf       f10,f15,f30     ; a33 * b33
	addf        f8,f8,f9        ; a31·b13 + a32·b23
	multf       f31,f17,f21     ; m11 * m22
	addf        f8,f8,f10       ; a31b13 + a32b23 + a33b33
	
	; From here on we calculate the determinant.
	; When finishing multiplications, load and calculate k·C 
	
	multf       f30,f19,f22     ; m12 * m23
	multf       f29,f23,f26     ; m21 * m32
	multf       f28,f21,f26     ; m13 * m22
	multf       f27,f19,f23     ; m12 * m21
	multf       f25,f17,f22     ; m11 * m23
	multf       f31,f12,f31     ; m11 * m22 * m33
	multf       f30,f14,f30     ; m12 * m23 * m31
	multf       f29,f13,f29     ; m13 * m21 * m32
	
	lf          f15,Alpha
	lf          f16,C
	lf          f17,C+4
	
	addf        f31,f31,f30
	multf       f28,f14,f28     ; m13 * m22 * m31
	
	lf          f18,C+8
	lf          f19,C+12
	lf          f20,C+16
	
	addf        f31,f31,f29
	multf       f27,f12,f27     ; m12 * m21 * m33

	lf          f21,C+20
	lf          f22,C+24
	lf          f23,C+28

	subf        f31,f31,f28
	multf       f26,f13,f25     ; m11 * m23 * m32
	subf        f31,f31,f27
	
	lf          f24,C+32
	lf          f25,num         ; F25 <- #1
	
	subf        f31,f31,f26
	
	multf       f16,f15,f16     ; @*c11
	divf        f31,f25,f31     ; 1/det(A+B) -> Llamaremos a este valor Z
	multf       f17,f15,f17     ; @*c12
	multf       f18,f15,f18     ; @*c13
	multf       f19,f15,f19     ; @*c21
	multf       f20,f15,f20     ; @*c22
	multf       f21,f15,f21     ; @*c23
	multf       f22,f15,f22     ; @*c31
	multf       f23,f15,f23     ; @*c32
	multf       f24,f15,f24     ; @*c33

	multf       f0,f0,f31       ; Z*(A x B)11
	multf       f1,f1,f31       ; Z*(A x B)12
	addf        f0,f0,f16
	sf          M, f0

	multf       f2,f2,f31       ; Z*(A x B)13
	addf        f1,f1,f17
	sf          M+4, f1

	multf       f3,f3,f31       ; Z*(A x B)21
	addf        f2,f2,f18
	sf          M+8, f2

	multf       f4,f4,f31       ; Z*(A x B)22
	addf        f3,f3,f19
	sf          M+12, f3

	multf       f5,f5,f31       ; Z*(A x B)23
	addf        f4,f4,f20
	sf          M+16, f4

	multf       f6,f6,f31       ; Z*(A x B)31
	addf        f5,f5,f21
	sf          M+20, f5

	multf       f7,f7,f31       ; Z*(A x B)32
	addf        f6,f6,f22
	sf          M+24, f6

	multf       f8,f8,f31       ; Z*(A x B)33
	addf        f7,f7,f23
	sf          M+28, f7

	addf        f8,f8,f24
	sf          M+32, f8
		
	trap 0
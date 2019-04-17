;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;					non-optimized					;
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
main:
	;------------- LOADING MATRIX -------------;

	; A will be allocated in registers f0..8

	lf	f0,A
	lf	f1,A+4
	lf	f2,A+8
	lf	f3,A+12
	lf	f4,A+16
	lf	f5,A+20
	lf	f6,A+24
	lf	f7,A+28
	lf	f8,A+32

	; B will be allocated in registers f9..17

	lf	f9,B
	lf	f10,B+4
	lf	f11,B+8
	lf	f12,B+12
	lf	f13,B+16
	lf	f14,B+20
	lf	f15,B+24
	lf	f16,B+28
	lf	f17,B+32

	; M will be allocated in registers f18..26

	; Registers f27..29 will be used for temporary operations
	; Alpha number will be allocated in Register f30 

	lf	f30,Alpha

	; Register f31 will be ALWAYS 0 as we will use it to empty other registers 

	;-------------------------------------------- (A x B) --------------------------------------------;
 
	;           (f0  f1  f2)     ( f9   f10   f11)
	; (A x B) = (f3  f4  f5)  *  (f12   f13   f14)
	;           (f6  f7  f8)     (f15   f16   f17)

	; Results will be allocated in what we considered temporary registers f27..29

	; First row of A * First Column of B >>>>>>>>>>>>> M(1,1)
	
	multf	f27,f0,f9
	multf	f28,f1,f12
	multf	f29,f2,f15

	addf	f18,f27,f28 ; Now we allocate the result in the first position of matrix M (f9)
	addf	f18,f18,f29 ; Result

	; First row of A * Second Column of B >>>>>>>>>>>>> M(1,2)

	multf	f27,f0,f10
	multf	f28,f1,f13
	multf	f29,f2,f16

	addf	f19,f27,f28 
	addf	f19,f19,f29 ; Result  

	; First row of A * Third Column of B >>>>>>>>>>>>> M(1,3)

	multf	f27,f0,f11
	multf	f28,f1,f14
	multf	f29,f2,f17

	addf	f20,f27,f28 
	addf	f20,f20,f29 ; Result 

	; Second row of A * First Column of B >>>>>>>>>>>>> M(2,1)

	multf	f27,f3,f9
	multf	f28,f4,f12
	multf	f29,f5,f15

	addf	f21,f27,f28 
	addf	f21,f21,f29 ; Result

	; Second row of A * Second Column of B >>>>>>>>>>>>> M(2,2)

	multf	f27,f3,f10
	multf	f28,f4,f13
	multf	f29,f5,f16

	addf	f22,f27,f28 
	addf	f22,f22,f29 ; Result

	; Second row of A * Third Column of B >>>>>>>>>>>>> M(2,3)

	multf	f27,f3,f11
	multf	f28,f4,f14
	multf	f29,f5,f17

	addf	f23,f27,f28 
	addf	f23,f23,f29 ; Result

	; Third row of A * First Column of B >>>>>>>>>>>>> M(3,1)

	multf	f27,f6,f9
	multf	f28,f7,f12
	multf	f29,f8,f15 

	addf	f24,f27,f28 
	addf	f24,f24,f29 ; Result

	; Third row of A * Second Column of B >>>>>>>>>>>>> M(3,2)

	multf	f27,f6,f10
	multf	f28,f7,f13
	multf	f29,f8,f16

	addf	f25,f27,f28 
	addf	f25,f25,f29 ; Result 

	; Third row of A * Third Column of B >>>>>>>>>>>>> M(3,3)

	multf	f27,f6,f11
	multf	f28,f7,f14
	multf	f29,f8,f17

	addf	f26,f27,f28 
	addf	f26,f26,f29 ; Result 

	;-------------------------------------------- (A + B) --------------------------------------------;

	; We will store the result of A + B in registers f9..17 , where matrix B is located
	; As we don´t have to use matrix A or B in any other operation 

	; First row of A + First row of B

	addf	f9,f0,f9
	addf	f10,f1,f10
	addf	f11,f2,f11

	; Second row of A + Second row of B

	addf	f12,f3,f12
	addf	f13,f4,f13
	addf	f14,f5,f14

	; Third row of A + Third row of B

	addf	f15,f6,f15
	addf	f16,f7,f16
	addf	f17,f8,f17


	;-------------------------------------------- |Result(A + B)| --------------------------------------------;

	; I will use the Laplace method to solve the determinant of the matrix. Obviously it can be solved in a better way but \_(*-*)_/
	; We will store the final result in f0. And we will empty the rest matrix A f1..f8 and matrix B f9..17
	; And we will use f1..3 and f27..29 for temporary operations

	;
	; Result(A + B) (1,1) * Det(2x2 matrix) => f9 * |f13   f14|
	;                                               |f16   f17|

	; Determinant 

	multf	f27,f13,f17
	multf 	f28,f14,f16
	subf	f29,f27,f28

	; Result

	multf	f1,f9,f29

	;
	; Result(A + B) (1,2) * Det(2x2 matrix) => - f10 * |f12   f14|
	;                                                  |f15   f17|

	; Determinant 

	multf	f27,f12,f17
	multf 	f28,f14,f15
	subf	f29,f27,f28

	; Result

	subf	f28,f31,f10 ; Because it is - f10. So f28 = 0 - f10 
	multf	f2,f28,f29

	;
	; Result(A + B) (1,3) * Det(2x2 matrix) => f11 * |f12   f13|
	;                                                |f15   f16|

	; Determinant 

	multf	f27,f12,f16
	multf 	f28,f13,f15
	subf	f29,f27,f28

	; Result

	multf	f3,f11,f29

	; Final result => f9 * |f13   f14| - f10 * |f12   f14| + f11 * |f12   f13| =>  f0 = f1 + f2 + f3
	;                      |f16   f17|         |f15   f17|         |f15   f16|

	addf	f0,f1,f2
	addf	f0,f0,f3

	;-------------------------------------------- 1/|Result(A + B)| --------------------------------------------;

	; This instruction puts a bit 1 if both registers have the same content or bit 0 if not in FPSR register
	; As f31 contains 0.0, we compare the content of this register with the result of the determinant (f0)

	eqf		f0,f31 

	; This instruction checks if FPSR register is 1 (indicating that f0 is 0.0), in that case he jumps to the end of the execution
	; If the determinant is 0, we finish the execution to avoid the division by 0

	bfpt	end   

	; We allocate 1 in register f28 for the division. And the result of the division in f0 again

	lf 		f28,num
	divf	f0,f28,f0 ; Result

	;-------------------------------------------- Result(A x B) * Result(1/|Result(A + B)|) --------------------------------------------;

	; We multiply f0 for every position of M, registers f18..26. And the results will be allocated in those registers

	multf	f18,f18,f0
	multf	f19,f19,f0
	multf	f20,f20,f0
	multf	f21,f21,f0
	multf	f22,f22,f0
	multf	f23,f23,f0
	multf	f24,f24,f0
	multf	f25,f25,f0
	multf	f26,f26,f0

	;--------------------------------------------  C * Alpha --------------------------------------------;

	; Alpha is allocated in register f30 and we will allocate matrix C in registers f9..17 where matrix B was

	lf	f9,C
	lf	f10,C+4
	lf	f11,C+8
	lf	f12,C+12
	lf	f13,C+16
	lf	f14,C+20
	lf	f15,C+24
	lf	f16,C+28
	lf	f17,C+32

	multf	f9,f9,f30
	multf	f10,f10,f30
	multf	f11,f11,f30
	multf	f12,f12,f30
	multf	f13,f13,f30
	multf	f14,f14,f30
	multf	f15,f15,f30
	multf	f16,f16,f30
	multf	f17,f17,f30

	;-------------------------------------------- Result( (A x B) * 1/|Result(A + B)|) + Result(C * Alpha) --------------------------------------------;

	; The first result is in registers f18..26 and the second result is in registers f9..17. So now we add them
	; We will allocate the results in registers f0..8 and we will empty the rest

	; First row of first result matrix + First row of second result matrix

	addf	f0,f18,f9
	addf	f1,f19,f10
	addf	f2,f20,f11

	; Second row of first result matrix + Second row of second result matrix

	addf	f3,f21,f12
	addf	f4,f22,f13
	addf	f5,f23,f14

	; Third row of first result matrix + Third row of second result matrix

	addf	f6,f24,f15
	addf	f7,f25,f16
	addf	f8,f26,f17
	
end:
	trap 0 ; End of the fucking world :D

;---------------------------------------------------;
				; Fin Espacio de código

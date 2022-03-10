.orig x3000
;this stack lab computes the polish notation of a set of calls
;push_val(4) pushes the value 4 onto the stack [4]

    LD R1, PUSH_VAL
    LD R2, ADD_VAL
    LD R4, BASE
    LD R5, MAX
    LD R6, TOS
    
    LD R0, NUM_4
    JSRR R1
    


;push_val(3) pushes the value 3 onto the stack [4,3]
LD R0, NUM_3
JSRR R1

;push_val(2) pushes the value 2 onto the stack [4,3,2]
LD R0, NUM_2
JSRR R1

;add_val() pop 3,2 and push the result of 3+2 onto the stack [4,5]
JSRR R2



;add_val() pop 4,5 and push the result of 4+5 onto the stack[9]
JSRR R2

;move the top value of the stack into r4
AND R4, R4, #0
ADD R4, R4, R0

HALT

;Local Data
BASE                .FILL   xA000
TOS                 .FILL   xA000
MAX					.FILL   xA005

PUSH_VAL            .FILL   x3400
ADD_VAL             .FILL   x3800
POP_STACK           .FILL   x4200

NUM_2               .FILL   #50
NUM_3               .FILL   #51
NUM_4               .FILL   #52

.end

;----------------------------------------------------------
;SUBROUTINE: PUSH_VAL
;----------------------------------------------------------

.orig x3400 ;;push_val(int val)implement your push function that will push a value onto the stack

    ST R0, BACKUP_R0_3400
    ST R1, BACKUP_R1_3400
    ST R2, BACKUP_R2_3400
    ST R3, BACKUP_R3_3400
    ST R7, BACKUP_R7_3400

    ADD R1, R6, #1
    
    ADD R2, R5, R1
    BRn PUSH_ERROR
    
    ADD R6, R6, #1
    
    STR R0, R6, #0 ;PUSH TO THE TOP OF STACK
    
    BRnzp PUSH_DONE ;IF WE WANT TO SKIP
    
    PUSH_ERROR
    LEA R0, OVERFLOW_STACK
    PUTS
    
    PUSH_DONE
	LD	R0, BACKUP_R0_3400
	LD	R1, BACKUP_R1_3400
	LD	R2, BACKUP_R2_3400				 
	LD	R3, BACKUP_R3_3400
	LD	R7, BACKUP_R7_3400
	
RET
	
;push_val local data

BACKUP_R0_3400	.BLKW		#1
BACKUP_R1_3400	.BLKW		#1
BACKUP_R2_3400	.BLKW		#1
BACKUP_R3_3400	.BLKW		#1
BACKUP_R7_3400	.BLKW		#1

OVERFLOW_STACK	.STRINGZ	"STACK IS FULL /n"



.end

;----------------------------------------------------------
;SUBROUTINE: ADD_VAL
;----------------------------------------------------------
.orig x3800 ;; add_val() pops two values from the top of the stack and pushes the result of adding the poppped value into the stack


	ST	R1, BACKUP_R1_3800
	ST	R2, BACKUP_R2_3800
	ST	R3, BACKUP_R3_3800
	ST	R7, BACKUP_R7_3800

	AND R1, R1, #0
	AND R2, R2, #0
	
	LD	R3,	SUB_POP_STACK
	
	JSRR R3
	ADD R1, R0, #0
	
	JSRR R3
	ADD R2, R0, #0
	
	
	;ADD
	AND R0, R0, #0
	ADD R0, R1, R2
	
	LD R3, NEG_ASCII_BASE
	ADD R0, R0, R3
	
	
	LD	R3, SUB_PUSH_VAL
	JSRR R3
		

	LD	R1, BACKUP_R1_3800
	LD	R2, BACKUP_R2_3800
	LD	R3, BACKUP_R3_3800
	LD	R7, BACKUP_R7_3800
	
RET
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data

BACKUP_R0_3800	.BLKW		#1
BACKUP_R1_3800	.BLKW		#1
BACKUP_R2_3800	.BLKW		#1
BACKUP_R3_3800	.BLKW		#1
BACKUP_R7_3800	.BLKW		#1

NEG_ASCII_BASE      .FILL       #-48
ASCII_BASE          .FILL       #48

SUB_PUSH_VAL    	.FILL		x3400
SUB_POP_STACK		.FILL		x4200


.END




.end


;----------------------------------------------------------
;SUBROUTINE: POP_STACK
;----------------------------------------------------------
.orig x4200 ;;data you might need

	ST	R1, BACKUP_R1_4200
	ST	R2, BACKUP_R2_4200
	ST	R3, BACKUP_R3_4200
	ST	R7, BACKUP_R7_4200

	ADD	R1, R6, #-1
	
	NOT R1, R1
	ADD R1, R1, #1

	ADD R2, R4, R1
	BRp POP_ERROR
	
	LDR R0, R6, #0	
	
	ADD R6, R6, #-1	
	
	BRnzp POP_DONE	

POP_ERROR
	LEA R0, STACK_UNDRFLOW
	PUTS

POP_DONE
	LD	R1, BACKUP_R1_4200
	LD	R2, BACKUP_R2_4200				 
	LD	R3, BACKUP_R3_4200
	LD	R7, BACKUP_R7_4200

RET
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data

BACKUP_R1_4200	.BLKW		#1
BACKUP_R2_4200	.BLKW		#1
BACKUP_R3_4200	.BLKW		#1
BACKUP_R7_4200	.BLKW		#1

STACK_UNDRFLOW	.STRINGZ	"THE STACK IS ALREADY EMPTY\n"

.END



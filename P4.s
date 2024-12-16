/*
 * File:   %<%NAME%>%.%<%EXTENSION%>%
 * Author: %<%USER%>%
 *
 * Created on %<%DATE%>%, %<%TIME%>%
 */

    .include "p33fj32mc202.inc"

    ; ____________________Configuration Bits____________________________
    ;User program memory is not write-protected
    #pragma config __FGS, GWRP_OFF & GSS_OFF & GCP_OFF
    
    ;Internal Fast RC (FRC)
    ;Start-up device with user-selected oscillator source
    #pragma config __FOSCSEL, FNOSC_FRC & IESO_ON
    
    ;Both Clock Switching and Fail-Safe Clock Monitor are disabled
    ;XT mode is a medium-gain, medium-frequency mode that is used to work with crystal
    ;frequencies of 3.5-10 MHz
  ; #pragma config __FOSC, FCKSM_CSDCMD & POSCMD_XT
    
    ;Watchdog timer enabled/disabled by user software
    #pragma config __FWDT, FWDTEN_OFF
    
    ;POR Timer Value
    #pragma config __FPOR, FPWRT_PWR128
   
    ; Communicate on PGC1/EMUC1 and PGD1/EMUD1
    ; JTAG is Disabled
    #pragma config __FICD, ICS_PGD1 & JTAGEN_OFF

;..............................................................................
;Program Specific Constants (literals used in code)
;..............................................................................

    .equ SAMPLES, 64         ;Number of samples



;..............................................................................
;Global Declarations:
;..............................................................................

    .global _wreg_init       ;Provide global scope to _wreg_init routine
                                 ;In order to call this routine from a C file,
                                 ;place "wreg_init" in an "extern" declaration
                                 ;in the C file.

    .global __reset          ;The label for the first line of code.

;..............................................................................
;Constants stored in Program space
;..............................................................................

    .section .myconstbuffer, code
    .palign 2                ;Align next word stored in Program space to an
                                 ;address that is a multiple of 2
ps_coeff:
    .hword   0x0002, 0x0003, 0x0005, 0x000A




;..............................................................................
;Uninitialized variables in X-space in data memory
;..............................................................................

    .section .xbss, bss, xmemory
x_input: .space 2*SAMPLES        ;Allocating space (in bytes) to variable.



;..............................................................................
;Uninitialized variables in Y-space in data memory
;..............................................................................

    .section .ybss, bss, ymemory
y_input:  .space 2*SAMPLES




;..............................................................................
;Uninitialized variables in Near data memory (Lower 8Kb of RAM)
;..............................................................................

    .section .nbss, bss, near
var1:     .space 2               ;Example of allocating 1 word of space for
                                 ;variable "var1".




;..............................................................................
;Code Section in Program Memory
;..............................................................................

.text                             ;Start of Code section
__reset:
    MOV #__SP_init, W15       ;Initalize the Stack Pointer
    MOV #__SPLIM_init, W0     ;Initialize the Stack Pointer Limit Register
    MOV W0, SPLIM
    NOP                       ;Add NOP to follow SPLIM initialization

    CALL _wreg_init           ;Call _wreg_init subroutine
                                  ;Optionally use RCALL instead of CALL




        ;<<insert more user code here>>


SETM    AD1PCFGL		; PORTB AS DIGITAL
MOV	#0xF000, W0
MOV	W0, TRISB				

MOV #0x0F, W0
MOV W0, TRISA
MOV PORTA, W12
AND #0x0F, W12				  
MOV W12, W0
AND #0x0C,W0
LSR W0,W0
LSR W0,W0
AND #0X03, W0
MOV W12, W1	
AND #0x03,W1				  
; Selección de retardo
;MOV     #1, W0          ; Cargar el caso de retardo en W0 (1 = 500ms, 2 = 350ms, 3 = 100us)
;MOV	#2, W1				  
MOV	#0x3FF, W2
MOV	#0x200, W3	
MOV	#0, W10	
MOV	#0x1, W4
MOV	#0x200, W11			  
switch_case:
    CP      W0, #1             ; Comparar W0 con 1
    BRA     Z, delay_500msx6     ; Si W0 == 1, ir a 500ms

    CP      W0, #2           ; Comparar W0 con 2
    BRA     Z, delay_350msx6     ; Si W0 == 2, ir a 350ms

    CP      W0, #3           ; Comparar W0 con 3
    BRA     Z, delay_500ms     ; Si W0 == 3, ir a 100us

; Retorno a 500ms por defecto si no coincide ninguna opción
delay_500msx6:
    MOV     #60000, W7         ; #10000 para 500ms
    BRA     delay_start

delay_350msx6:
    MOV     #42000, W7          ; #7000 para 350ms
    BRA     delay_start

delay_500ms:
    MOV     #10000, W7             ; #2 para 100us
    BRA     delay_start
    
delay_start:
LOOP1:
    CP0	    W7			        ; (1 ciclo)
    BRA	    Z,	    END_DELAY	; (1 ciclo si no hay salto)
    DEC	    W7,	    W7		    ; (1 ciclo)
    
    MOV	    #10,	W8		    ; (1 ciclo)
LOOP2:
    DEC	    W8,	    W8		    ; (1 ciclo)
    CP0	    W8			        ; (1 ciclo)
    BRA	    Z,	    LOOP1	    ; (1 ciclo si no hay salto)
    BRA	    LOOP2		        ; (2 ciclos si hay salto)

END_DELAY:
    NOP
    
switch_case2:
    CP      W1, #1             ; Comparar W0 con 1
    BRA     Z, Blink    ; Si W0 == 1, ir a 500ms

    CP      W1, #2           ; Comparar W0 con 2
    BRA     Z, Lshift    ; Si W0 == 2, ir a 350ms

    CP      W1, #3           ; Comparar W0 con 3
    BRA     Z, Rshift     ; Si W0 == 3, ir a 100us
    
Blink:
    COM	    W2, W2
    MOV	    W2, PORTB
    BRA	    done
Lshift:
    SL W4, W4
    MOV W4, PORTB
    CPSLT W4, W11
    MOV #0x1, W4
    BRA done
Rshift:
    LSR W3, W3
    MOV W3, PORTB
    CPSGT W3, W10
    MOV #0x400, W3
    BRA done   
done:	        ; Bucle infinito    
    NOP
    BRA     switch_case         ; Repetir para permitir selección continua



;..............................................................................
;Subroutine: Initialization of W registers to 0x0000
;..............................................................................

_wreg_init:
    CLR W0
    MOV W0, W14
    REPEAT #12
    MOV W0, [++W14]
    CLR W14
    RETURN


;--------End of All Code Sections ---------------------------------------------

.end                               ;End of program code in this file
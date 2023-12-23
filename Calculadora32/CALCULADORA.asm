section .data

    input_name_message DB 'Bem-vindo. Digite seu nome: ',0
    input_name_message_size EQU $ - input_name_message

    hello_message1 DB 'Hola, ',0
    hello_message2 DB ', bem-vindo ao programa de CALC IA-32', 0xa ,0
    menu_message DB '- 1: SOMA', 0xa, '- 2: SUBTRACAO', 0xa, '- 3: MULTIPLICACAO', 0xa, '- 4: DIVISAO', 0xa, '- 5: EXPONENCIACAO', 0xa, '- 6: MOD', 0xa, '- 7: SAIR', 0xa, 0

    overflow_message DB 'OCORREU OVERFLOW.',0xa, 0

    input_msg_first_value DB 'Informe o 1° valor: ', 0
    input_msg_second_value DB 'Informe o 2° valor: ', 0
    new_line DB 0xd, 0xa
    NEWLINESIZE EQU $ - new_line

    precision EQU 4
    read_write_value_precision EQU 13

section .bss
    buffer_aux RESB read_write_value_precision
    operator RESB 1
    user_name RESB 100
    string_size RESB 2

section .text
    global _start

    global precision, buffer_aux, input_msg_first_value, input_msg_second_value
    global get_string_size, read_value, print_result, print, overflow, user_await

    EXTERN sum, sub, mul, div, mod, exp

    _start: 
        PUSH input_name_message
        CALL get_string_size
        PUSH EAX
        CALL print

        PUSH DWORD 100
        PUSH user_name
        CALL read_string

        PUSH hello_message1
        CALL get_string_size
        PUSH EAX
        CALL print 

        PUSH user_name
        CALL get_string_size
        PUSH EAX
        CALL print

        PUSH hello_message2
        CALL get_string_size
        PUSH EAX
        CALL print_with_nl 

        menu:   
            PUSH menu_message
            CALL get_string_size
            PUSH EAX
            CALL print_with_nl

            PUSH DWORD 100
            PUSH operator
            CALL read_string 

            sub BYTE [operator], 0x30

            CMP BYTE [operator], 1
            je _sum
            CMP BYTE [operator], 2
            je _sub
            CMP BYTE [operator], 3
            je _mul
            CMP BYTE [operator], 4
            je _div
            CMP BYTE [operator], 5
            je _exp
            CMP BYTE [operator], 6
            je _mod

        exit:    
            MOV EAX, 1 
            MOV EBX, 0
            INT 0x80

        _sum:
            CALL sum
            JMP menu
        _sub:
            CALL sub
            JMP menu
        _mul:
            CALL mul
            JMP menu
        _div:
            CALL div
            JMP menu
        _mod:
            CALL mod
            JMP menu
        _exp:
            CALL exp
            JMP menu

; --------------------------------------------------------------------------------------------------------------------------
; INICIO SEÇÃO DE ENTRADA E SAIDA DE DADOS
; --------------------------------------------------------------------------------------------------------------------------
secao_dados:

    read_value:
        %define aux DWORD [EBP-4]
        %define negative WORD [EBP-6]
        ENTER 6, 0

        MOV aux, buffer_aux
        PUSH DWORD 12
        PUSH 	aux
        call	read_string

        MOV EAX, 0
        MOV	ECX, 0
        MOV	DX, 0
        MOV	EBX, aux
        CMP BYTE [EBX], '-'
        SETE	DL
        MOV		negative, DX
        JNE		read_value_loop
        INC		ECX
        
        read_value_loop:
            SUB BYTE [EBX+ECX], 0x30
            MOVSX	EDX, BYTE [EBX+ECX]
            ADD		EAX, EDX

            CMP BYTE [EBX+ECX+1], 0
            JE		read_value_loop_end

            MOV		EDX, EAX
            SAL		EAX, 2
            ADD		EAX, EDX
            ADD		EAX, EAX
            INC		ECX
            JMP		read_value_loop

        read_value_loop_end:
            CMP		negative, 0
            JE		read_value_end
            NEG		EAX
        read_value_end:
            LEAVE
            RET

        
    read_string:  
        ENTER	0, 0

        MOV		EAX, 3
        MOV		EBX, 0
        MOV		ECX, [EBP+8]
        MOV		EDX, [EBP+12]
        int		0x80

        MOV		EBX, [EBP+8]
        MOV BYTE [EBX+EAX-1], 0

        LEAVE
        RET 8

    print_with_nl:
        ENTER 0,0

        PUSH DWORD [EBP+12]
        PUSH DWORD [EBP+8]
        CALL print

        MOV EAX, 4 
        MOV EBX, 1
        MOV ECX, new_line
        MOV EDX, NEWLINESIZE
        INT 0x80

        LEAVE
        RET 0

    print_result:    
        %define aux DWORD [EBP-4]
        ENTER 4,0

        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX

        MOV aux, buffer_aux

        PUSH 0
        
        MOV EAX, 0
        MOV EAX, DWORD [EBP+8]

        MOV ECX, 10
        CMP EAX, 0   
        
        JGE build_result_loop

        neg EAX

        build_result_loop:
            CDQ

            IDIV ECX

            ADD EDX, 0x30

            PUSH EDX

            CMP EAX, 0

            JNE build_result_loop

        CMP DWORD [EBP+8], 0

        JGE print_result_greather_than_zero
        
        PUSH '-'

        print_result_greather_than_zero: 
            MOV EBX, aux

        build_string_result_loop:
            POP EAX

            MOV [EBX], AL

            INC EBX

            CMP EAX, 0

            JNE build_string_result_loop

        PUSH DWORD aux
        CALL get_string_size
        PUSH EAX
        CALL print_with_nl

        POP EDX
        POP ECX
        POP EBX
        POP EAX

        LEAVE
        RET 0

    print:   
        ENTER 0,0
        PUSH EAX
        PUSH EBX
        PUSH ECX
        PUSH EDX

        MOV EDX, [EBP+8]
        MOV EAX, 4
        MOV EBX, 1
        MOV ECX, [EBP+12]
        INT 0x80

        POP EDX
        POP ECX
        POP EBX
        POP EAX

        LEAVE
        RET 8

    get_string_size:     
        ENTER 0,0
        PUSH EBX

        MOV EAX,0 
        MOV EBX, [EBP+8]

        get_string_size_loop:  
            INC EAX
            INC EBX
            CMP BYTE [EBX], 0
            JNE get_string_size_loop

        POP EBX

        LEAVE
        RET 0

    user_await:
        ENTER 0,0

        MOV EAX, 3
        MOV EBX, 0
        MOV ECX, ECX
        MOV EDX, 2
        INT 0x80

        LEAVE
        RET 0

    overflow:
        PUSH overflow_message
        CALL get_string_size
        PUSH EAX
        CALL print

        JMP exit
; --------------------------------------------------------------------------------------------------------------------------
; FIM SEÇÃO DE ENTRADA E SAIDA DE DADOS
; --------------------------------------------------------------------------------------------------------------------------
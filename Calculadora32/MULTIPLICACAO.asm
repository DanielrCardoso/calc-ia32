section .text
    global mul

    EXTERN read_value, print_result, input_msg_first_value, input_msg_second_value, INPUTMSGSIZE, print, get_string_size, precision, user_await, overflow

    ; Função de multiplicação
    mul:
        ; Reserva espaço para variáveis locais
        sub esp, precision

        ; Inicializa o resultado como 0
        xor eax, eax

        ; Imprime mensagem para inserção do primeiro fator
        push input_msg_first_value
        call get_string_size
        push eax
        call print

        ; Lê o primeiro fator e armazena em eax
        call read_value 
        mov dword [esp], eax

        ; Imprime mensagem para inserção do segundo fator
        push input_msg_second_value
        call get_string_size
        push eax
        call print

        ; Lê o segundo fator
        call read_value 

        ; Multiplica os dois fatores (eax *= [esp])
        imul eax, dword [esp]

        ; Verifica se houve overflow
        jo _overflow

        ; Armazena o resultado da multiplicação em eax
        mov dword [esp], eax

        ; Imprime o resultado
        push dword [esp]
        call print_result
        add esp, 4

        ; Aguarda ação do usuário
        call user_await
                
        ; Limpa o bloco de pilha e retorna
        add esp, precision
        ret 0

    ; Rotina para tratar overflow
    _overflow:
        call overflow
        ; Limpa o bloco de pilha e retorna
        add esp, precision
        ret

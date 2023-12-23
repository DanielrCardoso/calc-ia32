section .text
    global mod

    EXTERN read_value, print_result, input_msg_first_value, input_msg_second_value, INPUTMSGSIZE, print, get_string_size, precision, user_await

    ; Função de módulo
    mod:
        ; Reserva espaço para variáveis locais
        sub esp, precision

        ; Inicializa o resultado como 0
        xor eax, eax

        ; Imprime mensagem para inserção do dividendo
        push input_msg_first_value
        call get_string_size
        push eax
        call print

        ; Lê o dividendo e armazena em eax
        call read_value 
        mov dword [esp], eax

        ; Imprime mensagem para inserção do divisor
        push input_msg_second_value
        call get_string_size
        push eax
        call print

        ; Lê o divisor
        call read_value 

        ; Move o dividendo para eax e o divisor para ebx
        mov ebx, eax
        mov eax, dword [esp]

        ; Garante que ebx não seja zero antes da divisão
        test ebx, ebx
        jz divisor_zero_error

        ; Efetua a divisão (eax/ebx), resultado em edx
        cdq
        idiv ebx

        ; Armazena o resto da divisão (módulo) em eax
        mov dword [esp], edx

        ; Imprime o resultado
        push dword [esp]
        call print_result
        add esp, 4

        ; Aguarda ação do usuário
        call user_await

        ; Retorna
        add esp, precision
        ret

    divisor_zero_error:
        ; Mensagem de erro se o divisor for zero
        push dword divisor_zero_error_msg
        call print
        call user_await
        add esp, 4  ; Limpa a pilha
        ret

section .data
    divisor_zero_error_msg db "Erro: Divisão por zero!", 0

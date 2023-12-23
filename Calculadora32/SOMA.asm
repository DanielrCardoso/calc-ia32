section .text
    global sum

    EXTERN read_value, print_result, input_msg_first_value, input_msg_second_value, INPUTMSGSIZE, print, get_string_size, precision, user_await

    ; Função de soma
    sum:
        ; Reserva espaço para variáveis locais
        sub esp, precision

        ; Inicializa o resultado como 0
        xor eax, eax

        ; Imprime mensagem para inserção do primeiro valor
        push input_msg_first_value
        call get_string_size
        push eax
        call print

        ; Lê o primeiro valor e armazena em eax
        call read_value 
        mov dword [esp], eax

        ; Imprime mensagem para inserção do segundo valor
        push input_msg_second_value
        call get_string_size
        push eax
        call print

        ; Lê o segundo valor e adiciona ao resultado
        call read_value 
        add eax, dword [esp]

        ; Armazena o resultado da soma em dword [esp]
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

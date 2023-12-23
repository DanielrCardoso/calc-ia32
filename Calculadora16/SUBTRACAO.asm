section .text
    global sub
    extern read_value, print_result, input_msg_first_value, input_msg_second_value, print, get_string_size, precision, user_await

    sub:
        ; Reserva espaço para variáveis locais
        enter precision, 0

        ; Inicializa o resultado como 0
        xor ax, ax
        mov [ebp-2], ax

        ; Exibe a mensagem para o primeiro valor
        push input_msg_first_value
        call get_string_size
        push eax
        call print

        ; Lê o primeiro valor
        call read_value 
        mov [ebp-2], ax

        ; Exibe a mensagem para o segundo valor
        push input_msg_second_value
        call get_string_size
        push eax
        call print

        ; Lê o segundo valor
        call read_value 

        ; Subtrai o segundo valor do primeiro
        sub [ebp-2], ax

        ; Exibe o resultado
        push word [ebp-2]
        call print_result
        add esp, 2

        ; Aguarda a interação do usuário
        call user_await

        ; Libera espaço para variáveis locais
        leave
        ret 0

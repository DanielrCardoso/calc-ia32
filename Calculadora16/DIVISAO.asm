section .text
    global div
    extern read_value, print_result, input_msg_first_value, input_msg_second_value, print, get_string_size, user_await, precision

div:
    ; Reserva espaço para variáveis locais
    sub esp, precision

    ; Inicializa o resultado como 0
    xor ax, ax
    mov [esp], ax

    ; Exibe a mensagem e lê o primeiro valor
    push input_msg_first_value
    call get_string_size
    push eax
    call print
    call read_value 
    mov [esp], ax

    ; Exibe a mensagem e lê o segundo valor
    push input_msg_second_value
    call get_string_size
    push eax
    call print
    call read_value 

    ; Faz a divisão
    mov bx, ax
    mov ax, [esp]
    cwd
    idiv bx
    mov [esp], ax

    ; Exibe o resultado
    push word [esp]
    call print_result
    add esp, 2

    ; Aguarda a interação do usuário
    call user_await
                
    ; Libera espaço para variáveis locais
    add esp, precision
    ret

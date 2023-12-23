section .text
    global sub

    EXTERN read_value, print_result, input_msg_first_value, input_msg_second_value, INPUTMSGSIZE, print, get_string_size, precision, user_await

    ; Função de subtração
    sub:
        %DEFINE result DWORD [EBP-4]

        ; Inicializa o bloco de pilha para variáveis locais
        ENTER precision, 0

        ; Inicializa o resultado como 0
        MOV result, 0

        ; Imprime mensagem para inserção do primeiro valor
        PUSH input_msg_first_value
        CALL get_string_size
        PUSH EAX
        CALL print

        ; Lê o primeiro valor e armazena em result
        CALL read_value 
        MOV result, EAX

        ; Imprime mensagem para inserção do segundo valor
        PUSH input_msg_second_value
        CALL get_string_size
        PUSH EAX
        CALL print

        ; Lê o segundo valor e subtrai do resultado
        CALL read_value 
        SUB result, EAX

        ; Imprime o resultado
        PUSH result
        CALL print_result
        ADD ESP, 4

        ; Aguarda ação do usuário
        CALL user_await

        ; Limpa o bloco de pilha e retorna
        LEAVE
        RET 0

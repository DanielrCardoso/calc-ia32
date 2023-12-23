section .text
    global exp

    EXTERN read_value, print_result, input_msg_first_value, input_msg_second_value, INPUTMSGSIZE, print, get_string_size, precision, overflow, user_await

    ; Função de exponenciação
    exp:
        %DEFINE result DWORD [EBP-4]

        ; Inicializa o bloco de pilha para variáveis locais
        ENTER precision, 0

        ; Inicializa o resultado como 0
        MOV result, 0

        ; Imprime mensagem para inserção da base
        PUSH input_msg_first_value
        CALL get_string_size
        PUSH EAX
        CALL print

        ; Lê a base e armazena em result
        CALL read_value 
        MOV result, EAX

        ; Imprime mensagem para inserção do expoente
        PUSH input_msg_second_value
        CALL get_string_size
        PUSH EAX
        CALL print

        ; Lê o expoente e armazena em EBX
        CALL read_value 
        MOV EBX, EAX
        MOV EAX, result

        ; Inicializa ESI como 1 (contador do loop)
        MOV ESI, 1

        ; Loop para calcular a exponenciação (result^EBX)
        exp_loop:
            ; Compara ESI com EBX (expoente)
            CMP ESI, EBX
            JGE end  ; Se ESI >= EBX, encerra o loop

            ; Multiplica result por si mesmo
            IMUL result

            ; Verifica se houve overflow
            JO _overflow

            ; Incrementa ESI (contador do loop)
            INC ESI

            ; Salta de volta para o início do loop
            JMP exp_loop
        
        end:
            ; Armazena o resultado da exponenciação em result
            MOV result, EAX

            ; Imprime o resultado
            PUSH result
            CALL print_result
            ADD ESP, 4

            ; Aguarda ação do usuário
            CALL user_await

            ; Limpa o bloco de pilha e retorna
            LEAVE
            RET

    ; Rotina para tratar overflow
    _overflow:
        CALL overflow

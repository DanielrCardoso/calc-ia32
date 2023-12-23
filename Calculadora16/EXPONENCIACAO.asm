section .text
    global exp

    EXTERN read_value, print_result, input_msg_first_value, input_msg_second_value, INPUTMSGSIZE, print, get_string_size, precision, overflow, user_await

    exp:
        %DEFINE result WORD [EBP-2]
        ENTER precision, 0  ; Reserva espaço para variáveis locais

        MOV result, 0  ; Inicializa o resultado como 0

        ; Exibe a mensagem para o primeiro valor
        PUSH input_msg_first_value
        CALL get_string_size
        PUSH EAX
        CALL print

        ; Lê o primeiro valor
        CALL read_value 
        MOV result, AX

        ; Exibe a mensagem para o segundo valor
        PUSH input_msg_second_value
        CALL get_string_size
        PUSH EAX
        CALL print

        ; Lê o segundo valor
        CALL read_value 
        MOV BX, AX
        MOV AX, result

        MOV SI, 1  ; Inicializa o contador do loop de exponenciação

    exp_loop:
        CMP SI, BX  ; Compara o contador com o segundo valor
        JGE end     ; Se contador >= segundo valor, encerra o loop
        IMUL result  ; Multiplica o resultado atual por si mesmo (AX * result)
        JO _overflow ; Verifica se houve overflow na multiplicação
        INC SI       ; Incrementa o contador
        JMP exp_loop ; Salta de volta para o início do loop
        
    end:      
        MOV result, AX        ; Atualiza o resultado final
        PUSH result           ; Coloca o resultado na pilha para exibição
        CALL print_result     ; Chama a função para exibir o resultado
        ADD ESP, 2            ; Desempilha o resultado

        CALL user_await       ; Aguarda a interação do usuário

        LEAVE                 ; Libera espaço para variáveis locais
        RET 0                 ; Retorna

    _overflow:
        CALL overflow         ; Chama a função de tratamento de overflow

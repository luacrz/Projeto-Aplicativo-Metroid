.data
.include "TitleScreen.data"  # Inclui os dados da sprite

.text
.globl _start
_start:
    # Defino o frame 0 como o frame a ser utilizado
    li s1, 1
    li s0, 0xFF200604  # Endereço de seleção de frame
    sw s1, 0(s0)       # Zero o endereço para usar o frame 0

    li s0, 0xFF100000  # Defino o primeiro endereço da tela

    # Imprimo a imagem
    la t0, TitleScreen  # Coloco o endereço da imagem em t0
    lw t1, 0(t0)        # Lê o número de linhas
    lw t2, 4(t0)        # Lê o número de colunas
    li t3, 0            # Contador
    mul t4, t1, t2      # Número total de pixels
    addi t0, t0, 8      # Ajusto para apontar para o primeiro pixel da imagem

LOOP:
    beq t3, t4, FORA    # Se t3 == t4, sai do loop
    lw t5, 0(t0)        # Pego o endereço dos primeiros 4 pixels
    sw t5, 0(s0)        # Armazeno os pixels na tela
    addi t0, t0, 4      # Avanço para o próximo pixel
    addi s0, s0, 4      # Avanço para o próximo endereço da tela
    addi t3, t3, 1      # Incremento o contador de pixels
    j LOOP

FORA:
    # Loop infinito para manter a execução
    j FORA

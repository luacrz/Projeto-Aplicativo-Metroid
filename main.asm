.data
.include "TitleScreen.s" # Inclui os dados da sprite
.include "cenario1.s"
.include "Samusr0.s"
.include "Samusl0.s"
.include "Samusr1.s"
.include "Samusl1.s"
.include "Samusr2.s"
.include "Samusl2.s"
.include "Samusr3.s"
.include "Samusl3.s"
.include "Samusrjump.s"
.include "Samusljump.s"

.include "Samusr01.s"
.include "Samustransparente1.s"

MAP_POS: .word 480,0
CHAR_POS: .word 630,161
LAST_DIREC: .word 'd'
FRAME_SAMUS: .half 0
GRAVIDADE: .half 0
DELAY_JUMP: .half 0
DELAY_WALK: .half 0

.text
SETUP: 		la a0,TitleScreen #INICIA O REGISTRADOR COM A IMAGEM DO MENU
		li a1,32 # LARGURA DA IMAGEM
		li a2,0 # ALTURA DA IMAGEM
		li a3,0 #frame atual, começa em 0 e vai ser incrementado no frame  
		#FRAME 0 = 0xFF00 0000
		#FRAME 1 = 0xFF10 0000
		call PRINT
		# IMPRIMIR NO FRAME 1 TAMBÉM
		li a3,1
		call PRINT
	
	#	a0 = endereço imagem no pc
	#	a1 = x da imagem
	#	a2 = y da imagem
	#	a3 = informação do frame atual (0 ou 1)
	#	
	#	t0 = endereço do bitmap display
	#	t1 = endereço da imagem
	#	t2 = contador de linhas
	#	t3 = contador de colunas
	#	t4 = largura da imagem
	#	t5 = altura da imagem
	#
	#	FRAME 0 = 0xFF00 0000
	#	FRAME 1 = 0xFF10 0000
	
LOOP_MENU:	
		li t1,0xFF200000	# carrega o endereço de controle do KDMMIO
		lw t0,0(t1)		# Le bit de Controle Teclado
		andi t0,t0,0x0001	# mascara o bit menos significativo
	   	beq t0,zero,LOOP_MENU  	# Se não há tecla pressionada então vai para FIM
		
		j LOOP_JOGO

LOOP_JOGO:#### RENDERIZAÇÃO PERSONAGEM
		la a0,DELAY_JUMP
		lh a1,0(a0)
		addi a1,a1,1
		sh a1,0(a0)
		addi a2,zero,30
		bne a1,a2,SKIP_JUMP
		
		sh zero,0(a0)
		
		call JUMP
		call GRAVID_DOWN

SKIP_JUMP:
		call KEY2 # chama função para verificar se algum botão foi apertado
		
		xori s0,s0,1 # alterna entre os frames 
		
		la a0,cenario1 #INICIA O REGISTRADOR COM A IMAGEM DO cenario
		li a1,0 # LARGURA DA IMAGEM
		li a2,0 # ALTURA DA IMAGEM
		mv a3,s0 # alterna o frame em que trabalhamos, definir o frame atual na verdade
		call PRINT_MAPA
		
		### DECIDE QUE LADO QUE A SAMUS IRA OLHAR BASEADO NA DIREÇÃO QUE ELA ESTA INDO
		la a0, LAST_DIREC  # Carrega o endereço da string LAST_DIREC no registrador a0
		lw a1, 0(a0)       # Carrega o primeiro byte da string (o caractere 'd') em a1
	  	
		li a0,'a' # coloca o valor da tecla
		beq a1,a0,CHAR_LADO_ESQ # verifica se o usuario pressionou o 'a'
		
		li a0,'d' # coloca o valor da tecla
		beq a1,a0,CHAR_LADO_DIR # verifica se o usuario pressionou o 'd'
		
CHAR_LADO_ESQ:	
		### CONTINUAR DAQUI
		la a0, FRAME_SAMUS  # Carrega o endereço da string LAST_DIREC no registrador a0
		lh a1, 0(a0)
		add a2,zero,zero
		beq a1,a2,CHAR_0_ESQ
		addi a2,zero,1
		beq a1,a2,CHAR_1_ESQ
		addi a2,zero,2
		beq a1,a2,CHAR_2_ESQ
		addi a2,zero,3
		beq a1,a2,CHAR_3_ESQ
		addi a2,zero,4
		beq a1,a2,CHAR_JUMP_ESQ
CHAR_0_ESQ:
		la a0,Samusl0 # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
CHAR_1_ESQ:
		la a0,Samusl1 # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
CHAR_2_ESQ:
		la a0,Samusl2 # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
CHAR_3_ESQ:
		la a0,Samusl3 # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
CHAR_JUMP_ESQ:
		la a0,Samusljump # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
		
CHAR_LADO_DIR:	

### CONTINUAR DAQUI
		la a0, FRAME_SAMUS  # Carrega o endereço da string LAST_DIREC no registrador a0
		lh a1, 0(a0)
		add a2,zero,zero
		beq a1,a2,CHAR_0_DIR
		addi a2,zero,1
		beq a1,a2,CHAR_1_DIR
		addi a2,zero,2
		beq a1,a2,CHAR_2_DIR
		addi a2,zero,3
		beq a1,a2,CHAR_3_DIR
		addi a2,zero,4
		beq a1,a2,CHAR_JUMP_DIR
CHAR_0_DIR:
		la a0,Samusr0 # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
CHAR_1_DIR:
		la a0,Samusr1 # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
CHAR_2_DIR:
		la a0,Samusr2 # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
CHAR_3_DIR:
		la a0,Samusr3 # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA
CHAR_JUMP_DIR:
		la a0,Samusrjump # recebe a imagem da samus base esquerda
		j PRINT_SAMUS # CHAMA A FUNÇÃO QUE PRINTA A SAMUS PARA A ESQUERDA

		
PRINT_SAMUS:	### DESENHA A SAMUS
		la t0,CHAR_POS # carrega a posição do pesonagem em t0
		lw a1,0(t0) # posição horizontal
		
		la t1,MAP_POS # carrega a posição do mapa para saber onde o personagem esta nele
		lw a4,0(t1)
		
		sub a1,a1,a4 # realiza a subtração da posição do personagem no mapa pela tela do mapa
		
		lw a2,4(t0) # posição vertical
		mv a3,s0 # alterna o frame em que trabalhamos, definir o frame atual na verdade
		call PRINT # CHAMA A FUNÇÃO QUE PRINTA A SAMUS
		
		### AQUI O FRAME É ALTERADO
		li t0,0xFF200604 # valor para alternar os frames
		sw s0,0(t0) # colocar o valor para alternar o frame em s0 que é a variavel dos frames
		
		j LOOP_JOGO # Loop infinito para manter a execução

KEY2:	#### EXEMPLO LAMAR: VERIFICA SE O BOTÃO FOI PRESSIONADO
		li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
	   	beq t0,zero,NO_PRESS   	   	# Se não há tecla pressionada então vai para FIM
	  	lw t2,4(t1)  			# le o valor da tecla apertada
		
		li t0,'a' # coloca o valor da tecla
		beq t2,t0,COLIS_ESQ # verifica se o usuario pressionou o 'a'
		
		li t0,'d' # coloca o valor da tecla
		beq t2,t0,COLIS_DIR # verifica se o usuario pressionou o 'd'
		
		li t0,'w' # coloca o valor da tecla
		beq t2,t0,START_JUMP # verifica se o usuario pressionou o 'w'
		
		#la a0,FRAME_SAMUS # verifica se a samus está no chão
		#lh a1,0(a0)
		#li a2,4
		#beq  a1,a2,NO_PRESS
		
		#la a0,FRAME_SAMUS # se a Samus estiver parada e no chão coloca o frame inicial dela como o atual
		#sh zero,0(a0)
		
NO_PRESS:	ret
	
PRINT:		#### PREPARATIVOS PARA O BITMAP DISPLAY
		li t0,0xFF0  	# Carregar os primeiros valores para o frame 0
		add t0,t0,a3 	# Adicionar valor do frame, se for o (frame 0 a3 = 0) (frame 1 a3 = 1)
		slli t0,t0,20	# Adicionar o resto dos zeros (0 0000) SHIFT DE 20 BITS PRA ESQUERDA
		
		add t0,t0,a1 # recebe o primeiro endereço da imagem do bitmap display para começar a percorrer
		
		li t1,320 # recebe tamanho total da tela do bitmap display também
		mul t1,t1,a2 # multiplicando t1 pelo valor do Y da imagem
		add t0,t0,t1 # adicionar tudo no endereço do bitmap display mesmo
		
		addi t1,a0,8 # Apenas pular a altura e largura do arquivo de imagem
		
		mv t2,zero # zera os dois contadores para começar o processo
		mv t3,zero
		
		lw t4,0(a0) # pega a largura da imagem
		lw t5,4(a0) # pega a altura da imagem
		
		j PRINT_LINHA

PRINT_MAPA:	#### PREPARATIVOS PARA O BITMAP DISPLAY
		### ORGANIZANDO O BITMAP DISPLAY
		li t0,0xFF0  	# Carregar os primeiros valores para o frame 0
		add t0,t0,a3 	# Adicionar valor do frame, se for o (frame 0 a3 = 0) (frame 1 a3 = 1)
		slli t0,t0,20	# Adicionar o resto dos zeros (0 0000) SHIFT DE 20 BITS PRA ESQUERDA
		
		add t0,t0,a1 # recebe o primeiro endereço da imagem do bitmap display para começar a percorrer
		
		li t1,320 # recebe tamanho total da tela do bitmap display também
		mul t1,t1,a2 # multiplicando t1 pelo valor do Y da imagem
		add t0,t0,t1 # adicionar tudo no endereço do bitmap display mesmo
		
		### ORGANIZANDO O BIT INICIAL DO MAPA
		addi t1,a0,8 # Apenas pular a altura e largura do arquivo de imagem
		
		mv t2,zero # zera os dois contadores para começar o processo
		mv t3,zero
		
		lw t4,0(a0) # pega a largura da imagem
		lw t5,4(a0) # pega a altura da imagem
		
		la a6,MAP_POS # pega a posição atual do mapa para printar o lugar certo
		lw t6,0(a6)
		add t1,t1,t6
		
		j PRINT_LINHA
		
PRINT_LINHA: # PARA COMEÇAR A DESENHAR NO BITMAP DISPLAY
		lw t6,0(t1) # pega os 4 primeiros pixeis da imagem
		sw t6,0(t0) # e printa no display
		
		addi t0,t0,4 # incrementa para apontar os proximos 4 pixeis livres do display
		addi t1,t1,4 # incrementa no endereço da imagem
		
		addi t3,t3,4 # contador de colunas, para verificar até onde pode desenhar nessa linha
		blt t3,t4,PRINT_LINHA # enquanto o endereço atual for menor que a largura da linha, pode continuar desenhando na mesma linha

		#### INDO PARA PRÓXIMA LINHA APENAS
		addi t0,t0,320 # vai pra próxima linha
		sub t0,t0,t4 # volta pro inicio das colunas
		
		mv t3,zero # zera o contador de colunas para voltar para o inicio também
		addi t2,t2,1 # adiciona 1 no contador de linhas
		bgt t5,t2,PRINT_LINHA # ENQUANTO A ALTURA INTEIRA DA IMAGEM NÃO FOR IMPRESSA, NÃO PARA
		
		ret
		
COLIS_ESQ:	#### confere se pode andar pra direita
		### CARREGANDO A POSIÇÃO DA SAMUS
	    	la t0, CHAR_POS	# Carrega a posição atual da Samus
	    	lw t1, 0(t0) # Carrega a posição X atual da Samus (horizontal)
	    	lw t2, 4(t0) # Carrega a posição Y atual da Samus (vertical)
		
	    	# Obter o tamanho da linha de pixels do cenario1
	    	la a0,cenario1 # Carrega o endereço do cenario1
	    	lw t4,0(a0)    # Carrega o tamanho da linha de pixels (x) do cenario1
		
	    	# Calcular o offset para a posição da Samus no cenário
	    	mul t5,t2,t4    # Multiplica a linha pela largura para obter o offset da linha
	    	add t5,t5,t1    # Adiciona a posição X para obter o endereço exato
		
		addi t3,a0,12 ### pula os valores de tamanho da imagem do cenario e o valor para a samus se aproximar igualmente da parede
		#addi t5,t5,-2
		#add t3,a0,zero
	    	add t3,t3,t5	# adiciona todo o offset
	    	
	    	li a1,30 # contador de 36 linhas para samus
	    	
	    	
VERIFICA_PIXEIS_ESQ: ### Verificar as duas colunas à direita
		lw t1,0(t3)	# Carrega o pixel da coluna 1 à direita
	    	lw t5,4(t3)     # Carrega o pixel da coluna 2 à direita
		
	    	# Verifica se as duas colunas são pretas (0x000000)
	    	li t6,0x000000  # Valor preto
	    	bne t1,t6,COLISAO_DET_ESQ
	    	bne t5,t6,COLISAO_DET_ESQ
		##############
		addi a1,a1,-1
		add t3,t3,t4
		bnez a1,VERIFICA_PIXEIS_ESQ
		##############
		j CHAR_ESQ
COLISAO_DET_ESQ:
		la a0,GRAVIDADE # verifica se a samus está no chão
		lh a1,0(a0)
		bnez a1,COLISAO_DET_ESQ_RET
		
		la a0,FRAME_SAMUS # se a Samus estiver parada e no chão coloca o frame inicial dela como o atual
		sh zero,0(a0)
COLISAO_DET_ESQ_RET:
	    	ret

COLIS_DIR:	#### confere se pode andar pra direita
		### CARREGANDO A POSIÇÃO DA SAMUS
	    	la t0, CHAR_POS	# Carrega a posição atual da Samus
	    	lw t1, 0(t0) # Carrega a posição X atual da Samus (horizontal)
	    	lw t2, 4(t0) # Carrega a posição Y atual da Samus (vertical)
		
	    	# Obter o tamanho da linha de pixels do cenario1
	    	la a0,cenario1 # Carrega o endereço do cenario1
	    	lw t4,0(a0)    # Carrega o tamanho da linha de pixels (x) do cenario1
		
	    	# Calcular o offset para a posição da Samus no cenário
	    	mul t5,t2,t4    # Multiplica a linha pela largura para obter o offset da linha
	    	add t5,t5,t1    # Adiciona a posição X para obter o endereço exato
		
		#addi t3,a0,8 ### pula os valores de tamanho da imagem do cenario 
		add t3,a0,zero
	    	addi t3,t3,20   # Pula 20 pixels à direita
	    	add t3,t3,t5	# adiciona todo o offset
	    	
	    	li a1,30 # contador de 36 linhas para samus
	    	
	    	
VERIFICA_PIXEIS_DIR: ### Verificar as duas colunas à direita
		lw t1,0(t3)	# Carrega o pixel da coluna 1 à direita
	    	lw t5,4(t3)     # Carrega o pixel da coluna 2 à direita
		
	    	# Verifica se as duas colunas são pretas (0x000000)
	    	li t6,0x000000  # Valor preto
	    	bne t1,t6,COLISAO_DET_DIR
	    	bne t5,t6,COLISAO_DET_DIR
		##############
		addi a1,a1,-1
		add t3,t3,t4
		bnez a1,VERIFICA_PIXEIS_DIR
		##############
		j CHAR_DIR
COLISAO_DET_DIR:
		la a0,GRAVIDADE # verifica se a samus está no chão
		lh a1,0(a0)
		bnez a1,COLISAO_DET_DIR_RET
		
		la a0,FRAME_SAMUS # se a Samus estiver parada e no chão coloca o frame inicial dela como o atual
		sh zero,0(a0)
COLISAO_DET_DIR_RET:
	    	ret

JUMP:	#### executa todas as etapas do pulo
		### pega os valores de gravidade, se for 0 ou o valor maximo do salto, o salto é encerrado
		la a0,GRAVIDADE
		lh a1,0(a0)
		
		add a2,zero,zero
		beq a1,a2,END_JUMP # se o valor de gravidade for 0, não está ocorrendo salto e nada precisa ser feito
		addi a2,zero,1
		beq a1,a2,END_JUMP # se o valor de gravidade for 1, a samus está descendo e nada precisa ser feito
		addi a2,zero,50
		beq a1,a2,END_JUMP # se o valor de gravidade for o maximo definido acima, não está mais ocorrendo salto e nada precisa ser feito
		
		### CARREGANDO A POSIÇÃO DA SAMUS
	    	la t0, CHAR_POS	# Carrega a posição atual da Samus
	    	lw t1, 0(t0) # Carrega a posição X atual da Samus (horizontal)
	    	lw t2, 4(t0) # Carrega a posição Y atual da Samus (vertical)
		###addi t2,t2,31 # adiciona o tamanho da samus para verificar a parte de cima da hitbox (APENAS PARA CIMA)
		addi t2,t2,-2
	    	# Obter o tamanho da linha de pixels do cenario1
	    	la a0,cenario1 # Carrega o endereço do cenario1
	    	lw t4,0(a0)    # Carrega o tamanho da linha de pixels (x) do cenario1
		
	    	# Calcular o offset para a posição da Samus no cenário
	    	mul t5,t2,t4    # Multiplica a linha pela altura para obter o offset da linha
	    	add t5,t5,t1    # Adiciona a posição X(largura) para obter o endereço exatao
		
		addi t3,a0,14 ### pula os valores de tamanho da imagem do cenario e alguns para não verificar demais a esquerda
	    	add t3,t3,t5	# adiciona todo o offset
	    	
	    	li a1,8 # contador de 00 colunas para hitbox de cima da samus
	    	li t6,0x000000  # Valor preto
	    	
VERIF_PIXEIS_UP: ### Verificar se as duas colunas à direita são pretas (0x000000)
		lw t1,0(t3)	# Carrega o pixel da linha 1 à acima
	    	bne t1,t6,END_JUMP
	    	
	    	lw t1,1280(t3)
	    	#addi t1,t1,1280	# Carrega o pixel da linha 2 à acima
	    	bne t1,t6,END_JUMP
		##############
		addi a1,a1,-1
		addi t3,t3,1
		bnez a1,VERIF_PIXEIS_UP
		##############
		j CHAR_UP
		
END_JUMP: #### termina o pulo, colocando o valor 1 de volta na gravidade, o que libera a descida
		la a0,GRAVIDADE #
		addi a1,zero,1
		sh a1,0(a0)
		ret
#COLISAO_DET_UP: PRIMEIRA FUNÇÃO PARA QUANDO ACHASSE COLISÃO, APENAS NÂO EXECUTAVA A SUBIDA, AGORA PRECISAMOS DA "END_JUMP"	
#	    	ret
	    	
COLIS_DOWN:	#### confere se pode andar pra baixo
		### CARREGANDO A POSIÇÃO DA SAMUS
	    	la t0, CHAR_POS	# Carrega a posição atual da Samus
	    	lw t1, 0(t0) # Carrega a posição X atual da Samus (horizontal)
	    	lw t2, 4(t0) # Carrega a posição Y atual da Samus (vertical)
		###addi t2,t2,31 # adiciona o tamanho da samus para verificar a parte de baixo da hitbox (APENAS PARA BAIXO)
		addi t2,t2,31
	    	# Obter o tamanho da linha de pixels do cenario1
	    	la a0,cenario1 # Carrega o endereço do cenario1
	    	lw t4,0(a0)    # Carrega o tamanho da linha de pixels (x) do cenario1
		
	    	# Calcular o offset para a posição da Samus no cenário
	    	mul t5,t2,t4    # Multiplica a linha pela altura para obter o offset da linha
	    	add t5,t5,t1    # Adiciona a posição X(largura) para obter o endereço exatao
		
		addi t3,a0,14 ### pula os valores de tamanho da imagem do cenario e alguns para não verificar demais a esquerda
	    	add t3,t3,t5	# adiciona todo o offset
	    	
	    	li a1,8 # contador de 00 colunas para hitbox de cima da samus
	    	li t6,0x000000  # Valor preto
	    	
VERIF_PIXEIS_DOWN: ### Verificar se as duas colunas à direita são pretas (0x000000)
		lw t1,0(t3)	# Carrega o pixel da linha 1 à acima
	    	bne t1,t6,COLISAO_DET_DOWN
	    	
	    	lw t1,1280(t3)
	    	#addi t1,t1,1280	# Carrega o pixel da linha 2 à acima
	    	bne t1,t6,COLISAO_DET_DOWN
		##############
		addi a1,a1,-1
		addi t3,t3,1
		bnez a1,VERIF_PIXEIS_DOWN
		##############
		j CHAR_DOWN
COLISAO_DET_DOWN:
		la a0,GRAVIDADE
		sh zero,0(a0)
		
		la a0,FRAME_SAMUS
		lh a1,0(a0)
		addi a2,zero,4
		bne a1,a2,COLISAO_DET_DOWN_RET
		la a0,FRAME_SAMUS # se a Samus estiver voando,coloca o frame inicial dela como o atual
		sh zero,0(a0)
		
COLISAO_DET_DOWN_RET:
	    	ret

CHAR_ESQ: #### MOVIMENTA A SAMUS PARA A ESQUERDA
		la t0,MAP_POS
		lw t1,0(t0)
		addi t1,t1,-2
		sw t1,0(t0)
		
		la t0,CHAR_POS # carrega posiçao da samus em t0
		lw t1,0(t0) # carrega o x da posição para alterar
		addi t1,t1,-2 # diminiu o valor do x, para ir para a esquerda
		sw t1,0(t0) # coloca o valor de volta no char_pos
		
		li t0,'a' # coloca o valor da tecla
		la t3,LAST_DIREC # carrega a variavel de ultima direção da samus em t3
		sb t0,0(t3) # salva a ultima direção da samus como esquerda
		
		la a0,GRAVIDADE # verifica se a samus está no chão
		lh a1,0(a0)
		bnez a1,CHAR_ESQ_RET # se não estiver pula todo o processo de animação
		
		la a0,DELAY_WALK # BLOCO DE DELAY PARA ANIMACAO DE ANDAR
		lh a1,0(a0)
		addi a1,a1,1
		sh a1,0(a0)
		addi a2,zero,2
		blt a1,a2,CHAR_ESQ_RET
		sh zero,0(a0)
		
		la a0,FRAME_SAMUS # se a Samus estiver no chão coloca os frames de animação
		lh a1,0(a0)
		addi a1,a1,1
		sh a1,0(a0)
		
		li a2,4 # se o frame já for o de pulo, coloca o primeiro de andar de novo
		beq a1,a2,WALK_INIT_ANIME
		
CHAR_ESQ_RET:	ret
		
CHAR_DIR: #### MOVIMENTA A SAMUS PARA A direita
		la t0,MAP_POS
		lw t1,0(t0)
		addi t1,t1,2
		sw t1,0(t0)
		
		la t0,CHAR_POS # carrega posiçao da samus em t0
		lw t1,0(t0) # carrega o x da posição para alterar
		addi t1,t1,2 # aumenta o valor do x, para ir para a direita
		sw t1,0(t0) # coloca o valor de volta no char_pos
		
		li t0,'d' # coloca o valor da tecla
		la t3,LAST_DIREC # carrega a variavel de ultima direção da samus em t3
		sb t0,0(t3) # salva a ultima direção da samus como direita
		
		la a0,GRAVIDADE # verifica se a samus está no chão
		lh a1,0(a0)
		bnez a1,CHAR_DIR_RET # se não estiver pula todo o processo de animação
		
		la a0,DELAY_WALK # BLOCO DE DELAY PARA ANIMACAO DE ANDAR
		lh a1,0(a0)
		addi a1,a1,1
		sh a1,0(a0)
		addi a2,zero,2
		blt a1,a2,CHAR_ESQ_RET
		sh zero,0(a0)
		
		la a0,FRAME_SAMUS # se a Samus estiver no chão coloca os frames de animação
		lh a1,0(a0)
		addi a1,a1,1
		sh a1,0(a0)
		
		li a2,4 # se o frame já for o de pulo, coloca o primeiro de andar de novo
		beq a1,a2,WALK_INIT_ANIME
		
CHAR_DIR_RET:	ret

WALK_INIT_ANIME:
		li a1,1
		sh a1,0(a0)
		
		ret
		
CHAR_UP: #### MOVIMENTA A SAMUS PARA cima
		la t0,CHAR_POS # carrega posiçao da samus em t0		
		lw t1,4(t0) # carrega o y da posição para alterar
		addi t1,t1,-2 # aumenta o valor do y, para ir para a cima
		sw t1,4(t0) # coloca o valor de volta no char_pos
		
		### adiciona 1 no valor do salto
		la a0,GRAVIDADE
		lh a1,0(a0)
		addi a1,a1,1
		sh a1,0(a0)
		
		ret
		
CHAR_DOWN: #### MOVIMENTA A SAMUS PARA baixo
		la t0,CHAR_POS # carrega posiçao da samus em t0
		lw t1,4(t0) # carrega o y da posição para alterar
		addi t1,t1,2 # aumenta o valor do y, para ir para a cima
		sw t1,4(t0) # coloca o valor de volta no char_pos
		
		la a0,GRAVIDADE
		li a1,1
		sh a1,0(a0)
		
		la a0,FRAME_SAMUS # coloca o frame da samus pulando já
		li a1,4
		sh a1,0(a0)
		
		ret

GRAVID_DOWN:	#### funçao para descer
		#la a0,GRAVIDADE
		#lh a1,0(a0)
		la a0,GRAVIDADE # Carrega o valor de GRAVIDADE no registrador a0
		lh a0,0(a0)
    		li a1,2 # Carrega o valor 2 no registrador a1
    		blt a0,a1,COLIS_DOWN
		
		ret

START_JUMP: ####### inicia os valores para que o pulo ocorra
		la a0,GRAVIDADE
		lh a1,0(a0)
		
		bnez a1,NO_FLOOR
		
		addi a1,zero,2
		sh a1,0(a0)
		
		la a0,FRAME_SAMUS # coloca o frame da samus pulando já
		li a1,4
		sh a1,0(a0)
		
NO_FLOOR:	
		ret
		
		
		
		
		
		

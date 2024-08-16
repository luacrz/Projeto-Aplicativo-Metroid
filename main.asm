.data
.include "TitleScreen.s" # Inclui os dados da sprite
.include "Cenariofinal.s"
.include "Samus1.s"
.include "Samustransparente1.s"

CHAR_POS: .half 0,0

.text
SETUP: 		la a0,TitleScreen #INICIA O REGISTRADOR COM A IMAGEM DO MENU
		li a1,0 # LARGURA DA IMAGEM
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
	#	
	#	t0 = endereço do bitmap display
	#	t1 = endereço da imagem
	#	t2 = contador de linhas
	#	t3 = contador de colunas
	#	t4 = largura da imagem
	#	t5 = altura da imagem
	#
	#
	#
	#	FRAME 0 = 0xFF00 0000
	#	FRAME 1 = 0xFF10 0000

LOOP_JOGO:#### RENDERIZAÇÃO PERSONAGEM
		call KEY2 # chama função para verificar se algum botão foi apertado
		
		xori s0,s0,1 # alterna entre os frames 
		
		### APAGAR A SAMUS ANTIGA ANTES DE MOVER
		la a0,TitleScreen #INICIA O REGISTRADOR COM A IMAGEM DO MENU
		li a1,0 # LARGURA DA IMAGEM
		li a2,0 # ALTURA DA IMAGEM
		mv a3,s0 # alterna o frame em que trabalhamos, definir o frame atual na verdade
		call PRINT
		
		### DESENHA A SAMUS
		la t0,CHAR_POS #colocar o pesonagem na tela
		
		la a0,Samus1 # recebe a imagem da samus base
		lh a1,0(t0) # posição horizontal
		lh a2,2(t0) # posição vertical
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
	   	beq t0,zero,FIM   	   	# Se não há tecla pressionada então vai para FIM
	  	lw t2,4(t1)  			# le o valor da tecla tecla
		
		li t0,'a' # coloca o valor da tecla
		beq t2,t0,CHAR_ESQ # verifica se o usuario pressionou o 'a'
		
		li t0,'d' # coloca o valor da tecla
		beq t2,t0,CHAR_DIR # verifica se o usuario pressionou o 'd'
		
		li t0,'w' # coloca o valor da tecla
		beq t2,t0,CHAR_CIMA # verifica se o usuario pressionou o 'w'
		
		li t0,'s' # coloca o valor da tecla
		beq t2,t0,CHAR_BAIXO # verifica se o usuario pressionou o 's'
	
FIM:		ret				# retorna

CHAR_ESQ: #### MOVIMENTA A SAMUS PARA A ESQUERDA
		la t0,CHAR_POS # carrega posiçao da samus em t0
		lh t1,0(t0) # carrega o x da posição para alterar
		addi t1,t1,-20 # diminiu o valor do x, para ir para a esquerda
		sh t1,0(t0) # coloca o valor de volta no char_pos
		
		ret
		
CHAR_DIR: #### MOVIMENTA A SAMUS PARA A direita
		la t0,CHAR_POS # carrega posiçao da samus em t0
		lh t1,0(t0) # carrega o x da posição para alterar
		addi t1,t1,20 # aumenta o valor do x, para ir para a direita
		sh t1,0(t0) # coloca o valor de volta no char_pos
		
		ret
		
CHAR_CIMA: #### MOVIMENTA A SAMUS PARA cima
		la t0,CHAR_POS # carrega posiçao da samus em t0		
		lh t1,2(t0) # carrega o y da posição para alterar
		addi t1,t1,-32 # aumenta o valor do y, para ir para a cima
		sh t1,2(t0) # coloca o valor de volta no char_pos
		
		ret
		
CHAR_BAIXO: #### MOVIMENTA A SAMUS PARA baixo
		la t0,CHAR_POS # carrega posiçao da samus em t0
		lh t1,2(t0) # carrega o y da posição para alterar
		addi t1,t1,32 # aumenta o valor do y, para ir para a cima
		sh t1,2(t0) # coloca o valor de volta no char_pos
		
		ret
	
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

PRINT_LINHA: # PARA COMEÇAR A DESENHAR NO BITMAP DISPLAY
		lw t6,0(t1) # pega os 4 primeiros pixeis da imagem
		sw t6,0(t0) # e printa na no display
		
		addi t0,t0,4 # incrementa para apontar os proximos 4 pixeis livres do display
		addi t1,t1,4 # incrementa no endereço da imagem
		
		addi t3,t3,4 # contador de colunas, para verificar até onde pode desenhar nessa linha
		blt t3,t4,PRINT_LINHA # enquanto o endereço atual for menor que a largura da linha, pode continuar desenhando

		############ INDO PARA PRÓXIMA LINHA APENAS
		addi t0,t0,320 # vai pra próxima linha
		sub t0,t0,t4 # volta pro inicio das colunas
		
		mv t3,zero # zera o contador de colunas para voltar para o inicio também
		addi t2,t2,1 # adiciona 1 no contador de linhas
		bgt t5,t2,PRINT_LINHA # ENQUANTO A ALTURA INTEIRA DA IMAGEM NÃO FOR IMPRESSA, NÃO PARA
		
		ret

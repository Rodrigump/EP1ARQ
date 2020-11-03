.data

	arq: .asciiz "arquivo.txt" #Nome do arquivo de entrada - deve estar no mesmo folder do script
	fim: .asciiz "." #caracter que indica fim do arquivo
	buffer: .space 1024
	n: .word 0 #armazena a quantidade de elementos
	lendo_arquivo: .asciiz "\nLendo arquivo.txt\n"
	arquivo_lido: .asciiz "\nArquivo lido.\n"
	arr: .word 1024 #espaco para o vetor
	quebra: .asciiz " "

.text

	li $v0, 4
	la $a0, lendo_arquivo
	syscall

	#abre o arquivo
	li $v0, 13
	la $a0, arq
	li $a1, 0
	li $a2, 0
	syscall
	
	move $s0, $v0
	
	li $t3, 0 #iterador

	lb $t1, fim #caracter de fim do arquivo
	
	#loop que varre o arquivo.txt para contar o numero de linhas
	LOOP:
	li $v0, 14 #indica leitura do arquivo
	move $a0, $s0
	la $a1, buffer
	la $a2, 1 #le exatamente 1 byte
	syscall
	
	la $t0, buffer
	lb $t2, 0($t0)
		
	beq $t1, $t2, FIMLOOP #compara o byte lido com o "."
	
	add $t3, $t3, 1
	
	j LOOP
	
	FIMLOOP:
		
	#escreve o resultado na memoria	
	la $t0, n
	sw $t3, 0($t0)
	
	#aloca 4*n bytes pro arr
	la $t0, arr
	mul $t3, $t3, 4
	sw $t3, 0($t0)
							
	#imprime
	li $v0, 1
	lw $a0, n
	syscall
	
	li $v0, 4
	la $a0, quebra
	syscall
		
	li $v0, 16 #fecha o arquivo
	move $a0, $s0
	syscall
				
	#reabre o arquivo.txt para inserir os valores no arr
	
	li $v0, 13
	la $a0, arq
	li $a1, 0
	li $a2, 0
	syscall
	
	move $s0, $v0
	
	li $t0, 0 #iterador
	lw $t1, n #condicao de parada
	
	la $t4, arr #endereço de arr
	
	LOOP2:
	beq $t0, $t1, FIMLOOP2
	li $v0, 14 #indica leitura do arquivo
	move $a0, $s0
	la $a1, buffer
	la $a2, 1
	syscall

	la $t3, buffer #armazena eleento em $t3
	
	lb $t5, 0($t3)
	
	sub $t5, $t5, 48 #converte ASCII para inteiro
		
	sw $t5, ($t4) #Insere o valor de $t5 EM arr
	
	add $t0, $t0, 1 #incrementa
	add $t4, $t4, 4 #pula 1 byte em arr 

	j LOOP2
	
	FIMLOOP2:
	li $v0, 16 #fecha o arquivo
	move $a0, $s0
	syscall
		
	li $t0, 0
	lw $t1, n
	
	la $t2, arr
	ARRAY: #Loop que imprime o array na memoria
	beq $t0, $t1, END
	
	lw $t3, ($t2)
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	add $t0, $t0, 1
	add $t2, $t2, 4
	j ARRAY
			
	END:						
	#Encerra o programa												
	li $v0, 10
	syscall

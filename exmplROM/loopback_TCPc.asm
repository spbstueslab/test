	include 	asms\wiz\exmplROM\head.asm

;пользовательские константы
SOCK_NUMBER: 	equ 0h
DATA_BUF_H:		equ E4h
DATA_BUF_L:		equ 00h
PORT_H:			equ 7DH
PORT_L:			equ 02H

;пользовательские переменные
len_h: 			equ 	30h
len_l:			equ		31h

dest_ip_0: 		equ 	32h
dest_ip_1:		equ		33h
dest_ip_2: 		equ 	34h
dest_ip_3:		equ		35h

dest_port_h: 	equ 	36h
dest_port_l:	equ		37h
	
	org E300H

loopback_tcpc:
	;lcall hard_reset 
	
	lcall iinchip_init
	mov dptr, #init_data
	mov r3,#01h
	mov r2,dph
	mov r1,dpl
	lcall init_w5100
	
loopback_tcpc_main_cycle:
	mov r7, #SOCK_NUMBER
	lcall getSn_SR
	mov a, r7
	cjne a, #SOCK_CLOSED, m_SOCK_CLOSE_WAIT	

	;*******Открытие сокета TCP********************
	mov dptr, #magik_buf		;
	mov a, #00			;Опции
	movx @dptr, a		;
	mov r3, #PORT_L		;
	mov r2, #PORT_H		;Порт
	mov r5, #Sn_MR_TCP	;Тип сокета
	mov r7, #SOCK_NUMBER;номер (0-3)	
	lcall socket
;************************************************

;*******Connect TCP********************
	mov dest_ip_0, #192
	mov dest_ip_1, #168
	mov dest_ip_2, #1
	mov dest_ip_3, #101
	
	mov dest_port_h, #13H
	mov dest_port_l, #8DH
	
	mov r7, #SOCK_NUMBER	;номер сокета
	
	mov r3, #00h			;
	mov r2, #00h			;указатель на адрес сервера
	mov r1, #dest_ip_0		;
	
	mov dptr, #magik_buf_2	;
	mov a, dest_port_h		;
	movx @dptr, a			;
	inc dptr				;порт сервера
	mov a, dest_port_l		;
	movx @dptr, a			;
	
	lcall connect
;************************************************	
	
	sjmp loopback_tcpc_main_cycle
	
m_SOCK_CLOSE_WAIT:
	cjne a, #SOCK_CLOSE_WAIT, m_SOCK_ESTABLISHED	
	mov r7, #SOCK_NUMBER
	lcall disconnect
	
	sjmp loopback_tcpc_main_cycle
	
m_SOCK_ESTABLISHED:
	cjne a, #SOCK_ESTABLISHED, loopback_tcpc_main_cycle
	
	mov r7, #SOCK_NUMBER
	lcall getSn_RX_RSR
	mov a, r6
	orl a, r7
	jz loopback_tcpc_main_cycle
	
	mov len_h, r6
	mov len_l, r7
	
	;******Прием данных****************************
	
	mov r7, #SOCK_NUMBER;номер сокета
	
	mov r3, #01h		;
	mov r2, #DATA_BUF_H	;указатель на буфер приемника
	mov r1, #DATA_BUF_L	;
	
	mov dptr, #magik_buf_2	;
	mov a, len_h			;
	movx @dptr, a			;количество байт для чтения
	inc dptr				;
	mov a, len_l			;
	movx @dptr, a			;
	
	lcall recv
	
	mov len_h, r6
	mov len_l, r7
	;******Прием данных конец****************************
	
	;******Отправка данных начало****************************
	mov r7, #SOCK_NUMBER	;номер сокета
		
	mov r3, #01h			;
	mov r2, #DATA_BUF_H		;указатель на буфер данных
	mov r1, #DATA_BUF_L		;
	
	mov dptr, #magik_buf_2	;
	mov a, len_h			;
	movx @dptr, a			;количество байт для отправки
	inc dptr				;
	mov a, len_l			;
	movx @dptr, a			;
	
	lcall send
	;******Отправка данных конец****************************
	ljmp loopback_tcpc_main_cycle

	
		
	
init_data:

	db 02h, 11h, 22h, 33h, 44h, 55h 	;MAC	
	db 192, 168, 1, 105					;source ip addr		;4
	db 255, 255, 255, 0					;subnet mask register		;4
	db 192, 168, 1, 1	 				;gareway addr		;4
	
	
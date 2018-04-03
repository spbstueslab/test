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
deb:		equ	38h
	
	org 8100H

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
	mov deb, #1
	mov dest_ip_0, #89
	mov dest_ip_1, #108
	mov dest_ip_2, #68
	mov dest_ip_3, #85
	
	mov dest_port_h, #00
	mov dest_port_l, #80
	
	;mov dest_ip_0, #10
	;mov dest_ip_1, #1
	;mov dest_ip_2, #210
	;mov dest_ip_3, #2
	
	;mov dest_port_h, #13h
	;mov dest_port_l, #8dh

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
	mov deb, #2
	lcall connect
	mov deb, #3
;************************************************	
	
	sjmp loopback_tcpc_main_cycle
	
m_SOCK_CLOSE_WAIT:
	cjne a, #SOCK_CLOSE_WAIT, m_SOCK_ESTABLISHED	
	mov r7, #SOCK_NUMBER
	lcall disconnect
	
	sjmp loopback_tcpc_main_cycle
	
m_SOCK_ESTABLISHED:
	cjne a, #SOCK_ESTABLISHED, loopback_tcpc_main_cycle
	mov deb, #4
	

;******Отправка данных начало****************************
	mov r7, #SOCK_NUMBER	;номер сокета
		
	mov r3, #01h			;
	;mov r2, #DATA_BUF_H		;указатель на буфер данных
	;mov r1, #DATA_BUF_L		;
	
	mov dptr, #send_data
	mov r2, dph		;указатель на буфер данных
	mov r1,dpl	

	mov dptr, #magik_buf_2	;
	mov a,#00			;
	movx @dptr, a			;количество байт для отправки
	inc dptr				;
	mov a, #88			;
	movx @dptr, a			;
	
	lcall send
	mov deb, #5	
	ret
	
		
	
init_data:

	db 02h, 11h, 22h, 33h, 44h, 55h 	;MAC	
	db 10, 1, 210,6					;source ip addr		;4
	db 255, 255, 255, 248					;subnet mask register		;4
	db 10, 1, 210,1
send_data:
	db "GET http://mcs51.h16.ru/cgi-bin/server.pl?flavor=pg0utr HTTP/1.0", 0dh, 0ah, "Host: mcs51.h16.ru", 0dh, 0ah, 0dh, 0ah			 				;gareway addr		;4
	
	
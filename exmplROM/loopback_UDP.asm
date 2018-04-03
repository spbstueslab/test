	include 	asms\wiz\exmplROM\head.asm

;���������������� ���������
SOCK_NUMBER: 	equ 0h
DATA_BUF_H:		equ E4h
DATA_BUF_L:		equ 00h
PORT_H:			equ 7DH
PORT_L:			equ 02H

;���������������� ����������
len_h: 			equ 	30h
len_l:			equ		31h

dest_ip_0: 		equ 	32h
dest_ip_1:		equ		33h
dest_ip_2: 		equ 	34h
dest_ip_3:		equ		35h

dest_port_h: 	equ 	36h
dest_port_l:	equ		37h
	
	org E300H

loopback_udp:
	;lcall hard_reset 
	
	lcall iinchip_init
	mov dptr, #init_data
	mov r3,#01h
	mov r2,dph
	mov r1,dpl
	lcall init_w5100
	

	;*******�������� ������ UDP********************
	mov dptr, #magik_buf		;
	mov a, #00			;�����
	movx @dptr, a		;
	mov r3, #PORT_L		;
	mov r2, #PORT_H		;����
	mov r5, #Sn_MR_UDP	;��� ������
	mov r7, #SOCK_NUMBER;����� (0-3)	
	lcall socket
;************************************************	

loopback_udp_cycle:
	
	mov r7, #SOCK_NUMBER
	lcall getSn_RX_RSR
	mov a, r6
	orl a, r7
	jz loopback_udp_cycle
	
	mov len_h, r6
	mov len_l, r7
	
	;******����� ������****************************
	
	mov r7, #SOCK_NUMBER;����� ������
	
	mov r3, #01h		;
	mov r2, #DATA_BUF_H	;��������� �� ����� ���������
	mov r1, #DATA_BUF_L	;
	
	mov dptr, #magik_buf	;
	mov a, len_h		;
	movx @dptr, a		;���������� ���� ��� ������
	inc dptr			;
	mov a, len_l		;
	movx @dptr, a		;
	
	inc dptr			;
	clr a				;
	movx @dptr, a		;
	inc dptr			;
	movx @dptr, a		;��������� �� ����� �����������
	inc dptr			;
	mov a, #dest_ip_0	;
	movx @dptr, a		;
	
	inc dptr			;
	clr a				;
	movx @dptr, a		;
	inc dptr			;
	movx @dptr, a		;��������� �� ���� �����������
	inc dptr			;
	mov a, #dest_port_h	;
	movx @dptr, a		;
	
	lcall recvfrom
	
	mov len_h, r6
	mov len_l, r7
	;******����� ������ �����****************************
	
	;******�������� ������ ������****************************
	mov r7, #SOCK_NUMBER;����� ������
		
	mov r3, #01h		;
	mov r2, #DATA_BUF_H	;��������� �� ����� ������
	mov r1, #DATA_BUF_L	;
	
	mov dptr, #magik_buf	;
	mov a, len_h		;
	movx @dptr, a		;���������� ���� ��� ��������
	inc dptr			;
	mov a, len_l		;
	movx @dptr, a		;
	
	inc dptr			;
	clr a				;
	movx @dptr, a		;
	inc dptr			;
	movx @dptr, a		;��������� �� ����� ����������
	inc dptr			;
	mov a, #dest_ip_0	;
	movx @dptr, a		;
	
	inc dptr			;
	mov a, dest_port_h	;	
	movx @dptr, a		;���� ����������
	inc dptr			;
	mov a, dest_port_l	;	
	movx @dptr, a		;
	
	lcall sendto
	;******�������� ������ �����****************************
	
	ljmp loopback_udp_cycle
	
	
init_data:

	db 02h, 11h, 22h, 33h, 44h, 55h 	;MAC	
	db 192, 168, 1, 105					;source ip addr		;4
	db 255, 255, 255, 0					;subnet mask register		;4
	db 192, 168, 1, 1	 				;gareway addr		;4
	
	
	
	include 	asms\wiz\exmplROM\head.asm

;адрес DNS сервера
dns_ip_0:	equ		10
dns_ip_1:	equ		0
dns_ip_2:	equ		0
dns_ip_3:	equ		10

URL_ip_0:	equ 	30h
URL_ip_1:	equ 	31h
URL_ip_2:	equ 	32h
URL_ip_3:	equ 	33h
	
	org E300H
dns_test:
	clr a
	mov URL_ip_0, a
	mov URL_ip_1, a
	mov URL_ip_2, a
	mov URL_ip_3, a
	
	;lcall hard_reset 
	
	lcall iinchip_init 
	mov dptr, #init_data
	mov r3,#01h
	mov r2,dph
	mov r1,dpl
	lcall init_w5100
	
	mov r7, #dns_ip_3
	mov r6, #dns_ip_2
	mov r5, #dns_ip_1
	mov r4, #dns_ip_0
	lcall setDNSIP
	
	mov dptr, #URL
	mov r3, #01h
	mov r2, dph
	mov r1, dpl
	lcall gethostbyname
	
	mov URL_ip_0, r4 
	mov URL_ip_1, r5
	mov URL_ip_2, r6
	mov URL_ip_3, r7
	
	ret
	
init_data:
	db 02h, 11h, 22h, 33h, 44h, 55h 	;MAC
	;db 00h,1Bh,11h,C3h,A2h,17h	
	db 10, 1, 210, 3					;source ip addr		;4
	db 255, 255, 255, 248					;subnet mask register		;4
	db 10, 1, 210, 1	 				;gareway addr		;4
	
URL:
	db 'www.chipdip.ru', 0
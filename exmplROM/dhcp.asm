	include 	asms\wiz\exmplROM\head.asm

;пользовательские константы
SOCK_NUMBER: 	equ 0h

;Ячейки памяти для хранения результатов DHCP
ip:	 			equ 30h		
maska:	 		equ 34h	
gw_ip:	 		equ 38h	
dns_1:	 		equ 3Ch	
dns_2:	 		equ 40h	
fin:			equ 44h

	
		
	org E300H
	
	mov r0, #21
	mov r1, #30h
	clr a
	
clr_cycle:
	mov @r1, a
	inc r1
	djnz r0, clr_cycle
	
	
dhcp_test:
	
	lcall hard_reset 
	lcall iinchip_init

	;запись MAC адреса
	mov dptr, #SRC_MAC_ADDR_0
	mov a, #00h
	movx @dptr, a
	
	inc dptr
	mov a, #08h
	movx @dptr, a
	
	inc dptr
	mov a, #DCh
	movx @dptr, a
	
	inc dptr
	mov a, #00h
	movx @dptr, a
	
	inc dptr
	mov a, #00h
	movx @dptr, a
	
	inc dptr
	mov a, #4Fh
	movx @dptr, a
	;запись MAC адреса конец
;инициализация DHCP сокета
	mov r7, #SOCK_NUMBER
	lcall init_dhcpc_ch
	
;обращение к DHCP серверу	
dhcp_test_m1:	
	lcall getIP_DHCPS
	mov a, r7
	orl a, r6
	jz	dhcp_test_m1
;проверка истечения времени аренды	
dhcp_test_cycle:	
	mov r7, #SOCK_NUMBER
	lcall check_DHCP_state
	lcall getNetConf
	sjmp dhcp_test_cycle
	
;получение сетевых настроек w5100	
getNetConf:
	mov r3, #00h
	mov r2, #00h
	mov	r1, #ip
	lcall getSIPR
	
	mov r3, #00h
	mov r2, #00h
	mov	r1, #maska
	lcall getSUBR
	
	mov r3, #00h
	mov r2, #00h
	mov	r1, #gw_ip
	lcall getGAR
	
	mov r3, #00h
	mov r2, #00h
	mov	r1, #dns_1
	lcall getDNSIP
	
	mov r3, #00h
	mov r2, #00h
	mov	r1, #dns_2
	lcall getDNSIP2
	

	ret
	
	org 800bh
	ljmp T0_int
	
	
	
	
	
	
	
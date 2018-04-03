#!/usr/bin/perl -w

use strict;
use IO::Socket;

# Создаем сокет
socket(SOCK, # Указатель сокета
PF_INET, # коммуникационный домен
SOCK_STREAM, # тип сокета
getprotobyname('tcp') # протокол
);


# Задаем адрес сервера
my $host = "127.0.0.1";
my $port = 80;
my $paddr = sockaddr_in($port,
inet_aton($host)
);

# Соединяемся с сервером
connect(SOCK, $paddr) or die ("Cannot connect to server\n");

# Отправляем запрос

#send(SOCK, "GET /\nHOST: ${host}", 0);
send(SOCK, "admin|dozor|0|1|activated\r\n", 0);

# Принимаем данные
my @data = <SOCK>;
print join(" ", @data);

# Закрываем сокет
close(SOCK);
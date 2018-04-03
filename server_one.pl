#!/usr/bin/perl -w

use strict;
use IO::Socket;
my $act = "admin|dozor|0|1|activated";
my $deact = "admin|dozor|0|1|deactivated";
my $get = "GET /page.html HTTP/1.1";
my @webpage;

sub fill_history {
	for (my $i=11; $i>2; $i--) {
		$webpage[$i] = $webpage[$i-1];
	}
	(my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday) = gmtime(time);
	my $mytime = scalar(gmtime);
	($webpage[2]) = "@_ $mytime<br>";
}


$webpage[0] = "<!DOCTYPE HTMLPUBLIC \"-//W3C//DTD HTML 4.01//EN\r\n\"http://www.w3.org/TR/html4/strict.dtd\">\r\n<html>\r\n<head>\r\n<title>Test site</title>\r\n<meta http-equiv=\"Refresh\" content=\"5\">\r\n</head>\r\n<body><a href=\"http://www.ho.ua\">ho - бесплатный хостинг!</a>\r\n<h1>";
$webpage[1] = "Test page</h1>\r\n";
$webpage[20] = "\r\n</h4>\r\n</body>\r\n</html>";

my $port = 80;
# Создаем сокет
socket(SOCK, PF_INET,SOCK_STREAM, getprotobyname('tcp')) or die ("Не могу создать сокет!");
setsockopt(SOCK, SOL_SOCKET, SO_REUSEADDR, 1);
# Связываем сокет с портом
my $paddr = sockaddr_in($port, INADDR_ANY);
bind(SOCK, $paddr) or die("Cannot bind socket!");

# Ждем подключений клиентов
print "Waiting for connections...\n";
listen(SOCK, SOMAXCONN);
my $client_addr = accept(CLIENT, SOCK);
	# Получаем адрес клиента
	my ($client_port, $client_ip) = sockaddr_in($client_addr);
	my $client_ipnum = inet_ntoa($client_ip);
	my $client_host = gethostbyaddr($client_ip, AF_INET);
	
	# Принимаем данные от клиента
	my $data;
	my $count = sysread(CLIENT, $data, 1024);
	print "Received ${count} bytes from ${client_host} [${client_ipnum}]\n";
	print $data;
	
	if ($data eq $act) {
			$webpage[1] = "Sensor activated</h1>\r\n<h4>";
			fill_history($act);
	}
	else
	{	
		if ($data eq $deact) {
			$webpage[1] = "Sensor deactivated</h1>\r\n<h4>";
			fill_history($deact);
		}
		else {	
			if (index($data, $get) == -1){
			# Отправляем данные клиенту
			print CLIENT "Hello, world\n";
			}
			else 
			{
				print CLIENT @webpage;
			}
		}
	}
	
	# Закрываем соединение
	close(CLIENT);
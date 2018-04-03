#!/usr/bin/perl

use strict;
use Socket;
use 5.010;

# имя сервера

use constant DEF_ADDR => 's2.daytime.net.ru';

my $packed_addr = gethostbyname(shift || DEF_ADDR) or
   die "Cannot find host =(";
my $protocol = getprotobyname('tcp');
my $port = getservbyname('daytime', 'tcp') or 
   die "Cannot find port =(";
my $socket_addr = sockaddr_in($port, $packed_addr);
socket(SOCK, AF_INET, SOCK_STREAM, $protocol) or 
   die "Cannot create socket =(";
connect(SOCK, $socket_addr) or 
   die "Cannot connect to socket =(";
my $date = <SOCK>;
close SOCK;
print "$date\n";
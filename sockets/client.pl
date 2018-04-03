#!/usr/bin/perl -w

use strict;
use IO::Socket;

# ������� �����
socket(SOCK, # ��������� ������
PF_INET, # ���������������� �����
SOCK_STREAM, # ��� ������
getprotobyname('tcp') # ��������
);


# ������ ����� �������
my $host = "127.0.0.1";
my $port = 80;
my $paddr = sockaddr_in($port,
inet_aton($host)
);

# ����������� � ��������
connect(SOCK, $paddr) or die ("Cannot connect to server\n");

# ���������� ������

#send(SOCK, "GET /\nHOST: ${host}", 0);
send(SOCK, "admin|dozor|0|1|activated\r\n", 0);

# ��������� ������
my @data = <SOCK>;
print join(" ", @data);

# ��������� �����
close(SOCK);
#!/usr/bin/perl -w

open ("OUT1", ">output.txt");
print OUT1 $ENV{'QUERY_STRING'};
close (OUT1);

print "Content-Type: text/html\n";

# �� ������ ����� � ������� HTML. ����� �����: text/plain -- ������� �����, �
# �������� ����������� ���������� ������, ������������ ����� ������
# <pre></pre>.  image/gif -- ��������, ������ gif video/mpeg --
# mpeg-����� � ����� ���� ������ ��������, ��.  ���� mime.types �� apache

print "\n"; 
# <-- ��� ���� ������ ������, ���������� ����� ������ ����� 
# ����������. �����!

# ������ �� ����� �������� ���� ����� �������
print "<html>";
print "<head>";
print "<title>��� ������ CGI ���������</title>";
print "</head>";
print "<body>";
print "<h1>��� ������ CGI ���������</h1>";
print "</body>";
print "</head>";
print "</html>";
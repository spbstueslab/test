#!/usr/bin/perl
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
print "</html>";
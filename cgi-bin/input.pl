#!/usr/bin/perl
use CGI qw(:standard); 

print "Content-Type: text/html\n\n";

$string = param("name");

#open ("OUT1", ">/home/m/mcs51.h16.ru/WWW/view_input_value.html"); 
#print  OUT1 "<html>
#<body>
#$string";
#print OUT1 "
#</body>
#</html>
#";
#close (OUT1);

open ("OUT1", ">/home/m/mcs51.h16.ru/WWW/input.html"); 

print OUT1 "<HTML>
<HEAD>";
print OUT1 "<title>MCS51</title>
</HEAD>
<BODY>
����� ���������� �� ���� <b>MCS51!</b><br>";
print OUT1 "���������� �������� ��������: <!-- OLD_VALUE -->$string<!-- END_VALUE --><br>";
print OUT1 "����������, ������� �������� �� 0 �� 15 � ���� \"��������\".
<form action=/cgi-bin/input.pl method=POST>
  ��������: <input type=text name=name><br>
  <input type=submit value=\"���������\">
</form>
��� ��������� ����������� ��������� <A HREF=\"/view_input_value.html\">�� ������</A> 
</BODY>
</HTML>";
close (OUT1);

print ("<HTML><HEAD>\n");
print ("<META HTTP-EQUIV=refresh CONTENT='0;url=/input.html'>\n");
print ("</HEAD></HTML>\n");
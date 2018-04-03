#!/usr/bin/perl
use CGI qw(:standard); 

print "Content-Type: text/html\n\n";

$string = param("name");

open ("OUT1", ">/home/m/mcs51.h16.ru/WWW/view_input_value.html"); 
print  OUT1 "<html>
<body>
$string";
print OUT1 "
</body>
</html>
";
close (OUT1);

print ("<HTML><HEAD>\n");
print ("<META HTTP-EQUIV=refresh CONTENT='0;url=/view_input_value.html'>\n");
print ("</HEAD></HTML>\n");
#!/usr/bin/perl

use strict;

print "Content-type: text/html; charset=windows-1251\n\n";
print "<form action='?text2=test' method=get>";
print "<input type=text1 name=var1>";
print "<input type=submit value=ok name=var2>";
print "</form>";
   
foreach (keys %ENV) {
  print '<b>',$_, '</b> - ',$ENV{$_}, '<BR>';
}
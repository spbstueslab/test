#!/usr/bin/perl -w

use strict;
use IO::Socket;
use CGI qw(param);
my @webpage;
my @arr;
for (my $counter=1; $counter<=16; $counter++) {
	if ($counter<10) {
		$arr[$counter-1] = "0".($counter);
	}
	else {
		$arr[$counter-1] = ($counter);
	}
}


$webpage[0] = "<!DOCTYPE HTMLPUBLIC \"-//W3C//DTD HTML 4.01//EN\r\n\"http://www.w3.org/TR/html4/strict.dtd\">\r\n<html>\r\n<head>\r\n<title>Test site</title>\r\n<meta http-equiv=\"Refresh\" content=\"5\">\r\n</head>\r\n<body><a href=\"http://www.ho.ua\">ho - бесплатный хостинг!</a>\r\n<h1>";
$webpage[1] = "NEW PAGE</h1>\r\n<h4>";
(my $sec, my $min, my $hour, my $mday, my $mon, my $year, my $wday, my $yday) = gmtime(time);
	my $mytime = scalar(gmtime);
($webpage[2]) = "@_ $mytime<br>";
for (my $count =0 ; $count < 16; $count++) {
	if ($count%4==3) {
 	($webpage[$count*2+4]) = ($count+1)."<br>";
	}
	else {
	($webpage[$count*2+4]) = ($count+1)."   ";
	}
}
$webpage[100] = "\r\n</h4>\r\n</body>\r\n</html>";


#Печатаем в файл для проверки работы
open ("OUT1", ">/home/m/mcs51.h16.ru/WWW/output.html"); 
my $favorite = "0";
$favorite = param("flavor");
#($webpage[99]) = $favorite;
for (my $count1=0; $count1<16; $count1++){ 
	if (defined($favorite)) {
	if ($favorite == $arr[$count1]) {
		$webpage[$count1*2+3] = "<i>";
		$webpage[$count1*2+5] = "</i>";
	}
	}
}

print OUT1 @webpage;
close (OUT1);

#***************************************************************************

#Проверяем, отработал ли до этого места сервера; для этого отдаём клиенту страницу в этом месте:

print "Content-Type: text/html\n";
# Мы выдаем текст в формате HTML. Также можно: text/plain -- простой текст, в
# браузере отобразится аналогично тексту, заключённому между тегами
# <pre></pre>.  image/gif -- Картинка, формат gif video/mpeg --
# mpeg-видео И целая куча других форматов, см.  файл mime.types из apache

print "\n"; 
# <-- еще одна пустая строка, обозначает конец вывода наших 
# заголовков. ВАЖНО!

# Теперь мы можем написать свой текст клиенту
print "<html>";
print "<head>";
print "<title>Моя первая CGI программа</title>";
print "</head>";
print "<body>";
print "<h1>Моя первая CGI программа</h1>";
print "</body>";
print "</head>";
print "</html>";

#***************************************************************************
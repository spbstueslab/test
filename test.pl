#!/usr/bin/perl -w

open ("OUT1", ">output.txt");
print OUT1 $ENV{'QUERY_STRING'};
close (OUT1);

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
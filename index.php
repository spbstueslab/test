<?
#VERSION 1.03
ob_start();
print "<HTML>
<body>
<form method=\"post\">
<div style=\"font-family: Georgia;\">
<div style=\"background: #cfcfcf; font-size: 14px; width: 800px;\" align=center><b>Навигатор</b></div>";
?>

<?
$dirs = array(); $files = array();
if($_GET{"chdir"}){
    $dir = $dir."".hex2string($_GET{"chdir"});
}else{
    $dir = "../";
}
$dir = preg_replace("/\.\.\/+/","../",$dir);

if($_GET{"rmdir"}){
    $rmd = hex2string($_GET{"rmdir"});
    if($rmd == "../uf/"){
	print "<span style=\"color:red; font-size: 10px;\">Не удаляйте эту папку, она используется графическим редактором</span>";
    }else{
	rmdir($rmd);
    }
    header("Location: /adm/?chdir=".string2hex(dir_from_path($rmd))."&rnd=".rand());
}
if($_GET{"rmfile"}){
    $rmf = hex2string($_GET{"rmfile"});
    if(($rmf == "../fckeditor.js")or($rmf == "../fckconfig.js")){
	print "<span style=\"color:red; font-size: 10px;\">Не удаляйте этот файл, он используется графическим редактором</span>";
    }else{
	unlink($rmf);
    }
    header("Location: /adm/?chdir=".string2hex(dir_from_path($rmf))."&rnd=".rand());
}
if($_POST{"newfile"}){
    $olddir = getcwd();
    chdir($dir);
    $newfile = $_POST{"newfile"};
    $newfile = preg_replace("/(\/|\.\.|\'|\"\|\>|\<|\;|\:|\,|\~|\@|\#|\$|\%|\^|\&|\*)+/","",$newfile);
    if(!file_exists($newfile)){
	$fp=fopen($newfile,"w");
	fclose($fp);
    }
    chdir($olddir);
}

if($_POST{"newdir"}){
    $olddir = getcwd();
    chdir($dir);
    $newdir = $_POST{"newdir"};
    $newdir = preg_replace("/(\/|\.\.|\'|\"\|\>|\<|\;|\:|\,|\~|\@|\#|\$|\%|\^|\&|\*)+/","",$newdir);
    mkdir($newdir);
    chdir($olddir);
}

if (is_dir($dir)) {
    if ($dh = opendir($dir)) {
	while (($file = readdir($dh)) !== false) {
	    if ($file == "."){continue;}
	    if ($file == ".."){
		$tmp = preg_replace("/\/.*$/","/",$dir);
		$dirs[$file] = $tmp;
	    }else{
		if(filetype($dir . $file) == "dir"){
		    $dirs[$file] = $dir.$file."/";
		}
		else{$files[] = $file;}
	    }

	}
        closedir($dh);
    }
    if(count($files)+(count($dirs)-5) >= 14){$tp = "overflow: scroll;";}
    else{$tp="";}
    print "<div style=\"border: dotted 1px black; width: 800px; height: 200px; $tp font-size: 10px; font-family: Georgia;\">";
    print "<table border=0 cellpadding=0 cellspacing=0 style=\"font-size: 10px;\">";
    foreach ($dirs as $k => $list){
	if (($k == "adm")or($k=="f")or($k=="cgi-bin")){continue;}
	$hex = string2hex($list);
	print "<tr><td><b><a href=?chdir=$hex>$k</a></b></td>";
	if($k != ".."){print "<td><a href=?rmdir=$hex style=\"color: red;padding-left: 10px; text-decoration: none;\">[X]</a></td></tr>\n";}
	else{print "\n";}

    }
    foreach ($files as $list){
	$hex = string2hex($list);
	if(is_edit($list)){print "<tr><td><a href=?editfile=$hex title=\"Редактировать\" atl=\"Редактировать\">$list</a></td><td><a href=?rmfile=".string2hex($dir.$list)." style=\"color: red;padding-left: 10px; text-decoration: none;\">[X]</a></td></tr>\n";}
	else{
	    $url = preg_replace("/^\.\.\//","/",$dir);
	    print "<tr><td><a href=$dir"."$list>$list</a></td><td><a href=?rmfile=".string2hex($dir.$list)." style=\"color: red;padding-left: 10px; text-decoration: none;\">[X]</a></td></tr>\n";
	}
    }
    print "</table>";

}
?>
</div>
<form method=post style="display:inline;">
<input type=text name=newfile>
<input type=submit value="Создать новый файл">
</form>&nbsp;&nbsp;&nbsp;&nbsp;
<form method=post style="display:inline;">
<input type=text name=newdir>
<input type=submit value="Создать папку">
</form>
<br><br>
<form method=post>
<?
    include("../f/fckeditor.php") ;
    $oFCKeditor = new FCKeditor('FCKeditor1') ;
    $oFCKeditor->BasePath = '/f/';
    $file = $_POST{"newfile"};
    if(!$file){$file = hex2string($_GET{"editfile"});}
    if(!$file){$file = hex2string($_POST{"editfile"});}
    if($_POST{"FCKeditor1"}){
	$fileh = fopen($dir . $file,"w");
	fputs($fileh,"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//RU\">
<HTML>
<HEAD>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=".$_POST["encoding"]."\">
<title>".$_POST["title"]."</title>
<meta name=\"keywords\" content=\"".$_POST["keywords"]."\">
<meta name=\"description\" content=\"".$_POST["description"]."\">");
	if($_POST["head"]){
	    if ( get_magic_quotes_gpc() ) $postedValue = htmlspecialchars( stripslashes( $_POST["head"] ) ) ;
	    else $postedValue = htmlspecialchars( $_POST["head"] ) ;
    	    fputs($fileh,"\n".$postedValue."\n");
        }
	fputs($fileh,"</HEAD>\n<BODY>\n");
	fputs($fileh,$_POST["FCKeditor1"]);
        fputs($fileh,"</BODY>\n</HTML>");
	fclose($fileh);
	header("Location: /adm/?chdir=".string2hex($dir)."&rnd=".rand()."&editfile=".$_GET["editfile"]);
    }
    $fileh = fopen($dir . $file,"r");
    $stop=0; $val; $sk=0; $head;
    while (!feof($fileh)) {
	$buffer = fgets($fileh, 4096);
	if(preg_match('/\<meta\ http\-equiv/',$buffer)){
	    $sk=1;
	}
	if(preg_match('/\<title\>(.+)\<\/title\>/',$buffer,$tt)){
	    $title=$tt[1];
	    $sk=1;
	}
	if(preg_match('/\<meta/i',$buffer)and(preg_match('/keywords/i',$buffer))){
	    preg_match('/content=\"(.+)\"/i',$buffer,$keywords);
	    $sk=1;
	}
	if(preg_match('/\<meta/i',$buffer)and(preg_match('/description/i',$buffer))){
	    preg_match('/content=\"(.+)\"/i',$buffer,$description);
	    $sk=1;
	}
	if((preg_match('/\<head\>/i',$buffer))or(preg_match('/\<\/head\>/i',$buffer))){
	    $sk=1;
	}
	if(preg_match('/\<html/i',$buffer)){$stop=1; $sk=1;}
	if(preg_match('/\<body/i',$buffer)){$stop=0; $sk=1;}
	else{
	    if(!$stop){
		$val = $val.$buffer;
	    }else{
		if(!$sk){$head=$head.$buffer;}
	    }
	}
	$sk=0;
    }
    fclose($fileh);
    $oFCKeditor->Value = $val;
    if(preg_match("/\.htm./i",$file)){
	print "
	<a href=\"javascript: void(0);\" onClick=\"document.getElementById('htmlhead').style.display=''; document.getElementById('htmlhead1').style.display='';\">Показать заголовки HTML</a>
	<div style=\"background: #cfcfcf; display: none\" id=\"htmlhead\">
        &lt;HTML&gt;<br>
	&lt;HEAD&gt;<br>
        &lt;meta http-equiv=\"Content-Type\" content=\"text/html; charset=<input type=text name=encoding id=encoding>\"><br>
	&lt;title&gt;<input type=text name=title value=\"".$title."\">&lt;/title&gt;<br>
        &lt;meta name=\"keywords\" content=\"<input type=text name=keywords value=\"".$keywords[1]."\">\"&gt;<br>
	&lt;meta name=\"description\" content=\"<input type=text name=description value=\"".$description[1]."\">\"&gt;<br>
	(прочие заголовки, подключения CSS и JavaScript'ов)<br>
	<textarea name=head cols=50>$head</textarea><br>
	&lt;/HEAD&gt;<br>
	&lt;BODY&gt;
        <script>
    	    var u=navigator.userAgent;
	    if (u.indexOf(\"Win\") != -1) document.getElementById('encoding').value=\"windows-1251\";
	    else document.getElementById('encoding').value=\"KOI8-R\";
        </script>
	</div>";
    }
    $oFCKeditor->Create();
    if(preg_match("/\.htm./i",$file)){
	print "
	<div style=\"background: #cfcfcf; display: none;\" id=\"htmlhead1\">
	&lt;/BODY&gt;<br>
	&lt;/HTML&gt;
	</div>
	";
    }
?>

<br>
<?
if(!$file){
    print "Сохранить: <input type=text name=newfile>";
}else{
    print "<input type=text name=newfile value=".$file.">";
}
?>
<input type="submit" value="Сохранить" name="submit"></form>
</body>
</HTML>

<?php
function string2hex($st)
{
    for($i=0; $i<strlen($st); $i++) $hex[] = sprintf ("%2X", ord($st[$i]));
    return join("",$hex);
}

function hex2string($hex)
{
    $string = NULL;
    for ($i=0; $i < strlen($hex); $i+=2)
    {
	$string.= chr(hexdec(substr($hex, $i, 2)));
    }
    return $string;
}

function is_edit($file){
    $types = array('txt','html','htm','xhtm','php','phtml');
    foreach ($types as $type){
	if(preg_match("/\.$type$/","$file")){
	    return 1;
	}
    }
    return 0;
}

function dir_from_path($path){
    $s = split("/",$path);
    $s[count($s)-1]="";
    $s = join("/",$s);
    return $s;
}
?>

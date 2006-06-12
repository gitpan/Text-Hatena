use strict;
use Test::More tests => 12;

BEGIN { use_ok('Text::Hatena::AutoLink::HTTP') };

my ($text, $html, $html2);
my $t = Text::Hatena::AutoLink::HTTP->new;
my $pat = $t->pattern;

$text = 'This is our site. http://www.hatena.ne.jp/';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = 'This is our site. <a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a>';
is ($html, $html2);

$t = Text::Hatena::AutoLink::HTTP->new(
    a_target => '_blank',
);

$text = 'This is our site. http://www.hatena.ne.jp/';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = 'This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a>';
is ($html, $html2);

$t = Text::Hatena::AutoLink::HTTP->new;
$text = '[http://www.hatena.ne.jp/images/top/h1.gif:image]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = '<a href="http://www.hatena.ne.jp/images/top/h1.gif"><img src="http://www.hatena.ne.jp/images/top/h1.gif" alt="http://www.hatena.ne.jp/images/top/h1.gif" class="hatena-http-image"></a>';
is ($html, $html2);

$t = Text::Hatena::AutoLink::HTTP->new(
    a_target => '_blank',
);
$text = '[http://www.hatena.ne.jp/images/top/h1.gif:image:w150]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = '<a href="http://www.hatena.ne.jp/images/top/h1.gif" target="_blank"><img src="http://www.hatena.ne.jp/images/top/h1.gif" alt="http://www.hatena.ne.jp/images/top/h1.gif" class="hatena-http-image" width="150"></a>';
is ($html, $html2);

$text = '[http://www.hatena.ne.jp/mobile/:barcode]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = '<a href="http://www.hatena.ne.jp/mobile/" target="_blank"><img src="http://d.hatena.ne.jp/barcode?str=http%3a%2f%2fwww%2ehatena%2ene%2ejp%2fmobile%2f" class="barcode" alt="http://www.hatena.ne.jp/mobile/"></a>';
is ($html, $html2);

$text = 'This is our secure site. https://www.hatena.ne.jp/';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = 'This is our secure site. <a href="https://www.hatena.ne.jp/" target="_blank">https://www.hatena.ne.jp/</a>';
is ($html, $html2);

$text = 'This is our site. [http://www.hatena.ne.jp/:title=Hatena]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = 'This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">Hatena</a>';
is ($html, $html2);

$text = 'This is our site. [http://www.hatena.ne.jp/:title]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = 'This is our site. <a href="http://www.hatena.ne.jp/" target="_blank">はてな</a>';
is ($html, $html2);

$text = 'This is our site. [http://www.hatena.ne.jp/:detail]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = 'This is our site. <div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a></p><p class="hatena-http-detail-title">はてな</p></div>';
is ($html, $html2);

$text = 'Our video is here. [https://hatena.g.hatena.ne.jp/files/hatena/b9f904875fcd5333.flv:movie]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 =<< 'END';
Our video is here. <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="320" height="205" id="flvplayer" align="middle">
<param name="allowScriptAccess" value="sameDomain" />
<param name="movie" value="http://g.hatena.ne.jp/tools/flvplayer.swf" />
<param name="quality" value="high" />
<param name="bgcolor" value="#ffffff" />
<param name="FlashVars" value="moviePath=https://hatena.g.hatena.ne.jp/files/hatena/b9f904875fcd5333.flv" />
<embed src="http://g.hatena.ne.jp/tools/flvplayer.swf" FlashVars="moviePath=https://hatena.g.hatena.ne.jp/files/hatena/b9f904875fcd5333.flv" quality="high" bgcolor="#ffffff" width="320" height="205" name="flvplayer" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
END
is ($html, $html2);

$text = 'This is our magazine. [http://hatena.g.hatena.ne.jp/files/hatena/3ab34c9ad414e964.mp3:sound]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 =<< 'END';
This is our magazine. <span style="vertical-align:middle;">
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="130" height="25" id="mp3_2" align="middle" style="vertical-align:bottom">
<param name="flashVars" value="mp3Url=http://hatena.g.hatena.ne.jp/files/hatena/3ab34c9ad414e964.mp3">
<param name="allowScriptAccess" value="sameDomain">
<param name="movie" value="http://g.hatena.ne.jp/tools/mp3_2.swf">
<param name="quality" value="high">
<param name="bgcolor" value="#ffffff">
<param name="wmode" value="transparent">
<embed src="http://g.hatena.ne.jp/tools/mp3_2.swf" flashvars="mp3Url=http://hatena.g.hatena.ne.jp/files/hatena/3ab34c9ad414e964.mp3" quality="high" wmode="transparent" bgcolor="#ffffff" width="130" height="25" name="mp3_2" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" style="vertical-align:bottom">
</object>
<a href="http://hatena.g.hatena.ne.jp/files/hatena/3ab34c9ad414e964.mp3"><img src="http://g.hatena.ne.jp/images/podcasting.gif" title="Download" alt="Download" border="0" style="border:0px;vertical-align:bottom;"></a>
</span>
END
is ($html, $html2);

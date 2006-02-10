use strict;
use Test::More tests => 10;

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

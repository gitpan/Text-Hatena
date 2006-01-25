use strict;
use Test::More tests => 7;

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaGroup') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaGroup->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'This is my archive. g:hatena:id:sample:archive';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'This is my archive. <a href="http://hatena.g.hatena.ne.jp/sample/archive">g:hatena:id:sample:archive</a>';
ok ($html eq $html2);

$text = 'This is my archive. g:hatena:id:sample:archive:200601';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'This is my archive. <a href="http://hatena.g.hatena.ne.jp/sample/archive/200601">g:hatena:id:sample:archive:200601</a>';
ok ($html eq $html2);

$text = 'This is my gdiary. g:hatena:id:sample';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'This is my gdiary. <a href="http://hatena.g.hatena.ne.jp/sample/">g:hatena:id:sample</a>';
ok ($html eq $html2);

$text = 'This is my article. g:hatena:id:sample:20060121:1137814960';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'This is my article. <a href="http://hatena.g.hatena.ne.jp/sample/20060121/1137814960">g:hatena:id:sample:20060121:1137814960</a>';
ok ($html eq $html2);

$text = 'see [g:hatena:keyword:はてな情報削除関連事例]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'see <a class="okeyword" href="http://hatena.g.hatena.ne.jp/keyword/%e3%81%af%e3%81%a6%e3%81%aa%e6%83%85%e5%a0%b1%e5%89%8a%e9%99%a4%e9%96%a2%e9%80%a3%e4%ba%8b%e4%be%8b">g:hatena:keyword:はてな情報削除関連事例</a>';
ok ($html eq $html2);

$text = 'g:texthatena:bbs:1:1';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = '<a href="http://texthatena.g.hatena.ne.jp/bbs/1/1">g:texthatena:bbs:1:1</a>';
ok ($html eq $html2);

use strict;
use Test::More tests => 6;

BEGIN { use_ok('Text::Hatena::AutoLink::ASIN') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::ASIN->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Here is my book. ISBN:4798110523';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">ISBN:4798110523</a>';
ok ($html eq $html2);

$text = 'Here is my book. ISBN:4798110523:image';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank"><img src="http://images-jp.amazon.com/images/P/4798110523.09.MZZZZZZZ.jpg" alt="「へんな会社」のつくり方" title="「へんな会社」のつくり方" class="asin"></a>';
ok ($html eq $html2);

$text = 'Here is my book. ISBN:4798110523:title';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">「へんな会社」のつくり方</a>';
ok ($html eq $html2);

$text = 'Here is my book. [ISBN:4798110523:title=How to make a strange company.]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">How to make a strange company.</a>';
ok ($html eq $html2);

$t = Text::Hatena::AutoLink::ASIN->new(
    amazon_affiliate_id => 'staffdiaryrei-22',
);

$text = 'Here is my book. ISBN:4798110523';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523/staffdiaryrei-22">ISBN:4798110523</a>';
ok ($html eq $html2);

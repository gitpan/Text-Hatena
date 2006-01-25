use strict;
use Test::More tests => 4;

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaFotolife') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaFotolife->new;
my $pat = $t->pattern;

$text = 'Here is my album. f:id:sample';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my album. <a href="http://f.hatena.ne.jp/sample/">f:id:sample</a>';
ok ($html eq $html2);

$t = Text::Hatena::AutoLink::HatenaFotolife->new(
    a_target => '_blank',
);
$text = 'Here is my favorite. f:id:sample:favorite';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my favorite. <a href="http://f.hatena.ne.jp/sample/favorite" target="_blank">f:id:sample:favorite</a>';
ok ($html eq $html2);

$text = 'Yukidaruma. f:id:jkondo:20060121153528j:image';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Yukidaruma. <a href="http://f.hatena.ne.jp/jkondo/20060121153528" target="_blank"><img src="http://f.hatena.ne.jp/images/fotolife/j/jkondo/20060121/20060121153528.jpg" alt="f:id:jkondo:20060121153528j:image" title="f:id:jkondo:20060121153528j:image"></a>';
ok ($html eq $html2);

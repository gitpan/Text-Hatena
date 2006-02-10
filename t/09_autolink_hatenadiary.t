use strict;
use Test::More tests => 8;
use FindBin;
use lib "$FindBin::Bin/../lib";

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaDiary') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaDiary->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'My Blog is d:id:jkondo.';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My Blog is <a href="http://d.hatena.ne.jp/jkondo/" target="_blank">d:id:jkondo</a>.';
is ($html, $html2);

$text = 'Today\'s entry. d:id:jkondo:20060124.';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Today\'s entry. <a href="http://d.hatena.ne.jp/jkondo/20060124" target="_blank">d:id:jkondo:20060124</a>.';
is ($html, $html2);

$text = 'Today\'s entry. d:id:jkondo:20060124:1138066304.';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Today\'s entry. <a href="http://d.hatena.ne.jp/jkondo/20060124/1138066304" target="_blank">d:id:jkondo:20060124:1138066304</a>.';
is ($html, $html2);

$text = 'My profile is here. d:id:jkondo:about';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My profile is here. <a href="http://d.hatena.ne.jp/jkondo/about" target="_blank">d:id:jkondo:about</a>';
is ($html, $html2);

$text = 'My archive is here. d:id:jkondo:archive';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My archive is here. <a href="d.hatena.ne.jp/jkondo/archive" target="_blank">d:id:jkondo:archive</a>';
is ($html, $html2);

$text = 'My archive is here. d:id:jkondo:archive:200601';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My archive is here. <a href="d.hatena.ne.jp/jkondo/archive/200601" target="_blank">d:id:jkondo:archive:200601</a>';
is ($html, $html2);

$text = 'see [d:keyword:はてな] for detailed info.';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'see <a href="http://d.hatena.ne.jp/keyword/%a4%cf%a4%c6%a4%ca" target="_blank">d:keyword:はてな</a> for detailed info.';
is ($html, $html2);

use strict;
use Test::More tests => 2;

use FindBin;
use lib "$FindBin::Bin/../lib";

use_ok('Text::Hatena::AutoLink::Amazon');

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::Amazon->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Hatena books. [amazon:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Hatena books. <a href="http://www.amazon.co.jp/exec/obidos/external-search?mode=blended&tag=hatena-22&encoding-string-jp=%e6%97%a5%e6%9c%ac%e8%aa%9e&keyword=%e3%81%af%e3%81%a6%e3%81%aa" target="_blank">amazon:はてな</a>';
is ($html, $html2);

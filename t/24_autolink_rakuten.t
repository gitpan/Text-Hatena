use strict;
use Test::More tests => 2;

use FindBin;
use lib "$FindBin::Bin/../lib";

use_ok('Text::Hatena::AutoLink::Rakuten');

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::Rakuten->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Hatena goods. [rakuten:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Hatena goods. <a href="http://pt.afl.rakuten.co.jp/c/002e8f0a.89099887/?sv=2&v=3&p=0&sitem=%a4%cf%a4%c6%a4%ca" target="_blank">rakuten:はてな</a>';
is ($html, $html2);

use strict;
use Test::More tests => 1;

use Text::Hatena::AutoLink;
my $t = Text::Hatena::AutoLink->new;

my ($text, $html);

$text = 'Hi, this is a simple text.';
$html = $t->parse($text);
is ($text, $html);

use strict;
use Test::More tests => 2;

BEGIN { use_ok('Text::Hatena::AutoLink::Unbracket') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::Unbracket->new;
my $pat = $t->pattern;

$text = 'I don\'t want to link []id:jkondo[].';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'I don\'t want to link id:jkondo.';
is ($html, $html2);

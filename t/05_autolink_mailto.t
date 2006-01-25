use strict;
use Test::More tests => 2;

BEGIN { use_ok('Text::Hatena::AutoLink::Mailto') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::Mailto->new;
my $pat = $t->pattern;

$text = 'send me a mail mailto:info@example.com';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'send me a mail <a href="mailto:info@example.com">mailto:info@example.com</a>';
ok ($html eq $html2);

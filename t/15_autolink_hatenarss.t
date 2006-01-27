use strict;
use Test::More tests => 2;

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaRSS') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaRSS->new;
my $pat = $t->pattern;

$text = 'Here is my reader. r:id:jkondo';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my reader. <a href="http://r.hatena.ne.jp/jkondo/">r:id:jkondo</a>';
ok ($html eq $html2);

use strict;
use Test::More tests => 2;

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaAntenna') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaAntenna->new;
my $pat = $t->pattern;

$text = 'Here is my antenna. a:id:jkondo';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my antenna. <a href="http://a.hatena.ne.jp/jkondo/">a:id:jkondo</a>';
ok ($html eq $html2);

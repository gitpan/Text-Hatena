use strict;
use Test::More tests => 2;

BEGIN { use_ok('Text::Hatena::AutoLink::Tex') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::Tex->new;
my $pat = $t->pattern;

$text = 'formula [tex:x^2+y^2=z^2]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'formula <img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?x^2+y^2=z^2" class="tex" alt="x^2+y^2=z^2">';
is ($html, $html2);

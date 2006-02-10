use strict;
use Test::More tests => 3;

BEGIN { use_ok('Text::Hatena::AutoLink::EAN') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::EAN->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Jagariko ean:4901330571870';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Jagariko <a href="http://d.hatena.ne.jp/ean/4901330571870" target="_blank">ean:4901330571870</a>';
is ($html, $html2);

$text = 'Jagariko [ean:4901330571870:title=jagariko]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Jagariko <a href="http://d.hatena.ne.jp/ean/4901330571870" target="_blank">jagariko</a>';
is ($html, $html2);

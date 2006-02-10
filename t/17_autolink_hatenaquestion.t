use strict;
use Test::More tests => 3;

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaQuestion') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaQuestion->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'My question history. q:id:jkondo';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My question history. <a href="http://q.hatena.ne.jp/jkondo/" target="_blank">q:id:jkondo</a>';
is ($html, $html2);

$text = 'The first question. question:995116699';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'The first question. <a href="http://q.hatena.ne.jp/995116699" target="_blank">question:995116699</a>';
is ($html, $html2);

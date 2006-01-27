use strict;
use Test::More tests => 4;

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaIdea') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaIdea->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'My Idea Stocks. i:id:jkondo';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My Idea Stocks. <a href="http://i.hatena.ne.jp/jkondo/" target="_blank">i:id:jkondo</a>';
ok ($html eq $html2);

$text = 'Ideas about podcast. [i:t:podcast]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Ideas about podcast. <a href="http://i.hatena.ne.jp/t/podcast" target="_blank">i:t:podcast</a>';
ok ($html eq $html2);

$text = 'idea:2669 can be made with Text::Hatena';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = '<a href="http://i.hatena.ne.jp/idea/2669" target="_blank">idea:2669</a> can be made with Text::Hatena';
ok ($html eq $html2);

use strict;
use Test::More tests => 5;

use FindBin;
use lib "$FindBin::Bin/../lib";

use_ok('Text::Hatena::AutoLink::HatenaGraph');

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaGraph->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Weight graphs [graph:t:Kg]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Weight graphs <a href="http://graph.hatena.ne.jp/t/Kg" target="_blank">graph:t:Kg</a>';
is ($html, $html2);

$text = 'My weight. [graph:id:jkondo:体重:image]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My weight. <a href="http://graph.hatena.ne.jp/jkondo/%e4%bd%93%e9%87%8d/" target="_blank"><img src="http://graph.hatena.ne.jp/jkondo/graph?graphname=%e4%bd%93%e9%87%8d" class="hatena-graph-image" alt="体重" title="体重"></a>';
is ($html, $html2);

$text = 'My weight. [graph:id:jkondo:体重]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My weight. <a href="http://graph.hatena.ne.jp/jkondo/%e4%bd%93%e9%87%8d/" target="_blank">graph:id:jkondo:体重</a>';
is ($html, $html2);

$text = 'My graphs graph:id:jkondo';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My graphs <a href="http://graph.hatena.ne.jp/jkondo/" target="_blank">graph:id:jkondo</a>';
is ($html, $html2);

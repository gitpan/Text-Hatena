use strict;
use Test::More tests => 4;

use FindBin;
use lib "$FindBin::Bin/../lib";

use_ok('Text::Hatena::AutoLink::HatenaMap');

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaMap->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Many cafes [map:t:cafe]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Many cafes <a href="http://map.hatena.ne.jp/t/cafe" target="_blank">map:t:cafe</a>';
is ($html, $html2);

$text = 'Here is our office. map:x139.6981y35.6515';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is our office. <a href="http://map.hatena.ne.jp/?x=139.6981&y=35.6515&z=4" target="_blank">map:x139.6981y35.6515</a>';
is ($html, $html2);

$text = 'Shibuya sta. [map:渋谷駅]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Shibuya sta. <a href="http://map.hatena.ne.jp/?word=%e6%b8%8b%e8%b0%b7%e9%a7%85" target="_blank">map:渋谷駅</a>';
is ($html, $html2);

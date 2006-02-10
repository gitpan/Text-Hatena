use strict;
use Test::More tests => 6;

use FindBin;
use lib "$FindBin::Bin/../lib";

use_ok('Text::Hatena::AutoLink::HatenaSearch');

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaSearch->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = '[search:question:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = '<a href="http://search.hatena.ne.jp/questsearch?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:question:はてな</a>';
is ($html, $html2);

$text = '[search:asin:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = '<a href="http://search.hatena.ne.jp/asinsearch?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:asin:はてな</a>';
is ($html, $html2);

$text = '[search:web:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = '<a href="http://search.hatena.ne.jp/websearch?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:web:はてな</a>';
is ($html, $html2);

$text = '[search:keyword:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = '<a href="http://search.hatena.ne.jp/keyword?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:keyword:はてな</a>';
is ($html, $html2);

$text = '[search:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = '<a href="http://search.hatena.ne.jp/keyword?word=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf8" target="_blank">search:はてな</a>';
is ($html, $html2);

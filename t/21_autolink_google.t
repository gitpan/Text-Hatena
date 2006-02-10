use strict;
use Test::More tests => 4;

use FindBin;
use lib "$FindBin::Bin/../lib";

use_ok('Text::Hatena::AutoLink::Google');

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::Google->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Hatena news. [google:news:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Hatena news. <a href="http://news.google.com/news?q=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf-8&oe=utf-8" target="_blank">google:news:はてな</a>';
is ($html, $html2);

$text = 'Hatena images. [google:images:はてな]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Hatena images. <a href="http://images.google.com/images?q=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf-8&oe=utf-8" target="_blank">google:images:はてな</a>';
is ($html, $html2);

$text = 'Google search results. [google:Text::Hatena]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Google search results. <a href="http://www.google.com/search?q=Text%3a%3aHatena&ie=utf-8&oe=utf-8" target="_blank">google:Text::Hatena</a>';
is ($html, $html2);

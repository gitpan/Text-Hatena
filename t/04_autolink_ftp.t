use strict;
use Test::More tests => 2;

BEGIN { use_ok('Text::Hatena::AutoLink::FTP') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::FTP->new;
my $pat = $t->pattern;

$text = 'This is our files. ftp://www.hatena.ne.jp/';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;

$html2 = 'This is our files. <a href="ftp://www.hatena.ne.jp/">ftp://www.hatena.ne.jp/</a>';
is ($html, $html2);

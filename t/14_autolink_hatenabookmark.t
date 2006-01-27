use strict;
use Test::More tests => 7;

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaBookmark') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaBookmark->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Entries about Perl. [b:keyword:Perl]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Entries about Perl. <a href="http://b.hatena.ne.jp/keyword/Perl" target="_blank">b:keyword:Perl</a>';
ok ($html eq $html2);

$text = 'Entries about Perl. [b:t:Perl]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Entries about Perl. <a href="http://b.hatena.ne.jp/t/Perl" target="_blank">b:t:Perl</a>';
ok ($html eq $html2);

$text = 'Here is my bookmark. b:id:jkondo';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my bookmark. <a href="http://b.hatena.ne.jp/jkondo/" target="_blank">b:id:jkondo</a>';
ok ($html eq $html2);

$text = 'Here is my favorite. b:id:jkondo:favorite';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my favorite. <a href="http://b.hatena.ne.jp/jkondo/favorite" target="_blank">b:id:jkondo:favorite</a>';
ok ($html eq $html2);

$text = 'Here is my favorite books. b:id:jkondo:asin';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my favorite books. <a href="http://b.hatena.ne.jp/jkondo/asin" target="_blank">b:id:jkondo:asin</a>';
ok ($html eq $html2);

$text = 'Here is my perl bookmarks. [b:id:jkondo:t:perl]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my perl bookmarks. <a href="http://b.hatena.ne.jp/jkondo/perl/" target="_blank">b:id:jkondo:t:perl</a>';
ok ($html eq $html2);

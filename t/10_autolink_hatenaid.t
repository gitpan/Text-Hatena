use strict;
use Test::More tests => 4;

BEGIN { use_ok('Text::Hatena::AutoLink::HatenaID') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::HatenaID->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Hello id:jkondo!';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Hello <a href="/jkondo/" target="_blank">id:jkondo</a>!';
ok ($html eq $html2);

$text = 'with icon id:jkondo:detail';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'with icon <a href="/jkondo/" target="_blank"><img src="http://www.hatena.ne.jp/users/jkondo/jk/profile_s.gif" width="16" height="16" alt="id:jkondo" class="hatena-id-icon">id:jkondo</a>';
ok ($html eq $html2);

$text = 'My foto. id:jkondo:image';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'My foto. <a href="/jkondo/" target="_blank"><img src="http://www.hatena.ne.jp/users/jkondo/jk/profile.gif" width="60" height="60" alt="id:jkondo" class="hatena-id-image"></a>';
ok ($html eq $html2);

package Text::Hatena::AutoLink::Unbracket;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[\](.+?)\[\]/i;

__PACKAGE__->patterns([$pattern]);

sub parse {
    my $self = shift;
    my $text = shift;
    $text =~ /$pattern/ or return;
    return $1;
}

1;

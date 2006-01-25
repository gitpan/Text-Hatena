package Text::Hatena::AutoLink::Mailto;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[?mailto:([a-zA-Z0-9_][a-zA-Z0-9_\.\-]+\@[a-zA-Z0-9_]+[a-zA-Z0-9_\.\-]*[a-zA-Z0-9_])\]?/i;

__PACKAGE__->patterns([$pattern]);

sub parse {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern/ or return;
    my $addr = $1;
    return sprintf('<a href="mailto:%s">mailto:%s</a>',
                       $addr,
                       $addr,
                   );
}

1;

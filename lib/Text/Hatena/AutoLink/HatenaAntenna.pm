package Text::Hatena::AutoLink::HatenaAntenna;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[?(a:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))\]?/i;

__PACKAGE__->patterns([$pattern]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'a.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern/ or return;
    return sprintf('<a href="http://%s/%s/"%s>%s</a>',
                   $self->{domain}, $2, $self->{a_target_string}, $1);
}

1;

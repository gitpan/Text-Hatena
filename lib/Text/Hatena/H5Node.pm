package Text::Hatena::H5Node;
use strict;
use base qw(Text::Hatena::Node);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^\*\*\*((?:[^\*]).*)$/;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $l = $c->shiftline or return;
    $l =~ /$self->{pattern}/ or return;
    my $t = "\t" x $self->{ilevel};
    $c->htmllines(qq|$t<h5>$1</h5>|);
}

1;

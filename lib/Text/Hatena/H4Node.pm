package Text::Hatena::H4Node;
use strict;
use base qw(Text::Hatena::Node);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^\*\*((?:[^\*]).*)$/;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $l = $c->shiftline or return;
    $l =~ /$self->{pattern}/ or return;
    my $t = "\t" x $self->{ilevel};
    $c->htmllines(qq|$t<h4>$1</h4>|);
}

1;

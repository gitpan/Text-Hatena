package Text::Hatena::TaglineNode;
use strict;
use base qw(Text::Hatena::Node);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^>(<.*>)<$/;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $t = "\t" x $self->{ilevel};
    $c->nextline =~ /$self->{pattern}/ or return;
    $c->shiftline;
    $c->htmllines($t.$1);
}

1;

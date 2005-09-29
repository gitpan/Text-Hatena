package Text::Hatena::SuperpreNode;
use strict;
use base qw(Text::Hatena::PreNode);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^>\|\|$/;
    $self->{endpattern} = qr/^\|\|<$/;
    $self->{startstring} = qq|<pre>|;
    $self->{endstring} = qq|</pre>|;
}

1;

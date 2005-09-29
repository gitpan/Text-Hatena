package Text::Hatena::PreNode;
use strict;
use base qw(Text::Hatena::Node);


sub init {
    my $self = shift;
    $self->{pattern} = qr/^>\|$/;
    $self->{endpattern} = qr/^\|<$/;
    $self->{startstring} = qq|<pre>|;
    $self->{endstring} = qq|</pre>|;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    $c->nextline =~ /$self->{pattern}/ or return;
    $c->shiftline;
    my $t = "\t" x $self->{ilevel};
    $c->htmllines($t.$self->{startstring});
    while ($c->hasnext) {
        my $l = $c->nextline;
        if ($l =~ /$self->{endpattern}/) {
            $c->shiftline;
            last;
        }
        $c->htmllines($c->shiftline);
    }
    $c->htmllines($self->{endstring});
}

1;

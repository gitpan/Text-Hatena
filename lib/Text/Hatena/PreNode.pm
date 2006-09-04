package Text::Hatena::PreNode;
use strict;
use base qw(Text::Hatena::Node);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^>\|$/;
    $self->{endpattern} = qr/\|<$/;
    $self->{startstring} = qq|<pre>|;
    $self->{endstring} = qq|</pre>|;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    $self->check_syntax($c->nextline) or return;
    $c->shiftline;
    my $t = "\t" x $self->{ilevel};
    $c->htmllines($t.$self->{startstring});
    my @r;
    while ($c->hasnext) {
        my $l = $c->nextline;
        if ($l =~ /$self->{endpattern}/) {
            push @r, $` || '';
            $c->shiftline;
            last;
        }
        push @r, $c->shiftline || '';
    }
    my $r = $self->format(join"\n", @r);
    chomp $r;
    $c->htmllines($r);
    $c->htmllines($self->{endstring});
}

sub check_syntax {
    my $self = shift;
    my $line = shift or return;
    return $line =~ /$self->{pattern}/;
}

sub format { $_[1] }

1;

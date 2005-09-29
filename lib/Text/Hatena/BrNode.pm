package Text::Hatena::BrNode;
use strict;
use base qw(Text::Hatena::Node);

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $l = $c->shiftline;
    length($l) and return;
    my $t = "\t" x $self->{ilevel};
    if ($c->lasthtmlline eq "$t<br>" || $c->lasthtmlline eq "$t") {
        $c->htmllines("$t<br>");
    } else {
        $c->htmllines($t);
    }
}

1;

package Text::Hatena::TableNode;
use strict;
use base qw(Text::Hatena::Node);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^\|([^\|]*\|(?:[^\|]*\|)+)$/;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $l = $c->nextline;
    $l =~ /$self->{pattern}/ or return;
    my $t = "\t" x $self->{ilevel};

    $c->htmllines("$t<table>");
    while (my $l = $c->nextline) {
        $l =~ /$self->{pattern}/ or last;
        $l = $c->shiftline;
        $c->htmllines("$t\t<tr>");
        for ($l =~ /([^\|]+)\|/g) {
            if (s/^\*//) {
                $c->htmllines("$t\t\t<th>$_</th>");
            } else {
                $c->htmllines("$t\t\t<td>$_</td>");
            }
        }
        $c->htmllines("$t\t</tr>");
    }
    $c->htmllines("$t</table>");
}

1;

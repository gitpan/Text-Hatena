package Text::Hatena::DlNode;
use strict;
use base qw(Text::Hatena::Node);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^\:((?:<[^>]+>|\[\].+?\[\]|\[[^\]]+\]|\[\]|[^\:<\[]+)+)\:(.+)$/;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $l = $c->nextline;
    $l =~ /$self->{pattern}/ or return;
    $self->{llevel} = length($1);
    my $t = "\t" x $self->{ilevel};

    $c->htmllines("$t<dl>");
    while (my $l = $c->nextline) {
        $l =~ /$self->{pattern}/ or last;
        $c->shiftline;
        $c->htmllines(qq|$t\t<dt>$1</dt>|);
        $c->htmllines(qq|$t\t<dd>$2</dd>|);
    }
    $c->htmllines("$t</dl>");
}

1;

package Text::Hatena::BlockquoteNode;
use strict;
use base qw(Text::Hatena::SectionNode);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^>>$/;
    $self->{endpattern} = qr/^<<$/;
    $self->{childnode} = [qw(h4 h5 blockquote dl list pre superpre table)];
    $self->{startstring} = qq|<blockquote>|;
    $self->{endstring} = qq|</blockquote>|;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    $c->nextline =~ /$self->{pattern}/ or return;
    $c->shiftline;
    my $t = "\t" x $self->{ilevel};
    $self->_set_child_node_refs;
    $c->htmllines($t.$self->{startstring});
    while ($c->hasnext) {
        my $l = $c->nextline;
        if ($l =~ /$self->{endpattern}/) {
            $c->shiftline;
            last;
        }
        my $node = $self->_findnode($l) or last;
        $node->parse;
    }
    $c->htmllines($t.$self->{endstring});
}

1;

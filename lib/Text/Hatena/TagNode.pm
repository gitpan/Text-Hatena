package Text::Hatena::TagNode;
use strict;
use base qw(Text::Hatena::SectionNode);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^>(<.*)$/;
    $self->{endpattern} = qr/^(.*>)<$/;
    $self->{childnode} = [qw(h4 h5 blockquote dl list pre superpre table)];
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $t = "\t" x $self->{ilevel};
    $c->nextline =~ /$self->{pattern}/ or return;
    $c->shiftline;
    $c->noparagraph(1);
    $self->_set_child_node_refs;
    my $x = $self->_parse_text($1);
    $c->htmllines($t.$x);
    while ($c->hasnext) {
        my $l = $c->nextline;
        if ($l =~ /$self->{endpattern}/) {
            $c->shiftline;
            $x = $self->_parse_text($1);
	    $c->htmllines($t.$x);
            last;
        }
        my $node = $self->_findnode($l) or last;
        $node->parse;
    }
    $c->noparagraph(0);
}

sub _parse_text {
    my $self = shift;
    my $l = shift;
    my $text = Text::Hatena::Text->new(context => $self->{context});
    $text->parse($l);
    return $text->html;
}

1;

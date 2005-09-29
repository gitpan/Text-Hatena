package Text::Hatena::PNode;
use strict;
use base qw(Text::Hatena::Node);
use Text::Hatena::Text;

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $t = "\t" x $self->{ilevel};
    my $l = $c->shiftline;
    my $text = Text::Hatena::Text->new(context => $c);
    $text->parse($l);
    $l = $text->html;
    $c->htmllines("$t<p>$l</p>");
}

1;

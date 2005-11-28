package Text::Hatena::BodyNode;
use strict;
use base qw(Text::Hatena::Node);
use Text::Hatena::SectionNode;
use Text::Hatena::FootnoteNode;

sub parse {
    my $self = shift;
    my $c = $self->{context};
    while ($c->hasnext) {
        my $node = Text::Hatena::SectionNode->new(
            context => $c,
            ilevel => $self->{ilevel},
        );
        $node->parse;
    }
}

1;

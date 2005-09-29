package Text::Hatena::BodyNode;
use strict;
use base qw(Text::Hatena::Node);
use Text::Hatena::SectionNode;
use Text::Hatena::FootnoteNode;

sub parse {
    my $self = shift;
    while ($self->{context}->hasnext) {
        my $node = Text::Hatena::SectionNode->new(
            context => $self->{context},
            ilevel => $self->{ilevel},
        );
        $node->parse;
    }
    if (@{$self->{context}->footnotes}) {
        my $node = Text::Hatena::FootnoteNode->new(
            context => $self->{context},
            ilevel => $self->{ilevel},
        );
        $node->parse;
    }
}

1;

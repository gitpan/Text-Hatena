package Text::Hatena::SectionNode;
use strict;
use base qw(Text::Hatena::Node);
use Text::Hatena::H3Node;
use Text::Hatena::H4Node;
use Text::Hatena::H5Node;
use Text::Hatena::BlockquoteNode;
use Text::Hatena::DlNode;
use Text::Hatena::ListNode;
use Text::Hatena::PreNode;
use Text::Hatena::SuperpreNode;
use Text::Hatena::TableNode;
use Text::Hatena::PNode;
use Text::Hatena::BrNode;

sub init {
    my $self = shift;
    $self->{childnode} = [qw(h5 h4 h3 blockquote dl list pre superpre table)];
    $self->{startstring} = qq|<div class="section">|;
    $self->{endstring} = qq|</div>|;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $t = "\t" x $self->{ilevel};
    $self->_set_child_node_refs;
    $c->htmllines($t.$self->{startstring});
    while ($c->hasnext) {
        my $l = $c->nextline;
        my $node = $self->_findnode($l) or last;
        if (ref($node) eq 'Text::Hatena::H3Node') {
            last if $self->{started}++;
        }
        $node->parse;
    }
    $c->htmllines($t.$self->{endstring});
}

sub _set_child_node_refs {
    my $self = shift;
    my $c = $self->{context};
    my %nodeoption = (
        context => $c,
        ilevel => $self->{ilevel} + 1,
    );
    my %invalid;
    @invalid{@{$c->invalidnode}} = () if @{$c->invalidnode};
    for my $node (@{$self->{childnode}}) {
        next if exists $invalid{$node};
        my $mod = 'Text::Hatena::' . ucfirst($node) . 'Node';
        push @{$self->{child_node_refs}}, $mod->new(%nodeoption);
    }
}

sub _findnode {
    my $self = shift;
    my $l = shift;
    for my $node (@{$self->{child_node_refs}}) {
        my $pat = $node->pattern or next;
        if ($l =~ /$pat/) {
            return $node;
        }
    }
    my %nodeoption = (
        context => $self->{context},
        ilevel => $self->{ilevel} + 1,
    );
    if (!length($l)) {
        return Text::Hatena::BrNode->new(%nodeoption);
    } else {
        return Text::Hatena::PNode->new(%nodeoption);
    }
}

1;

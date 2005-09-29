package Text::Hatena::ListNode;
use strict;
use base qw(Text::Hatena::Node);
use Text::Hatena::ListNode;

sub init {
    my $self = shift;
    $self->{pattern} = qr/^([\-\+]+)([^>\-\+].*)$/;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $l = $c->nextline;
    $l =~ /$self->{pattern}/ or return;
    $self->{llevel} = length($1);
    my $t = "\t" x ($self->{ilevel} + $self->{llevel} - 1);
    $self->{type} = substr($1, -1, 1) eq '-' ? 'ul' : 'ol';

    $c->htmllines("$t<$self->{type}>");
    while (my $l = $c->nextline) {
        $l =~ /$self->{pattern}/ or last;
        if (length($1) > $self->{llevel}) {
            $c->htmllines("$t\t<li>");
            my $node = Text::Hatena::ListNode->new(
                context => $self->{context},
                ilevel => $self->{ilevel},
            );
            $node->parse;
            $c->htmllines("$t\t</li>");
        } elsif(length($1) < $self->{llevel}) {
            last;
        } else {
            my $l = $c->shiftline;
            $c->htmllines("$t\t<li>$2</li>");
        }
    }
    $c->htmllines("$t</$self->{type}>");
}

1;

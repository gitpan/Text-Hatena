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
    $self->{open} = 0;
    while (my $l = $c->nextline) {
        $l =~ /$self->{pattern}/ or last;
        if (length($1) > $self->{llevel}) {
            my $node = Text::Hatena::ListNode->new(
                context => $self->{context},
                ilevel => $self->{ilevel},
            );
            $node->parse;
        } elsif(length($1) < $self->{llevel}) {
            last;
        } else {
	    $self->_closeitem if $self->{open};
            $c->shiftline;
	    my $nl = $c->nextline || '';
	    my $content = $2;
	    if ($nl =~ /$self->{pattern}/ && length($1) > $self->{llevel}) {
		$c->htmllines("$t\t<li>$content");
		$self->{open}++;
	    } else {
		$c->htmllines("$t\t<li>$content</li>");
	    }
        }
    }
    $self->_closeitem if $self->{open};
    $c->htmllines("$t</$self->{type}>");
}

sub _closeitem {
    my $self = shift;
    my $t = "\t" x ($self->{ilevel} + $self->{llevel} - 1);
    $self->{context}->htmllines("$t\t</li>");
    $self->{open} = 0;
}

1;

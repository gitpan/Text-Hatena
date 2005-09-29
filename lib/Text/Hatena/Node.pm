package Text::Hatena::Node;
use strict;

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        context => $args{context},
        ilevel => $args{ilevel},
        html => '',
    };
    bless $self,$class;
    $self->init;
    return $self;
}

sub init {
    my $self = shift;
    $self->{pattern} = '';
}

sub parse { die; }

sub html { $_[0]->{html}; }
sub pattern { $_[0]->{pattern}; }

sub context {
    my $self = shift;
    $self->{context} = $_[0] if $_[0];
    $self->{context};
}

1;

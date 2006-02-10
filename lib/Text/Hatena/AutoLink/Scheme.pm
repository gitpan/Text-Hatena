package Text::Hatena::AutoLink::Scheme;
use strict;
use base qw(Class::Data::Inheritable);

__PACKAGE__->mk_classdata('patterns');

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        option => \%args,
    };
    bless $self, $class;
    $self->init;
    return $self;
}

sub init {
    my $self = shift;
    $self->{a_target} = $self->{option}->{a_target};
    $self->{a_target_string} = $self->{a_target} ?
        sprintf(' target="%s"', $self->escape_attr($self->{a_target})) :
        '';
}

sub parse { $_[1]; }

sub pattern {
    my $self = shift;
    my $pat = join('|', @{$self->patterns});
    return qr/$pat/;
}

sub escape_attr {
    my $self = shift;
    my $str = shift;
    $str =~ s/"/&quote;/g;
    return $str;
}

sub html_encode {
    my $self = shift;
    my $text = shift or return;
    use bytes;
    $text =~ s/(\W)/sprintf("%%%02x",ord($1))/eg;
    return $text;
}

1;

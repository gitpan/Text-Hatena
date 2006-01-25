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
        sprintf(' target="%s"', $self->sanitize($self->{a_target})) :
        '';
}

sub parse { $_[1]; }

sub pattern {
    my $self = shift;
    my $pat = join('|', @{$self->patterns});
    return qr/$pat/;
}

sub sanitize {
    my $self = shift;
    my $str = shift;
    length $str or return;
    $str =~ s/&(?![\#a-zA-Z0-9_]{2,6};)/&amp;/g;
    $str =~ s/\</\&lt\;/g;
    $str =~ s/\>/\&gt\;/g;
    $str =~ s/\"/&quot;/g;
    $str =~ s/\'/&#39;/g;
    $str =~ s/\\/\&#92\;/g;
    return $str;
}

sub sanitize_url {
    my $self = shift;
    my $url = shift or return;
    $url =~ s/^\s+//;
    $url =~ /^(\&|about|\:)/ and return '';
    if ($url =~ /^([A-Za-z]+:)/) {
	my $scheme = $1;
	$scheme =~ /^(http|ftp|https|mailto|rtsp|mms):/i or return '';
    } elsif ($url =~ /^(\.|\/|#)/) {
    } else {
	$url = "./$url";
    }
    $url =~ s/["'\(\)<>]//g;
    return $url;
}

sub html_encode {
    my $self = shift;
    my $text = shift or return;
    use bytes;
    $text =~ s/(\W)/sprintf("%%%02x",ord($1))/eg;
    return $text;
}

1;

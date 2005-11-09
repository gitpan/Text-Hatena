package Text::Hatena::SuperpreNode;
use strict;
use base qw(Text::Hatena::PreNode);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^>\|\|$/;
    $self->{endpattern} = qr/^\|\|<$/;
    $self->{startstring} = qq|<pre>|;
    $self->{endstring} = qq|</pre>|;
}

sub escape_pre {
    my $self = shift;
    my $s = shift;
    $s =~ s/\&/\&amp;/g;
    $s =~ s/</\&lt;/g;
    $s =~ s/>/\&gt;/g;
    $s =~ s/"/\&quot;/g;
    $s =~ s/\'/\&#39;/g;
    $s =~ s/\\/\&#92;/g;
    return $s;
}

1;

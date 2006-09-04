package Text::Hatena::SuperpreNode;
use strict;
use base qw(Text::Hatena::PreNode);
use Text::VimColor;

sub init {
    my $self = shift;
    $self->{pattern} = qr/^>\|(\w+|\?)?\|$/;
    $self->{endpattern} = qr/^\|\|<$/;
    $self->{startstring} = qq|<pre class="hatena-super-pre">|;
    $self->{endstring} = qq|</pre>|;
}

sub check_syntax {
    my $self = shift;
    my $line = shift or return;
    $line =~ /$self->{pattern}/ or return;
    $self->{syntax_type} = $1 || '';
    return 1;
}

sub format {
    my $self = shift;
    my $s = shift;
    if ($self->{syntax_type}) {
        return $self->format_vimcolor($s);
    } else {
        return $self->format_plain($s);
    }
}

sub format_plain {
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

sub format_vimcolor {
    my $self = shift;
    my $s = shift;
    $self->{syntax_type} = $self->{syntax_type} eq '?' ?
        '' : $self->{syntax_type};
    return Text::VimColor->new(
        string => $s,
        filetype => $self->{syntax_type},
    )->html;
}

1;

package Text::Hatena::AutoLink::Tex;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[tex:(.*?[^\\\\])\]/i;

__PACKAGE__->patterns([$pattern]);

sub parse {
    my $self = shift;
    my $text = shift;
    $text =~ /$pattern/ or return;
    my $alt = $self->escape_attr($1);
    my $tex = $1;
    $tex =~ s/\\([\[\]])/$1/g;
    $tex =~ s/\s/~/g;
    $tex =~ s/"/\&quot;/g;
    return sprintf('<img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?%s" class="tex" alt="%s">',
                   $tex, $alt);
}

1;

package Text::Hatena::AutoLink::FTP;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[?(ftp:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+)\]?/i;

__PACKAGE__->patterns([$pattern]);

sub parse {
    my $self = shift;
    my $url = shift or return;
    return sprintf('<a href="%s"%s>%s</a>',
                       $url,
                       $self->{a_target_string},
                       $url,
                   );
}

1;

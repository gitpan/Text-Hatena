package Text::Hatena::AutoLink::Google;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[google:(?:(news|images?):)?([^\]]+?)\]/i;

__PACKAGE__->patterns([$pattern]);

sub parse {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern/ or return;
    my ($type,$word) = ($1 || '', $2);
    if (lc $type eq 'news') {
        return sprintf('<a href="http://news.google.com/news?q=%s&ie=utf-8&oe=utf-8"%s>google:%s:%s</a>',
                       $self->html_encode($word), $self->{a_target_string},
                       $type, $word);
    } elsif ($type =~ /^images?$/i) {
        return sprintf('<a href="http://images.google.com/images?q=%s&ie=utf-8&oe=utf-8"%s>google:%s:%s</a>',
                       $self->html_encode($word), $self->{a_target_string},
                       $type, $word);
    } else {
        return sprintf('<a href="http://www.google.com/search?q=%s&ie=utf-8&oe=utf-8"%s>google:%s</a>',
                       $self->html_encode($word), $self->{a_target_string}, $word);
    }
}

1;

package Text::Hatena::AutoLink::HatenaSearch;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[search:(?:(keyword|question|asin|web):)?([^\]]+?)\]/i;

__PACKAGE__->patterns([$pattern]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'search.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern/ or return;
    my ($type,$word) = ($1 || '',$2);
    my $enword = $self->html_encode($word);
    if (lc $type eq 'question') {
        return sprintf('<a href="http://%s/questsearch?word=%s&ie=utf8"%s>search:%s:%s</a>',
                       $self->{domain}, $enword, $self->{a_target_string},
                       $type, $word);
    } elsif (lc $type eq 'asin') {
        return sprintf('<a href="http://%s/asinsearch?word=%s&ie=utf8"%s>search:%s:%s</a>',
                       $self->{domain}, $enword, $self->{a_target_string},
                       $type, $word);
    } elsif (lc $type eq 'web') {
        return sprintf('<a href="http://%s/websearch?word=%s&ie=utf8"%s>search:%s:%s</a>',
                       $self->{domain}, $enword, $self->{a_target_string},
                       $type, $word);
    } else {
        return sprintf('<a href="http://%s/keyword?word=%s&ie=utf8"%s>search:%s%s</a>',
                       $self->{domain}, $enword, $self->{a_target_string},
                       $type ? "$type:" : '', $word);
    }
}

1;

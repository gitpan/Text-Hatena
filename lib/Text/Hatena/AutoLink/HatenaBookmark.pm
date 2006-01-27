package Text::Hatena::AutoLink::HatenaBookmark;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_keyword = qr/\[(b:(keyword|t):([^\]]+))\]/i;
my $pattern_usertag = qr/\[(b:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):t:([^\]]+))\]/i;
my $pattern_user = qr/\[?(b:id:([A-Za-z][a-zA-Z0-9_\-]{2,14})(?::(favorite|asin|\d{8}))?)\]?/i;

__PACKAGE__->patterns([$pattern_keyword, $pattern_usertag, $pattern_user]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'b.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    if ($text =~ /$pattern_keyword/) {
        $self->_parse_keyword($text);
    } elsif ($text =~ /$pattern_usertag/) {
        $self->_parse_usertag($text);
    } elsif ($text =~ /$pattern_user/) {
        $self->_parse_user($text);
    }
}

sub _parse_keyword {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_keyword/ or return;
    my ($title, $type, $word) = ($1, $2, $3);
    return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                   $self->{domain}, $type, $self->html_encode($word),
                   $self->{a_target_string}, $title);
}

sub _parse_user {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_user/ or return;
    my ($title, $name, $page) = ($1, $2, $3 || '');
    return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                   $self->{domain}, $name, $page,
                   $self->{a_target_string}, $title);
}

sub _parse_usertag {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_usertag/ or return;
    my ($title, $name, $tag) = ($1, $2, $3);
    return sprintf('<a href="http://%s/%s/%s/"%s>%s</a>',
                   $self->{domain}, $name, $self->html_encode($tag),
                   $self->{a_target_string}, $title);
}

1;

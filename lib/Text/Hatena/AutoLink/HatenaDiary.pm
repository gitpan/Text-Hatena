package Text::Hatena::AutoLink::HatenaDiary;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_about = qr/\[?(d:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):(about|keywordlist))\]?/i;
my $pattern_archive = qr/\[?(d:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):(archive)(?::(\d{6}))?)\]?/i;
my $pattern_diary = qr/\[?(d:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))(\:(\d{8}))?(?:(\#|:)([a-zA-Z0-9_]+))?\]?/i;

__PACKAGE__->patterns([$pattern_about, $pattern_archive, $pattern_diary]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'd.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift;
    if ($text =~ /$pattern_about/) {
        return $self->_parse_about($text);
    } elsif ($text =~ /$pattern_archive/) {
        return $self->_parse_archive($text);
    } elsif ($text =~ /$pattern_diary/) {
        return $self->_parse_diary($text);
    }
}

sub _parse_diary {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_diary/ or return;
    my ($m1,$m2,$m3,$m4,$m5,$m6) = ($1,$2,$3 || '',$4 || '',$5 || '',$6 || '');
    if ($m5) {
        my $delim = $m5 eq ':' ? '/' : '#';
        return sprintf('<a href="http://%s/%s/%s%s%s"%s>%s%s%s%s</a>',
                       $self->{domain}, $m2, $m4, $delim,
                       $m6, $self->{a_target_string}, $m1, $m3, $m5, $m6,);
    } else {
        return sprintf('<a href="http://%s/%s/%s"%s>%s%s</a>',
                       $self->{domain}, $m2, $m4, $self->{a_target_string},
                       $m1, $m3,);
    }
}

sub _parse_about {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_about/ or return;
    my ($content,$username,$page) = ($1,$2,$3 || '');
    return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                   $self->{domain}, $username, $page, $self->{a_target_string},
                   $content);
}

sub _parse_archive {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_archive/ or return;
    my ($content,$username,$page,$month) = ($1,$2,$3 || '',$4 || '');
    $month = "/$month" if $month;
    return sprintf('<a href="%s/%s/%s%s"%s>%s</a>',
                   $self->{domain}, $username, $page, $month,
                   $self->{a_target_string}, $content);
}

1;

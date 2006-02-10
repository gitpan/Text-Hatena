package Text::Hatena::AutoLink::HatenaMap;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_tag = qr/\[(map:t:([^\]]+))\]/i;
my $pattern_map = qr/\[?(map:x(\-?[\d\.]+)y(\-?[\d\.]+))\]?/i;
my $pattern_search = qr/\[(map:([^\]]+))\]/i;

__PACKAGE__->patterns([$pattern_tag, $pattern_map, $pattern_search]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'map.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    if ($text =~ /$pattern_tag/) {
        $self->_parse_tag($text);
    } elsif ($text =~ /$pattern_map/) {
        $self->_parse_map($text);
    } elsif ($text =~ /$pattern_search/) {
        $self->_parse_search($text);
    }
}

sub _parse_tag {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_tag/ or return;
    my ($name, $tag) = ($1, $2);
    return sprintf('<a href="http://%s/t/%s"%s>%s</a>',
                   $self->{domain}, $self->html_encode($tag),
                   $self->{a_target_string}, $name);
}

sub _parse_map {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_map/ or return;
    my ($name, $x, $y) = ($1, $2, $3);
    return sprintf('<a href="http://%s/?x=%s&y=%s&z=4"%s>%s</a>',
                   $self->{domain}, $x, $y,
                   $self->{a_target_string}, $name);
}

sub _parse_search {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_search/ or return;
    my ($name, $wd) = ($1, $2);
    return sprintf('<a href="http://%s/?word=%s"%s>%s</a>',
                   $self->{domain}, $self->html_encode($wd),
                   $self->{a_target_string}, $name);
}

1;

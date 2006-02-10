package Text::Hatena::AutoLink::HatenaGroup;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_group_archive = qr/\[?(g:([a-z][a-z0-9\-]{2,23}))(:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))(:(archive)(?::(\d{6}))?)\]?/i;
my $pattern_group_diary = qr/\[?(g:([a-z][a-z0-9\-]{2,23}))(:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))(\:(\d{8}))?(?:(\#|:)([a-zA-Z0-9_]+))?\]?/i;
my $pattern_group_keyword = qr/\[g:([a-z][a-z0-9\-]{2,23}):keyword:([^\]]+)\]/i;
my $pattern_group_bbs = qr/\[?(?:g:([a-z][a-z0-9\-]{2,23}):)?bbs:(\d+)(?::(\d+))?\]?/i;

__PACKAGE__->patterns([$pattern_group_archive, $pattern_group_diary, $pattern_group_keyword, $pattern_group_bbs]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'g.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift;
    if ($text =~ /$pattern_group_archive/) {
        return $self->_parse_group_archive($text);
    } elsif ($text =~ /$pattern_group_diary/) {
        return $self->_parse_group_diary($text);
    } elsif ($text =~ /$pattern_group_keyword/) {
        return $self->_parse_group_keyword($text);
    } elsif ($text =~ /$pattern_group_bbs/) {
        return $self->_parse_group_bbs($text);
    }
}

sub _parse_group_archive {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_group_archive/ or return;
    my $month = $7 ? "/$7" : '';
    return sprintf('<a href="http://%s.%s/%s/%s%s">%s%s%s</a>',
                   $2,
                   $self->{domain},
                   $4,
                   $6,
                   $month,
                   $1,
                   $3,
                   $5,
               );
}

sub _parse_group_diary {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_group_diary/ or return;
    my ($m1,$m2,$m3,$m4,$m5,$m6,$m7,$m8) = ($1,$2,$3 || '',$4 || '',$5 || '',$6 || '',$7,$8);
    if ($m7) {
        my $delim = $m7 eq ':' ? '/' : '#';
        return sprintf('<a href="http://%s.%s/%s/%s%s%s">%s%s%s%s%s</a>',
                       $m2, $self->{domain}, $m4, $m6, $delim, $m8, $m1, $m3,
                       $m5, $m7, $m8);
    } else {
        return sprintf('<a href="http://%s.%s/%s/%s">%s%s%s</a>',
                       $m2, $self->{domain}, $m4, $m6, $m1, $m3, $m5);
    }
}

sub _parse_group_keyword {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_group_keyword/ or return;
    my ($gname,$word) = ($1,$2);
    my $enword = $self->html_encode($word);
    return sprintf('<a class="okeyword" href="http://%s.%s/keyword/%s">g:%s:keyword:%s</a>',
                   $gname,
                   $self->{domain},
                   $enword,
                   $gname,
                   $word,
               );
}

sub _parse_group_bbs {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_group_bbs/ or return;
    my ($gname,$tid,$aid) = ($1,$2,$3);
    my ($url,$title);
    if ($gname) {
        $url = "http://$gname.".$self->{domain};
        $title = "g:$gname:";
    }
    $url .= "/bbs/$tid";
    $title .= "bbs:$tid";
    if ($aid) {
        $url .= "/$aid";
        $title .= ":$aid";
    }
    return qq|<a href="$url">$title</a>|;
}

1;

package Text::Hatena::AutoLink::EAN;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_title = qr/\[(ean|jan):(\d{8,13}):title=(.+?)\]/i;
my $pattern_simple = qr/\[?(ean|jan):(\d{8,13})\]?/i;

__PACKAGE__->patterns([$pattern_title, $pattern_simple]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{asin_url} = 'http://d.hatena.ne.jp/ean/';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    if ($text =~ /$pattern_title/) {
        return $self->_parse_title($text);
    } elsif ($text =~ /$pattern_simple/) {
        return $self->_parse_simple($text);
    }
}

sub _parse_title {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_title/ or return;
    my ($scheme,$eancode,$title) = ($1,$2,$3);
    $self->check_digit($eancode) or return $text;
    return sprintf('<a href="%s%s"%s>%s</a>',
                   $self->{asin_url}, $eancode, $self->{a_target_string}, $title);
}

sub _parse_simple {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_simple/ or return;
    my ($scheme, $eancode) = ($1,$2);
    return sprintf('<a href="%s%s"%s>%s:%s</a>',
                   $self->{asin_url}, $eancode, $self->{a_target_string},
                   $scheme, $eancode);
}

sub check_digit {
    my $self = shift;
    my $ean = shift or return;
    my $length = length($ean);
    ($length == 8 || $length == 13) or return;
    my ($odd,$even);
    for (my $i = 0 ; $i < $length - 1 ; $i++) {
        my $num = substr($ean,$length - $i - 2,1);
        if ($i % 2) {
            $odd += $num;
        } else {
            $even += $num;
        }
    }
    my $digit = 10 - (($odd + ($even * 3)) % 10);
    return substr($ean,$length - 1) == $digit % 10;
}

# sub as_isbn {
#     my $self = shift;
#     my $ean = shift or return;
#     if ($ean =~ /^978(\d{9})\d$/) {
#         my $isbn = $1;
#         my $i = 10;
#         my $digit;
#         for (split '',$isbn) {
#             $digit += $i-- * $_;
#         }
#         my $checkdigit = 11 - ($digit % 11);
#         $checkdigit = 'X' if $checkdigit == 10;
#         $checkdigit = '0' if $checkdigit == 11;
#         return "$isbn$checkdigit";
#     }
#     return;
# }

1;

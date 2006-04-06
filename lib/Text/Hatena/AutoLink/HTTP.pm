package Text::Hatena::AutoLink::HTTP;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);
use LWP::UserAgent;

my $pattern_simple = qr/\[?(https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+)\]?/i;
my $pattern_useful = qr/\[(https?:\/\/[A-Za-z0-9~\/._\?\&=\-%#\+:\;,\@\']+?):(title(?:=([^\]]*))?|barcode|detail|image(?::([hw]\d+))?)\]/i;

__PACKAGE__->patterns([$pattern_useful, $pattern_simple]);

sub parse {
    my $self = shift;
    my $text = shift;
    my $opt = shift;
    if ($text =~ /$pattern_useful/) {
        return $self->_parse_useful($text, $opt);
    } elsif ($text =~ /$pattern_simple/) {
        return $self->_parse_simple($text);
    }
}

sub _parse_simple {
    my $self = shift;
    my $url = shift or return;
    $url =~ s/^\[//;
    $url =~ s/\[$//;
    return sprintf('<a href="%s"%s>%s</a>',
                       $url,
                       $self->{a_target_string},
                       $url,
                   );
}

sub _parse_useful {
    my $self = shift;
    my $text = shift or return;
    my $opt = shift;
    $text =~ /$pattern_useful/ or return;
    my ($url,$type,$title,$size) = ($1, $2, $3, $4 || '');
    if ($type =~ /^title/i) {
        $title ||= $self->_get_page_title($url);
        return sprintf('<a href="%s"%s>%s</a>',
                       $url,
                       $self->{a_target_string},
                       $title,
                   );

    } elsif ($type =~ /^detail/i) {
        $title ||= $self->_get_page_title($url);
        my $html = sprintf('<div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="%s"%s>%s</a></p><p class="hatena-http-detail-title">%s</p></div>',
                       $url,
                       $self->{a_target_string},
                       $url,
                       $title,
                   );
        $html = "</p>$html<p>" if $opt->{in_paragraph};
        return $html;
    } elsif ($type =~ /^image/i) {
        if ($url =~ /\.(jpg|jpeg|gif|png|bmp)$/i) {
            my $size_string = '';
            if ($size =~ /^h(\d+)$/i) {
                $size_string = sprintf(' height="%d"', $1);
            } elsif ($size =~ /^w(\d+)$/i) {
                $size_string = sprintf(' width="%d"', $1);
            }
            return sprintf('<a href="%s"%s><img src="%s" alt="%s" class="hatena-http-image"%s></a>',
                           $url,
                           $self->{a_target_string},
                           $url,
                           $url,
                           $size_string,
                       );
        } else {
            return sprintf('<a href="%s"%s>%s</a>',
                           $url,
                           $self->{a_target_string},
                           $url,
                       );
        }
    } elsif ($type =~ /^barcode$/i) {
        my $str = $self->html_encode($url);
        return sprintf('<a href="%s"%s><img src="http://d.hatena.ne.jp/barcode?str=%s" class="barcode" alt="%s"></a>',
                       $url,
                       $self->{a_target_string},
                       $str,
                       $url,
                   );
    }
}

sub _get_page_title {
    my $self = shift;
    my $url = shift or return;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->max_size(131072); # 2^17
    my $req = HTTP::Request->new(GET => $url);
    my $res = $ua->request($req);
    return unless $res->is_success;
    my $content = $res->content or return;
    $content =~ /<title.*?>(.*?)<\/title>/is or return;
    my $title = $1;
    if (my $h = $self->{option}->{title_handler}) {
        my ($cset,$ct);
        if ($ct = $res->header("Content-type") && $ct =~ /charset="?(.+?)"?$/i) {
            $cset = lc $1;
        } elsif ($content =~ /<meta[^>]+charset="?([\w\d\s\-]+)"?/i) {
            $cset = lc $1;
        }
        $title = &{$h}($title, $cset);
    }
    return $title;
}

1;

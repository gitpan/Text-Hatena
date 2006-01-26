package Text::Hatena::AutoLink::ASIN;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);
use Net::Amazon;
use Template;
use Encode;

my $pattern_asin_title = qr/\[(isbn|asin):([\w\-]{10,16}):title=(.*?)\]/i;
my $pattern_asin = qr/\[?(isbn|asin):([\w\-]{10,16}):?(image|detail|title)?:?(small|large)?\]?/i;
my $detail_template = <<'END';
<div class="hatena-asin-detail">
  <a href="[% asin_url | uri %]"><img src="[% property.ImageUrlSmall || property.ImageUrlLarge || property.ImageUrlMedium | utf8off | uri %]" class="hatena-asin-detail-image" alt="[% title | utf8off | html %]" title="[% title | utf8off | html %]"></a>
  <div class="hatena-asin-detail-info">
  <p class="hatena-asin-detail-title"><a href="[% asin_url | uri %]">[% title | utf8off | html %]</a></p>
  <ul>
    [% IF property.artists %]<li><span class="hatena-asin-detail-label">アーティスト:</span> [% FOREACH artist = property.artists %]<a href="[% keyword_url %][% artist | utf8off | enword %]" class="keyword">[% artist | utf8off | html %]</a> [% END %]</li>[% END %]
    [% IF property.authors %]<li><span class="hatena-asin-detail-label">作者:</span> [% FOREACH author = property.authors %]<a href="[% keyword_url %][% author | utf8off | enword %]" class="keyword">[% author | utf8off | html %]</a> [% END %]</li>[% END %]
    [% IF property.publisher %]<li><span class="hatena-asin-detail-label">出版社/メーカー:</span> <a href="[% keyword_url %][% property.publisher | utf8off | enword %]" class="keyword">[% property.publisher | utf8off | html %]</a></li>[% END %]
    [% IF property.ReleaseDate %]<li><span class="hatena-asin-detail-label">発売日:</span> [% property.ReleaseDate | utf8off | html %]</li>[% END %]
    <li><span class="hatena-asin-detail-label">メディア:</span> [% property.Media | utf8off | html %]</li>
  </ul>
</div>
<div class="hatena-asin-detail-foot"></div>
</div>
END

__PACKAGE__->patterns([$pattern_asin_title, $pattern_asin]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{asin_url} = 'http://d.hatena.ne.jp/asin/';
    $self->{keyword_url} = 'http://d.hatena.ne.jp/keyword/';
    $self->{amazon_token} = $self->{option}->{amazon_token} || 'D3TT1SUCX72K1N';
    $self->{amazon_locale} = $self->{option}->{amazon_locale} || 'jp';
    $self->{amazon_affiliate_id} = $self->{option}->{amazon_affiliate_id} || 'hatena-22';
    $self->{affiliate_path} = $self->{option}->{amazon_affiliate_id} ?
        '/' . $self->{amazon_affiliate_id} : '';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    my $opt = shift;
    if ($text =~ /$pattern_asin_title/) {
        return $self->_parse_asin_title($text);
    } elsif ($text =~ /$pattern_asin/) {
        return $self->_parse_asin($text, $opt);
    }
}

sub _parse_asin_title {
    my $self = shift;
    my $text = shift;
    $text =~ /$pattern_asin_title/ or return;
    my ($scheme,$asincode,$title) = ($1,$2,$3);
    $asincode = uc($asincode);
    $asincode =~ s/\-//g;
    $title ||= $self->get_asin_title($asincode) || "$scheme:$asincode";
    return sprintf('<a href="%s%s%s"%s>%s</a>',
                   $self->{asin_url},
                   $asincode,
                   $self->{affiliate_path},
                   $self->{a_target_string},
                   $title,
               );
}

sub _parse_asin {
    my $self = shift;
    my $text = shift;
    my $opt = shift;
    $text =~ /$pattern_asin/ or return;
    my ($scheme,$asincode,$type,$size) = ($1, $2, $3 || '', $4 || '');
    $asincode = uc($asincode);
    $asincode =~ s/\-//g;
    my $asin_url = sprintf('%s%s%s', $self->{asin_url}, $asincode, $self->{affiliate_path});
    if ($type =~ /^title/i) {
        my $title = $self->get_asin_title($asincode) || "$scheme:$asincode";
        return sprintf('<a href="%s"%s>%s</a>',
                       $asin_url,
                       $self->{a_target_string},
                       $title,
                   );
    } elsif ($type =~ /^image/i) {
        $size = ucfirst(lc($size)) || 'Medium';
        my $prop = $self->get_property($asincode);
        my $method = 'ImageUrl'.$size;
        if ($prop && (my $url = $prop->$method)) {
            my $title = $prop->ProductName || "$scheme:$asincode";
            Encode::_utf8_off($title);
            Encode::_utf8_off($url);
            return sprintf('<a href="%s"%s><img src="%s" alt="%s" title="%s" class="asin"></a>',
                           $asin_url,
                           $self->{a_target_string},
                           $url,
                           $title,
                           $title,
                       );
        } else {
            return sprintf('<a href="%s"%s>%s:%s</a>',
                           $asin_url,
                           $self->{a_target_string},
                           $scheme,
                           $asincode,
                       );
        }
    } elsif ($type =~ /^detail/i) {
        my $t = Template->new(
            FILTERS => {
                enword => sub {
                    my $str = shift;
                    use bytes;
                    $str =~ s/(\W)/sprintf("%%%02x",ord($1))/eg;
                    $str =~ s|%2f|/|gio;
                    return $str;
                },
                utf8off => sub {
                    my $str = shift;
                    Encode::_utf8_off($str);
                    return $str;
                },
            },
        );
        my $prop = $self->get_property($asincode) or return;
        my $title = $prop->ProductName || "$scheme:$asincode";
        my $html = '';
        $t->process(\$detail_template, {
            property => $prop,
            asin_url => $asin_url,
            title => $title,
            keyword_url => $self->{keyword_url},
        }, \$html);
        $html = "</p>$html<p>" if $opt->{in_paragraph};
        return $html;
    } else {
        return sprintf('<a href="%s"%s>%s</a>',
                       $asin_url,
                       $self->{a_target_string},
                       $text,
                   );
    }
}

sub get_property {
    my $self = shift;
    my $asin = shift or return;
    my $response = $self->ua->search(asin => $asin);
    if($response->is_success()) {
        return $response->properties;
    } else {
        warn "Error: ", $response->message(), "\n";
        return;
    }
}

sub get_asin_title {
    my $self = shift;
    my $asin = shift or return;
    my $prop = $self->get_property($asin) or return;
    my $title = $prop->ProductName or return;
    Encode::_utf8_off($title);
    return $title;
}

sub ua {
    my $self = shift;
    $self->{ua} ||= Net::Amazon->new(
        token => $self->{amazon_token},
        locale => $self->{amazon_locale} || '',
        affiliate_id => $self->{amazon_affiliate_id},
    );
}

1;

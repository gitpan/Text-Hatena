package Text::Hatena::AutoLink::HatenaFotolife;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_foto = qr/\[?f:id:([A-Za-z][a-zA-Z0-9_\-]{2,14})(?::(\d{14}|favorite)([jpg])?)?(?::(image)(?::?(small|h\d+|w\d+))?)?\]?/i;
my $pattern_keyword = qr/\[(f:(keyword|t):([^\]]+))\]/i;

__PACKAGE__->patterns([$pattern_foto, $pattern_keyword]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'f.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    if ($text =~ /$pattern_foto/) {
        $self->_parse_foto($text);
    } elsif ($text =~ /$pattern_keyword/) {
        $self->_parse_keyword($text);
    }
}

sub _parse_foto {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_foto/ or return;
    my ($name,$fid,$ext,$type,$size) = ($1,$2 || '',$3 || '',$4 || '',$5 || '');
    if ($ext =~ /^g$/i) {
        $ext = 'gif';
    } elsif ($ext =~ /^p$/i) {
        $ext = 'png';
    } else {
        $ext = 'jpg'
    }
    if (!$fid || $fid =~ /^favorite$/i) {
        return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                       $self->{domain},
                       $name,
                       $fid,
                       $self->{a_target_string},
                       $text,
                   );
    } elsif ($type =~ /image/i) {
        my $firstchar = substr($name,0,1);
        my $date = substr($fid,0,8);
        my ($size_str, $file_name) = ('','');
        if ($size =~ /small/i) {
            $file_name = sprintf('%s_m.gif', $fid);
        } else {
            $file_name = sprintf('%s.%s', $fid, $ext);
            if ($size =~ /h(\d+)/i) {
                $size_str = sprintf(' height="%d"', $1);
            } elsif ($size =~ /w(\d+)/i) {
                $size_str = sprintf(' width="%d"', $1);
            }
        }
        return sprintf('<a href="http://%s/%s/%s"%s><img src="http://%s/images/fotolife/%s/%s/%d/%s" alt="%s" title="%s"%s></a>',
                       $self->{domain},
                       $name,
                       $fid,
                       $self->{a_target_string},
                       $self->{domain},
                       $firstchar,
                       $name,
                       $date,
                       $file_name,
                       $text,
                       $text,
                       $size_str,
                   );
    } else {
        return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                       $self->{domain},
                       $name,
                       $fid,
                       $self->{a_target_string},
                       $text,
                   );
    }
}

sub _parse_keyword {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_keyword/ or return;
    my ($title, $type, $word) = ($1, $2, $3 || '');
    return sprintf('<a href="http://%s/%s/%s"%s>%s</a>',
                   $self->{domain}, $type, $self->html_encode($word),
                   $self->{a_target_string}, $title);
}

1;

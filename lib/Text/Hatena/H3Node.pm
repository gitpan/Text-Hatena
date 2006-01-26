package Text::Hatena::H3Node;
use strict;
use base qw(Text::Hatena::Node);

sub init {
    my $self = shift;
    $self->{pattern} = qr/^\*(?:(\d{9,10}|[a-zA-Z]\w*)\*)?((?:\[[^\:\[\]]+\])+)?(.*)$/;
}

sub parse {
    my $self = shift;
    my $c = $self->{context};
    my $l = $c->shiftline or return;
    $l =~ /$self->{pattern}/ or return;
    my ($name,$cat,$title) = ($1,$2,$3);
    my $b = $c->baseuri;
    my $p = $c->permalink;
    my $t = "\t" x $self->{ilevel};
    my $sa = $c->sectionanchor;

    if ($cat) {
        $cat =~ s!
            \[([^\:\[\]]+)\]
        !
            my $w = $1;
            my $ew = $self->_encode($1);
            qq|[<a class="sectioncategory" href="$b?word=$ew">$w</a>]|;
        !gex;
    }
    my $extra;
    ($name, $extra) = $self->_formatname($name);
    $extra ||= '';
    $cat ||= '';
    $c->htmllines(qq($t<h3><a href="$p#$name" name="$name"><span class="sanchor">$sa</span></a> $cat$title</h3>$extra));
}

sub _formatname {
    my $self = shift;
    my $name = shift;
    if ($name && $name =~ /^\d{9,10}$/) {
        my $m = sprintf('%02d', (localtime($name))[1]);
        my $h = sprintf('%02d', (localtime($name))[2]);
        return (
            $name,
            qq| <span class="timestamp">$h:$m</span>|,
        );
    } elsif ($name) {
        return ($name);
    } else {
        $self->{context}->incrementsection;
        $name = 'p' . $self->{context}->sectioncount;
        return ($name);
    }
}

sub _encode {
    my $self = shift;
    my $str = shift or return;
    use bytes;
    $str =~ s/(\W)/sprintf("%%%02x",ord($1))/eg;
    return $str;
}

1;

package Text::Hatena::FootnoteNode;
use strict;
use base qw(Text::Hatena::Node);
use Text::Hatena::Text;

sub parse {
    my $self = shift;
    my $c = $self->{context};
    @{$c->footnotes} or return;
    my $t = "\t" x $self->{ilevel};
    my $p = $c->permalink;
    $self->{html} = '';

    $self->{html} .= qq|$t<div class="footnote">\n|;
    my $i;
    my $text = Text::Hatena::Text->new(context => $c);
    for my $note (@{$c->footnotes}) {
        $i++;
        $text->parse($note);
        my $l = qq|$t\t<p class="footnote"><a href="$p#fn$i" name="f$i">*$i</a>: |
            . $text->html
            . qq|</p>|;
        $self->{html} .= "$l\n";
    }
    $self->{html} .= qq|$t</div>\n|;
}

sub html { $_[0]->{html}; }

1;

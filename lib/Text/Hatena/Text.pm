package Text::Hatena::Text;
use strict;

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        context => $args{context},
        html => '',
    };
    bless $self,$class;
}

sub parse {
    my $self = shift;
    $self->{html} = '';
    my $text = shift or return;
    $self->{html} = $text;
    my $c = $self->{context};
    my $p = $c->permalink;
    $self->{html} =~ s!
        \(\((.+?)\)\)
    !
        my ($note,$pre,$post) = ($1,$`,$');
        if ($pre =~ /\)$/ && $post =~ /^\(/) {
            "(($note))";
        } else {
            my $notes = $c->footnotes($note);
            my $num = $#$notes + 1;
            $note =~ s/<.*?>//g;
            $note =~ s/\&/\&amp\;/g;
            qq|<span class="footnote"><a href="$p#f$num" title="$note" name="fn$num">*$num</a></span>|;
        }
    !egox;
}

sub html { $_[0]->{html}; }

1;

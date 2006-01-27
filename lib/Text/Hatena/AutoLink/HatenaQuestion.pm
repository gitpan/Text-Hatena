package Text::Hatena::AutoLink::HatenaQuestion;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_user = qr/\[?(q:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))\]?/i;
my $pattern_question = qr/\[?(question:(\d+))\]?/i;

__PACKAGE__->patterns([$pattern_user, $pattern_question]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'q.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    if ($text =~ /$pattern_user/) {
        $self->_parse_user($text);
    } elsif ($text =~ /$pattern_question/) {
        $self->_parse_question($text);
    }
}

sub _parse_user {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_user/ or return;
    my ($title, $name) = ($1,$2);
    return sprintf('<a href="http://%s/%s/"%s>%s</a>',
                   $self->{domain}, $name, $self->{a_target_string}, $title);
}

sub _parse_question {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_question/ or return;
    my ($title, $qid) = ($1,$2);
    return sprintf('<a href="http://%s/%s"%s>%s</a>',
                   $self->{domain}, $qid, $self->{a_target_string}, $title);
}

1;

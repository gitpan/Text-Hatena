package Text::Hatena::AutoLink::HatenaIdea;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_user = qr/\[?(i:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}))\]?/i;
my $pattern_tag = qr/\[(i:t:([^\]]+))\]/i;
my $pattern_idea = qr/\[?(idea:(\d+))\]?/i;

__PACKAGE__->patterns([$pattern_user, $pattern_idea, $pattern_tag]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'i.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    if ($text =~ /$pattern_user/) {
        $self->_parse_user($text);
    } elsif ($text =~ /$pattern_idea/) {
        $self->_parse_idea($text);
    } elsif ($text =~ /$pattern_tag/) {
        $self->_parse_tag($text);
    }
}

sub _parse_idea {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_idea/ or return;
    my ($title, $iid) = ($1,$2);
    return sprintf('<a href="http://%s/idea/%s"%s>%s</a>',
                   $self->{domain}, $iid, $self->{a_target_string}, $title);
}

sub _parse_user {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_user/ or return;
    my ($title, $name) = ($1,$2);
    return sprintf('<a href="http://%s/%s/"%s>%s</a>',
                   $self->{domain}, $name, $self->{a_target_string}, $title);
}

sub _parse_tag {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_tag/ or return;
    my ($title, $word) = ($1,$2);
    return sprintf('<a href="http://%s/t/%s"%s>%s</a>',
                   $self->{domain}, $self->html_encode($word),
                   $self->{a_target_string}, $title);
}

1;

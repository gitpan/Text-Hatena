package Text::Hatena::AutoLink::HatenaGraph;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern_tag = qr/\[(graph:t:([^\]]+))\]/i;
my $pattern_image = qr/\[graph:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):(.+):image\]/i;
my $pattern_simple = qr/\[graph:id:([A-Za-z][a-zA-Z0-9_\-]{2,14}):(.+)\]/i;
my $pattern_user = qr/\[?graph:id:([A-Za-z][a-zA-Z0-9_\-]{2,14})\]?/i;

__PACKAGE__->patterns([$pattern_tag, $pattern_image, $pattern_simple, $pattern_user]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = 'graph.hatena.ne.jp';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    if ($text =~ /$pattern_tag/) {
        $self->_parse_tag($text);
    } elsif ($text =~ /$pattern_image/) {
        $self->_parse_image($text);
    } elsif ($text =~ /$pattern_simple/) {
        $self->_parse_simple($text);
    } elsif ($text =~ /$pattern_user/) {
        $self->_parse_user($text);
    }
}

sub _parse_tag {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_tag/ or return;
    my ($name, $tag) = ($1, $2);
    return sprintf('<a href="http://%s/t/%s"%s>%s</a>',
                   $self->{domain}, $self->html_encode($tag),
                   $self->{a_target_string}, $name);
}

sub _parse_image {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_image/ or return;
    my ($name,$graphname) = ($1,$2);
    my $engname = $self->html_encode($graphname);
    return sprintf('<a href="http://%s/%s/%s/"%s><img src="http://%s/%s/graph?graphname=%s" class="hatena-graph-image" alt="%s" title="%s"></a>',
                   $self->{domain}, $name, $engname, $self->{a_target_string},
                   $self->{domain}, $name, $engname,
                   $self->escape_attr($graphname), $self->escape_attr($graphname));
}

sub _parse_simple {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_simple/ or return;
    my ($name,$graphname) = ($1,$2);
    return sprintf('<a href="http://%s/%s/%s/"%s>graph:id:%s:%s</a>',
                   $self->{domain}, $name, $self->html_encode($graphname),
                   $self->{a_target_string}, $name, $graphname);
}

sub _parse_user {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern_user/ or return;
    my $name = $1;
    return sprintf('<a href="http://%s/%s/"%s>graph:id:%s</a>',
                   $self->{domain}, $name, $self->{a_target_string}, $name);
}

1;

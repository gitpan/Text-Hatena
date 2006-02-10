package Text::Hatena::AutoLink::Amazon;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[amazon:([^\]]+?)\]/i;

__PACKAGE__->patterns([$pattern]);

sub init {
    my $self = shift;
    $self->SUPER::init;
    $self->{domain} = $self->{option}->{domain} || 'www.amazon.co.jp';
    $self->{amazon_affiliate_id} = $self->{option}->{amazon_affiliate_id} || 'hatena-22';
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern/ or return;
    my $word = $1;
    return sprintf('<a href="http://%s/exec/obidos/external-search?mode=blended&tag=%s&encoding-string-jp=%s&keyword=%s"%s>amazon:%s</a>',
                   $self->{domain}, $self->{amazon_affiliate_id},
                   $self->html_encode('日本語'), $self->html_encode($word),
                   $self->{a_target_string}, $word);
}

1;

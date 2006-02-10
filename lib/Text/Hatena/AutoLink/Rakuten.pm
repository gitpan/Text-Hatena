package Text::Hatena::AutoLink::Rakuten;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);
use Jcode;

my $pattern = qr/\[rakuten:([^\]]+?)\]/i;

__PACKAGE__->patterns([$pattern]);

sub parse {
    my $self = shift;
    my $text = shift or return;
    $text =~ /$pattern/ or return;
    my $word = $1;
    return sprintf('<a href="http://pt.afl.rakuten.co.jp/c/002e8f0a.89099887/?sv=2&v=3&p=0&sitem=%s"%s>rakuten:%s</a>',
                   $self->html_encode(Jcode->new($word,'utf8')->euc),
                   $self->{a_target_string}, $word);
}

1;

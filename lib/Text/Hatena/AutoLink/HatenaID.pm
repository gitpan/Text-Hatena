package Text::Hatena::AutoLink::HatenaID;
use strict;
use base qw(Text::Hatena::AutoLink::Scheme);

my $pattern = qr/\[?(id:([A-Za-z][a-zA-Z0-9_\-]{2,14})(?::(detail|image))?)\]?/i;

__PACKAGE__->patterns([$pattern]);

sub parse {
    my $self = shift;
    my $text = shift;
    $text =~ /$pattern/ or return;
    my ($content,$name,$type) = ($1,$2,$3);
    if (lc $type eq 'image') {
        my $pre = substr($name, 0, 2);
        return sprintf('<a href="/%s/"%s><img src="http://www.hatena.ne.jp/users/%s/%s/profile.gif" width="60" height="60" alt="id:%s" class="hatena-id-image"></a>',
                       $name, $self->{a_target_string}, $name, $pre, $name);
    } elsif (lc $type eq 'detail') {
        my $pre = substr($name, 0, 2);
        return sprintf('<a href="/%s/"%s><img src="http://www.hatena.ne.jp/users/%s/%s/profile_s.gif" width="16" height="16" alt="id:%s" class="hatena-id-icon">id:%s</a>',
                       $name, $self->{a_target_string}, $name, $pre,
                       $name, $name);
    } else {
        return sprintf('<a href="/%s/"%s>%s</a>',
                       $name, $self->{a_target_string}, $content);
    }
}

1;

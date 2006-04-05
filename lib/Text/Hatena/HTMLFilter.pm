package Text::Hatena::HTMLFilter;
use strict;
use HTML::Parser;

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
	context => $args{context},
	html => '',
        in_paragraph => 0,
        in_anchor => 0,
        in_superpre => 0,
    };
    bless $self,$class;
    $self->init;
    return $self;
}

sub init {
    my $self = shift;
    $self->{parser} = HTML::Parser->new(
	api_version => 3,
	handlers => {
	    start => [$self->starthandler, 'tagname, attr, text'],
	    end => [$self->endhandler, 'tagname, text'],
	    text => [$self->texthandler, 'text'],
	    comment => [$self->commenthandler, 'text'],
	},
    );
}

sub parse {
    my $self = shift;
    my $html = shift or return;
    $self->{parser}->parse($html);
}

sub texthandler {
    my $self = shift;
    return sub {
	my $text = shift;
	$text = &{$self->{context}->texthandler}($text, $self->{context}, $self);
	$self->{html} .= $text;
    }
}

sub starthandler {
    my $self = shift;
    return sub {
	my ($tagname, $attr, $text) = @_;
        if ($tagname eq 'p') {
            $self->{in_paragraph} = 1;
        } elsif ($tagname eq 'a') {
            $self->{in_anchor} = 1;
        } elsif ($tagname eq 'pre' && $attr->{class} eq 'hatena-super-pre') {
            $self->{in_superpre} = 1;
        }
        $self->{html} .= $text;
#         my $ret = "<$tagname";
#         for my $p (keys %{$attr}) {
#             my $v = $attr->{$p};
# #             if ($p =~ /^(src|href|cite)$/i) {
# #                 $v = $self->autolink($v);
# #             }
#             $ret .= qq| $p="$v"|;
#         }
#         $ret .= ">";
#         $self->{html} .= $ret;
    }
}

sub endhandler {
    my $self = shift;
    return sub {
	my ($tagname, $text) = @_;
        if ($tagname eq 'p') {
            $self->{in_paragraph} = 0;
        } elsif ($tagname eq 'a') {
            $self->{in_anchor} = 0;
        } elsif ($tagname eq 'pre' && $self->{in_superpre}) {
            $self->{in_superpre} = 0;
        }
        $self->{html} .= $text;
    }
}

sub commenthandler {
    my $self = shift;
    return sub {
	$self->{html} .= "<!-- -->";
    }
}

# sub sanitize {
#     my $self = shift;
#     my $str = shift;
#     length $str or return;
#     $str =~ s/&(?![\#a-zA-Z0-9_]{2,6};)/&amp;/g;
#     $str =~ s/\</\&lt\;/g;
#     $str =~ s/\>/\&gt\;/g;
#     $str =~ s/\"/&quot;/g;
#     $str =~ s/\'/&#39;/g;
#     $str =~ s/\\/\&#92\;/g;
#     return $str;
# }

# sub sanitize_url {
#     my $self = shift;
#     my $url = shift or return;
#     $url =~ s/^\s+//;
#     $url =~ /^(\&|about|\:)/ and return '';
#     if ($url =~ /^([A-Za-z]+:)/) {
# 	my $scheme = $1;
# 	$scheme =~ /^(http|ftp|https|mailto|rtsp|mms):/i or return '';
#     } elsif ($url =~ /^(\.|\/|#)/) {
#     } else {
# 	$url = "./$url";
#     }
#     $url =~ s/["'\(\)<>]//g;
#     return $url;
# }

sub html { $_[0]->{html}; }
sub in_paragraph { $_[0]->{in_paragraph}; }
sub in_anchor { $_[0]->{in_anchor}; }
sub in_superpre { $_[0]->{in_superpre}; }

1;

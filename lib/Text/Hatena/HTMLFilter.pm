package Text::Hatena::HTMLFilter;
use strict;
use HTML::Parser;

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
	context => $args{context},
	html => '',
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
    $self->{allowtag} = qr/^(a|abbr|acronym|address|b|base|basefont|big|blockquote|br|col|em|caption|center|cite|code|div|dd|del|dfn|dl|dt|fieldset|font|form|hatena|h\d|hr|i|img|input|ins|kbd|label|legend|li|meta|ol|optgroup|option|p|pre|q|rb|rp|rt|ruby|s|samp|select|small|span|strike|strong|sub|sup|table|tbody|td|textarea|tfoot|th|thead|tr|tt|u|ul|var)$/;
    $self->{allallowattr} = qr/^(accesskey|align|alt|background|bgcolor|border|cite|class|color|datetime|height|id|size|title|type|valign|width)$/;
    $self->{allowattr} = {
	a => 'href|name|target',
	base => 'href|target',
	basefont => 'face',
	blockquote => 'cite',
	br => 'clear',
	col => 'span',
	font => 'face',
	form => 'action|method|target|enctype',
	hatena => '.+',
	img => 'src',
	input => 'type|name|value|tabindex|checked|src',
	label => 'for',
	li => 'value',
	meta => 'name|content',
	ol => 'start',
	optgroup => 'label',
	option => 'value',
	select => 'name|accesskey|tabindex',
	table => 'cellpadding|cellspacing',
	td => 'rowspan|colspan|nowrap',
	th => 'rowspan|colspan|nowrap',
	textarea => 'name|cols|rows',
    };
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
	$text = &{$self->{context}->texthandler}($text, $self->{context});
	$self->{html} .= $text;
    }
}

sub starthandler {
    my $self = shift;
    return sub {
	my ($tagname, $attr, $attrseq, $text) = @_;
	if ($tagname =~ /$self->{allowtag}/) {
	    my $ret = "<$tagname";
	    for my $p (keys %{$attr}) {
		my $v = $attr->{$p};
		if ($p =~ /$self->{allallowattr}/) {
		} elsif ($self->{allowattr}->{$tagname}) {
		    $p =~ /^($self->{allowattr}->{$tagname})$/i or next;
		} else {
		    next;
		}
		if ($p =~ /^(src|href|cite)$/i) {
		    $v = $self->sanitize_url($v);
		} else {
		    $v = $self->sanitize($v);
		}
		$ret .= qq| $p="$v"|;
	    }
	    $ret .= ">";
	    $self->{html} .= $ret;
	} else {
	    $self->{html} .= $self->sanitize($text);
	}
    }
}

sub endhandler {
    my $self = shift;
    return sub {
	my ($tagname, $text) = @_;
	if ($tagname =~ /$self->{allowtag}/) {
	    $self->{html} .= "</$tagname>";
	} else {
	    $self->{html} .= $self->sanitize($text);
	}
    }
}

sub commenthandler {
    my $self = shift;
    return sub {
	$self->{html} .= "<!-- -->";
    }
}

sub sanitize {
    my $self = shift;
    my $str = shift;
    length $str or return;
    $str =~ s/&(?![\#a-zA-Z0-9_]{2,6};)/&amp;/g;
    $str =~ s/\</\&lt\;/g;
    $str =~ s/\>/\&gt\;/g;
    $str =~ s/\"/&quot;/g;
    $str =~ s/\'/&#39;/g;
    $str =~ s/\\/\&#92\;/g;
    return $str;
}

sub sanitize_url {
    my $self = shift;
    my $url = shift or return;
    $url =~ s/^\s+//;
    $url =~ /^(\&|about|\:)/ and return '';
    if ($url =~ /^([A-Za-z]+:)/) {
	my $scheme = $1;
	$scheme =~ /^(http|ftp|https|mailto|rtsp|mms):/i or return '';
    } elsif ($url =~ /^(\.|\/|#)/) {
    } else {
	$url = "./$url";
    }
    $url =~ s/["'\(\)<>]//g;
    return $url;
}

sub html { $_[0]->{html}; }

1;

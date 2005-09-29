use strict;
use Test::More tests => 45;
BEGIN { use_ok('Text::Hatena') };

my $base = 'http://d.hatena.ne.jp/jkondo/';
my $perma = 'http://d.hatena.ne.jp/jkondo/20050906';
my $sa = 'sa';

my $p = Text::Hatena->new(
	baseuri => $base,
	permalink => $perma,
	ilevel => 0,
	invalidnode => [],
	sectionanchor => $sa,
);
ok (ref($p) eq 'Text::Hatena');
my ($text,$html,@a);

@a = ('title','body');
$text = &h3text(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ /<h3>/);
ok ($html =~ /<div class="section">/);
ok ($html =~ /\Q$perma\E/);
ok ($html =~ m!<span class="sanchor">\Q$sa\E</span>!);
ok ($html =~ /$a[0]/);
ok ($html =~ m!<p>$a[1]</p>!);

@a = (1234567890);
$text = &h3timetext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ /#$a[0]/);
ok ($html =~ /name="$a[0]"/);
ok ($html =~ m!<span class="timestamp">08:31</span>!);

@a = ('hobby');
$text = &h3cattext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ /#$a[0]/);
ok ($html =~ /name="$a[0]"/);
ok ($html =~ m!\[<a[^>]+>$a[0]</a>\]!i);

@a = ('h4title');
$text = &h4text(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<h4>$a[0]</h4>!);

@a = ('h5title');
$text = &h5text(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<h5>$a[0]</h5>!);

@a = ('quoted');
$text = &blockquotetext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<blockquote>!);
ok ($html =~ m!<p>$a[0]</p>!);

@a = ('cinnamon', 'dog');
$text = &dltext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<dl>!);
ok ($html =~ m!<dt>$a[0]</dt>!);
ok ($html =~ m!<dd>$a[1]</dd>!);

@a = ('komono', 'kyoto', 'shibuya');
$text = &ultext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<ul>!);
ok ($html =~ m!<li>$a[0]</li>!);
ok ($html =~ m!<li>$a[1]</li>!);
ok ($html =~ m!<li>$a[2]</li>!);

$text = &ultext2(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<ul>.+<ul>.+<ul>!s);
ok ($html =~ m!<li>$a[0]</li>!);
ok ($html =~ m!<li>$a[1]</li>!);
ok ($html =~ m!<li>$a[2]</li>!);

$text = &oltext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<ol>!);
ok ($html =~ m!<li>$a[0]</li>!);
ok ($html =~ m!<li>$a[1]</li>!);
ok ($html =~ m!<li>$a[2]</li>!);

@a = ('#!/usr/bin/perl');
$text = &pretext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<pre>!);
ok ($html =~ m!\Q$a[0]\E!);

$text = &superpretext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<pre>!);
ok ($html =~ m!\Q$a[0]\E!);

@a = ('Lang', 'Module', 'Perl', 'Text::Hatena');
$text = &tabletext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!<table>.+</table>!s);
ok ($html =~ m!<tr>.+</tr>.+<tr>.+</tr>!s);
ok ($html =~ m!<th>$a[0]</th>!);
ok ($html =~ m!<th>$a[1]</th>!);
ok ($html =~ m!<td>$a[2]</td>!);
ok ($html =~ m!<td>$a[3]</td>!);

@a = ('GNU', 'GNU Is Not Unix', 'is not unix');
$text = &footnotetext(@a);
$p->parse($text);
$html = $p->html;
ok ($html =~ m!$a[0]<span class="footnote"><a.+?>\*1</a></span>$a[2]!);
ok ($html =~ m!<p class="footnote"><a.+?>\*1</a>.+$a[1]</p>!s);

sub h3text {
	return <<END;
*$_[0]
$_[1]
END
}

sub h3timetext {
	return <<END;
*$_[0]*record time
remember time.
END
}

sub h3cattext {
	return <<END;
*$_[0]*[$_[0]]my hobby
I like this.
END
}

sub h4text {
	return <<END;
**$_[0]

h4body
END
}

sub h5text {
	return <<END;
***$_[0]

h5body
END
}

sub blockquotetext {
	return <<END;
>>
$_[0]
<<
END
}

sub dltext {
    return <<END;
:$_[0]:$_[1]
END
}

sub ultext {
    return <<END;
-$_[0]
-$_[1]
-$_[2]
END
}

sub ultext2 {
    return <<END;
-$_[0]
--$_[1]
---$_[2]
END
}

sub oltext {
    return <<END;
+$_[0]
+$_[1]
+$_[2]
END
}

sub pretext {
    return <<END;
>|
$_[0]
|<
END
}

sub superpretext {
    return <<END;
>||
$_[0]
||<
END
}

sub tabletext {
    return <<END;
|*$_[0]|*$_[1]|
|$_[2]|$_[3]|
END
}

sub footnotetext {
    return <<END;
$_[0](($_[1]))$_[2] 
END
}

__END__

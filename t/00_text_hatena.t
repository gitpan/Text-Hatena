use strict;
use Test::More tests => 22;
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
isa_ok ($p, 'Text::Hatena');
my ($text,$html,$html2,@a);

# h3
$text = <<END;
*title
body
END

$html2 = <<END;
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> title</h3>
	<p>body</p>
</div>
END

$p->parse($text);
$html = $p->html;
chomp $html2;

is ($html, $html2);

# h3time
my $time = 1234567890;
$text = <<END;
*$time*record time
remember time.
END

$p->parse($text);
$html = $p->html;
my $m = sprintf('%02d', (localtime($time))[1]);
my $h = sprintf('%02d', (localtime($time))[2]);

$html2 = <<END;
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#1234567890" name="1234567890"><span class="sanchor">sa</span></a> record time</h3> <span class="timestamp">$h:$m</span>
	<p>remember time.</p>
</div>
END
chomp $html2;
is ($html, $html2);

# h3cat
$text = <<END;
*hobby*[hobby]my hobby
I like this.
END

$p->parse($text);
$html = $p->html;

$html2 = <<END;
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#hobby" name="hobby"><span class="sanchor">sa</span></a> [<a href="http://d.hatena.ne.jp/jkondo/?word=hobby" class="sectioncategory">hobby</a>]my hobby</h3>
	<p>I like this.</p>
</div>
END
chomp $html2;

is ($html, $html2);

# h4
$text = <<END;
**h4title

h4body
END

$p->parse($text);
$html = $p->html;
$html2 = <<END;
<div class="section">
	<h4>h4title</h4>
	
	<p>h4body</p>
</div>
END
chomp $html2;
is ($html, $html2);

#h5
$text = <<END;
***h5title

h5body
END

$p->parse($text);
$html = $p->html;

$html2 = <<END;
<div class="section">
	<h5>h5title</h5>
	
	<p>h5body</p>
</div>
END
chomp $html2;
is ($html, $html2);

# blockquote
$text = <<END;
>>
quoted
<<
END

$p->parse($text);
$html = $p->html;
$html2 = <<END;
<div class="section">
	<blockquote>
		<p>quoted</p>
	</blockquote>
</div>
END
chomp $html2;
is ($html, $html2);

# dl
$text = <<END;
:cinnamon:dog
END

$p->parse($text);
$html = $p->html;
$html2 = <<END;
<div class="section">
	<dl>
		<dt>cinnamon</dt>
		<dd>dog</dd>
	</dl>
</div>
END
chomp $html2;
is ($html, $html2);

# ul
$text = <<END;
-komono
-kyoto
-shibuya
END

$p->parse($text);
$html = $p->html;

$html2 = <<END;
<div class="section">
	<ul>
		<li>komono</li>
		<li>kyoto</li>
		<li>shibuya</li>
	</ul>
</div>
END
chomp $html2;
is ($html, $html2);

# ul2
$text = <<END;
-komono
--kyoto
---shibuya
--hachiyama
END

$p->parse($text);
$html = $p->html;

$html2 = <<END;
<div class="section">
	<ul>
		<li>komono
		<ul>
			<li>kyoto
			<ul>
				<li>shibuya</li>
			</ul>
			</li>
			<li>hachiyama</li>
		</ul>
		</li>
	</ul>
</div>
END
chomp $html2;
is ($html, $html2);

# ol
$text = <<END;
+komono
+kyoto
+shibuya
END
$p->parse($text);
$html = $p->html;
$html2 = <<END;
<div class="section">
	<ol>
		<li>komono</li>
		<li>kyoto</li>
		<li>shibuya</li>
	</ol>
</div>
END
chomp $html2;
is ($html, $html2);

# pre
$text = <<'END';
>|
#!/usr/bin/perl

my $url = 'http://d.hatena.ne.jp/';
|<
END

$p->parse($text);
$html = $p->html;

$html2 = <<'END';
<div class="section">
	<pre>
#!/usr/bin/perl

my $url = '<a href="http://d.hatena.ne.jp/';">http://d.hatena.ne.jp/';</a>
</pre>
</div>
END
chomp $html2;
is ($html, $html2);

# superpre
$text = <<END;
>||
html starts with <html>.
||<
END

$p->parse($text);
$html = $p->html;
$html2 = <<END;
<div class="section">
	<pre class="hatena-super-pre">
html starts with &lt;html&gt;.
</pre>
</div>
END
chomp $html2;

is ($html, $html2);

# superpre(vimcolor)
$text = <<'END';
>|perl|
#!/usr/bin/perl -w

my $s = "Hello, World!";
print $s; # prints Hello, World!
||<
END

$p->parse($text);
$html = $p->html;
$html2 = <<'END';
<div class="section">
	<pre class="hatena-super-pre">
<span class="synPreProc">#!/usr/bin/perl -w</span>

<span class="synStatement">my</span> <span class="synIdentifier">$s</span> = <span class="synConstant">&quot;Hello, World!&quot;</span>;
<span class="synStatement">print</span> <span class="synIdentifier">$s</span>; <span class="synComment"># prints Hello, World!</span>
</pre>
</div>
END
chomp $html2;
is ($html, $html2);

# superpre(vimcolor auto detect)
$text = <<'END';
>|?|
#!/usr/bin/perl -w

my $s = "Hello, World!";
print $s; # prints Hello, World!
||<
END

$p->parse($text);
$html = $p->html;
is ($html, $html2);

# table
$text = <<END;
|*Lang|*Module|
|Perl|Text::Hatena|
END

$p->parse($text);
$html = $p->html;
$html2 = <<END;
<div class="section">
	<table>
		<tr>
			<th>Lang</th>
			<th>Module</th>
		</tr>
		<tr>
			<td>Perl</td>
			<td>Text::Hatena</td>
		</tr>
	</table>
</div>
END
chomp $html2;

is ($html, $html2);


# tagline

$text = <<END;
><div>no paragraph line</div><
paragraph line
END

$html2 = <<END;
<div class="section">
	<div>no paragraph line</div>
	<p>paragraph line</p>
</div>
END

$p->parse($text);
$html = $p->html;
chomp $html2;
is ($html, $html2);

# tag
$text = <<END;
><blockquote>
no paragraph
lines
</blockquote><
paragraph
lines
END

$html2 = <<END;
<div class="section">
	<blockquote>
		no paragraph
		lines
	</blockquote>
	<p>paragraph</p>
	<p>lines</p>
</div>
END

$p->parse($text);
$html = $p->html;
chomp $html2;
is ($html, $html2);

$text =<<END;
Here is the way to make link.
>||
http://www.hatena.ne.jp/
id:jkondo
||<
bye.
END

$html2 =<<END;
<div class="section">
	<p>Here is the way to make link.</p>
	<pre class="hatena-super-pre">
http://www.hatena.ne.jp/
id:jkondo
</pre>
	<p>bye.</p>
</div>
END

$p->parse($text);
$html = $p->html;
chomp $html2;
is ($html, $html2);

# plain h3
$p = Text::Hatena->new(
    ilevel => 0,
    invalidnode => [qw(h3anchor)],
);

$text = <<END;
*h3title

h3body
END

$p->parse($text);
$html = $p->html;
$html2 = <<END;
<div class="section">
	<h3>h3title</h3>
	
	<p>h3body</p>
</div>
END
chomp $html2;
is ($html, $html2);

# plain section
$p = Text::Hatena->new(
    ilevel => 0,
    invalidnode => [qw(section)],
);
$text = <<END;
This is plain paragraph without any section nodes.
Is it right?
END

$p->parse($text);
$html = $p->html;
$html2 = <<END;
	<p>This is plain paragraph without any section nodes.</p>
	<p>Is it right?</p>
END
chomp $html2;
is ($html, $html2);

# footnote
# $text = <<END;
# GNU((GNU Is Not Unix)) is not unix.
# END

# $p->parse($text);
# $html = $p->html;

# $html2 = <<END;
# <div class="section">
# 	<p>GNU<span class="footnote"><a href="http://d.hatena.ne.jp/jkondo/20050906#f1" title="GNU Is Not Unix" name="fn1">*1</a></span> is not unix.</p>
# </div>
# <div class="footnote">
# 	<p class="footnote"><a href="http://d.hatena.ne.jp/jkondo/20050906#fn1" name="f1">*1</a>: GNU Is Not Unix</p>
# </div>
# END

# ok ($html eq $html2);

__END__

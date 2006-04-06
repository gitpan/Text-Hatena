use strict;
use Test::More tests => 11;

BEGIN { use_ok('Text::Hatena') };
BEGIN { use_ok('Text::Hatena::AutoLink') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink->new;

$text = 'Here is my album. f:id:sample';
$html = $t->parse($text);
$html2 = 'Here is my album. <a href="http://f.hatena.ne.jp/sample/">f:id:sample</a>';
is ($html, $html2);

$text = 'Hatena news. [google:news:はてな]';
$html = $t->parse($text);
$html2 = 'Hatena news. <a href="http://news.google.com/news?q=%e3%81%af%e3%81%a6%e3%81%aa&ie=utf-8&oe=utf-8">google:news:はてな</a>';
is ($html, $html2);

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

$text = <<END;
*Hi
This is my blog.
http://d.hatena.ne.jp/jkondo/
END

$html2 = <<END;
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> Hi</h3>
	<p>This is my blog.</p>
	<p><a href="http://d.hatena.ne.jp/jkondo/">http://d.hatena.ne.jp/jkondo/</a></p>
</div>
END

$p->parse($text);
$html = $p->html;
chomp $html2;

is ($html, $html2);

$text = <<END;
*Hi
This is our site. [http://www.hatena.ne.jp/:detail] Please visit.
><blockquote>
[http://www.hatena.ne.jp/:detail]
</blockquote><
END

$html2 = <<END;
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> Hi</h3>
	<p>This is our site. </p><div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a></p><p class="hatena-http-detail-title">はてな</p></div><p> Please visit.</p>
	<blockquote>
		<div class="hatena-http-detail"><p class="hatena-http-detail-url"><a href="http://www.hatena.ne.jp/">http://www.hatena.ne.jp/</a></p><p class="hatena-http-detail-title">はてな</p></div>
	</blockquote>
</div>
END

$p->parse($text);
$html = $p->html;
chomp $html2;

is ($html, $html2);


$text = <<END;
*Introducing my book.
Here is my book.
[asin:4798110523:image]
END
$html2 = <<END;
<div class="section">
	<h3><a href="http://d.hatena.ne.jp/jkondo/20050906#p1" name="p1"><span class="sanchor">sa</span></a> Introducing my book.</h3>
	<p>Here is my book.</p>
	<p><a href="http://d.hatena.ne.jp/asin/4798110523"><img src="http://images-jp.amazon.com/images/P/4798110523.09.MZZZZZZZ.jpg" alt="「へんな会社」のつくり方" title="「へんな会社」のつくり方" class="asin"></a></p>
</div>
END

$p->parse($text);
$html = $p->html;
chomp $html2;
is ($html, $html2);

$text = <<END;
Hello, []id:jkondo[].
END

$html2 = <<END;
<div class="section">
	<p>Hello, id:jkondo.</p>
</div>
END

$p->parse($text);
$html = $p->html;
chomp $html2;
is ($html, $html2);


$t = Text::Hatena::AutoLink->new(
    a_target => '_blank',
    scheme_option => {
        id => {
            a_target => '',
        },
    },
);

$text = 'http://www.hatena.ne.jp/ &gt; id:jkondo';
$html = $t->parse($text);
$html2 = '<a href="http://www.hatena.ne.jp/" target="_blank">http://www.hatena.ne.jp/</a> &gt; <a href="/jkondo/">id:jkondo</a>';
is ($html, $html2);


$p = Text::Hatena->new(
    baseuri => $base,
    permalink => $perma,
    ilevel => 0,
    invalidnode => [],
    sectionanchor => $sa,
    autolink_option => {
        a_target => '_top',
        scheme_option => {
            id => {
                a_target => '_blank',
            },
        },
    },
);

$text = 'http://www.hatena.ne.jp/ &gt; id:jkondo';
$p->parse($text);
$html = $p->html;
$html2 = <<END;
<div class="section">
	<p><a href="http://www.hatena.ne.jp/" target="_top">http://www.hatena.ne.jp/</a> &gt; <a href="/jkondo/" target="_blank">id:jkondo</a></p>
</div>
END
chomp $html2;
is ($html, $html2);


$t = Text::Hatena::AutoLink->new(
    scheme_option => {
        http => {
            title_handler => sub {
                my ($title, $charset) = @_;
                return $title.$charset;
            },
        },
    },
);

$text = '[http://www.yahoo.com/:title]';
$html = $t->parse($text);
$html2 = '<a href="http://www.yahoo.com/">Yahoo!utf-8</a>';
is ($html, $html2);

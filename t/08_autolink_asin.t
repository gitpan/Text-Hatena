use strict;
use Test::More tests => 5;

BEGIN { use_ok('Text::Hatena::AutoLink::ASIN') };

my ($text, $html, $html2);

my $t = Text::Hatena::AutoLink::ASIN->new(
    a_target => '_blank',
);
my $pat = $t->pattern;

$text = 'Here is my book. ISBN:4798110523';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">ISBN:4798110523</a>';
ok ($html eq $html2);

$text = 'Here is my book. ISBN:4798110523:image';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank"><img src="http://images-jp.amazon.com/images/P/4798110523.09.MZZZZZZZ.jpg" alt="「へんな会社」のつくり方" title="「へんな会社」のつくり方" class="asin"></a>';
ok ($html eq $html2);

$text = 'Here is my book. ISBN:4798110523:title';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">「へんな会社」のつくり方</a>';
ok ($html eq $html2);

$text = 'Here is my book. [ISBN:4798110523:title=How to make a strange company.]';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = 'Here is my book. <a href="http://d.hatena.ne.jp/asin/4798110523" target="_blank">How to make a strange company.</a>';
ok ($html eq $html2);

__END__
$text = 'Here is my book. ISBN:4798110523:detail';
$html = $text;
$html =~ s/($pat)/$t->parse($1);/ge;
$html2 = << 'END';
Here is my book. <div class="hatena-asin-detail">
  <a href="http://d.hatena.ne.jp/asin/4798110523"><img src="http://images-jp.amazon.com/images/P/4798110523.09.THUMBZZZ.jpg" class="hatena-asin-detail-image" alt="「へんな会社」のつくり方" title="「へんな会社」のつくり方"></a>
  <div class="hatena-asin-detail-info">
  <p class="hatena-asin-detail-title"><a href="http://d.hatena.ne.jp/asin/4798110523">「へんな会社」のつくり方</a></p>
  <ul>

    <li><span class="hatena-asin-detail-label">作者:</span> <a href="http://d.hatena.ne.jp/keyword/%e8%bf%91%e8%97%a4%20%e6%b7%b3%e4%b9%9f" class="keyword">近藤 淳也</a> </li>
    <li><span class="hatena-asin-detail-label">出版社/メーカー:</span> <a href="http://d.hatena.ne.jp/keyword/%e7%bf%94%e6%b3%b3%e7%a4%be" class="keyword">翔泳社</a></li>
    <li><span class="hatena-asin-detail-label">発売日:</span> 2006/02/13</li>
    <li><span class="hatena-asin-detail-label">メディア:</span> 単行本</li>
  </ul>
</div>
<div class="hatena-asin-detail-foot"></div>
</div>
END

chomp $html2;
ok ($html eq $html2);

warn $html;
warn $html2;

package Text::Hatena;
use strict;
use Text::Hatena::Context;
use Text::Hatena::BodyNode;
#use Text::Hatena::FootnoteNode;
use Text::Hatena::HTMLFilter;

our $VERSION = '0.08';

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        html => '',
        baseuri => $args{baseuri} || '',
        permalink => $args{permalink} || '',
        ilevel => $args{ilevel} || 0, # level of default indent
        invalidnode => $args{invalidnode} || [],
        sectionanchor => $args{sectionanchor} || 'o-',
	texthandler => $args{texthandler} || sub {
	    my ($text, $c, $hp) = @_;
            return $text if $hp->in_anchor;
	    my $p = $c->permalink;
            my $al;
            unless ($al = $c->autolink) {
                # cache instance
                use Text::Hatena::AutoLink;
                my $a = Text::Hatena::AutoLink->new(%{$args{autolink_option}});
                $c->autolink($a);
                $al = $a;
            }
            $text = $al->parse($text, {
                in_paragraph => $hp->in_paragraph,
            });
# 	    $text =~ s!
# 		\(\((.+?)\)\)
# 	    !
#                 my ($note,$pre,$post) = ($1,$`,$');
#                 if ($pre =~ /\)$/ && $post =~ /^\(/) {
#                     "(($note))";
#                 } else {
#                     my $notes = $c->footnotes($note);
#                     my $num = $#$notes + 1;
#                     $note =~ s/<.*?>//g;
#                     $note =~ s/\&/\&amp\;/g;
#                     qq|<span class="footnote"><a href="$p#f$num" title="$note" name="fn$num">*$num</a></span>|;
#                 }
# 	    !egox;
	    return $text;
	},
    };
    bless $self, $class;
}

sub parse {
    my $self = shift;
    my $text = shift or return;
    $self->{context} = Text::Hatena::Context->new(
        text => $text,
        baseuri => $self->{baseuri},
        permalink => $self->{permalink},
        invalidnode => $self->{invalidnode},
        sectionanchor => $self->{sectionanchor},
	texthandler => $self->{texthandler},
    );
    my $c = $self->{context};
    my $node = Text::Hatena::BodyNode->new(
        context => $c,
        ilevel => $self->{ilevel},
    );
    $node->parse;
    my $parser = Text::Hatena::HTMLFilter->new(
	context => $c,
    );
    $parser->parse($c->html);
    $self->{html} = $parser->html;

    if (@{$c->footnotes}) {
        my $node = Text::Hatena::FootnoteNode->new(
            context => $c,
            ilevel => $self->{ilevel},
        );
        $node->parse;
	$self->{html} .= "\n";
	$self->{html} .= $node->html;
    }
}

sub html { $_[0]->{html}; }


1;
__END__

=head1 NAME

Text::Hatena - Perl extension for formatting text with Hatena Style.

=head1 SYNOPSIS

  use Text::Hatena;

  my $parser = Text::Hatena->new(
    permalink => 'http://www.example.com/entry/123',
  );
  $parser->parse($text);
  my $html = $parser->html;

=head1 DESCRIPTION

Text::Hatena parses text with Hatena Style and generates html string.
Hatena Style is a set of text syntax which is originally used in 
Hatena Diary (http://d.hatena.ne.jp/).

You can get html string from simple text with syntax like Wiki.

=head1 METHODS

Here are common methods of Text::Hatena.

=over 4

=item new

  $parser = Text::Hatena->new;
  $parser = Text::Hatena->new(
    permalink => 'http://www.example.com/entry/123',
    ilevel => 1,
    invalidnode => [qw(h4 h5)],
    sectionanchor => '@',
    autolink_option => {
      a_target => '_blank',
      scheme_option => {
        id => {
          a_target => '',
        },
      ),
    },
  );

creates an instance of Text::Hatena.

C<permalink> is the uri of your document. It is used in H3 section anchor.

C<ilevel> is the base indent level.

C<invalidnode> is an array reference of invalid nodes. The node in the array will be skipped.

C<sectionanchor> is the string of H3 section anchor.

C<autolink_option> are the options for L<Text::Hatena::AutoLink>.

=item parse

  $parser->parse($text);

parses text and generates html.

=item html

  $html = $parser->html;

returns html string generated.

=back

=head1 Text::Hatena Syntax

Text::Hatena supports some simple markup language, which is similar to the Wiki format.

=over 4

=item Paragraphs

Basically each line becomes a paragraph. If you want to force a newline in a paragraph, you can use a line break markup of HTML.

Text::Hatena treats a blank line as the end of a block. A blank line after a paragraph does not affect the output. Two blank lines are translated into a line break, three blank lines are translated into two line breaks and so on.

To stop generating paragraphs automatically, start a line with >< (greater-than sign and less-than sign). The first > (greater-than sign) will be omitted. If you end a line with ><, it will stop. The last < (less-than sign) will be omitted.

  ><div class="foo">A div block without paragraph.</div><

  ><form action="foo.cgi" method="put">
  To insert a from, write as you see here.
  <input type="text" name="a" />
  <input type="submit" />
  </form><

=item Headlines

To create a section headline, start a line with a star followed by an anchor, a star, some tags of categories and a section title. An anchor and tags are optional. If you omit an anchor, Text::Hatena generates it automatically.

  *A line with a star becomes section headline
  *sa*You can specify a string for anchor name
  *[foo][bar]You can specify some tags of categories
  *sa*[foo][bar]You can mix them

More stars mean deeper levels of headlines. You can use up to three stars for headlines.

  **Start a line with two stars to create a 4th level headline
  ***Start a line with three stars to create a 5th level headline.

=item Lists and Tables

Text::Hatena supports ordered and unordered lists. Start every line with a minus (-) for unordered lists or a plus (+) for ordered ones. More marks mean deeper levels. You can show the end of the lists by a blank line.

  -Start a line with minuses to create an unordered list item.

  +Start a line with pluses to create an ordered list item.
  ++They can be nested.

Text::Hatena supports definition lists. Start every line with a colon followed by a term, a colon, and a description.

  :term:description

You can create tables by using a simple syntax. Table rows have to start and end with a vertical bar (|). Separete every cell with a vertical bar (|). To turn cells into headers, begin them with a star.

  |*header1|*header2|
  |colum1|colum2|

=item Blockquotes

To make a blockquote, enclose line(s) with >> (double greater-than sign) and << (double less-than sign). Marks should be placed in separate lines; don't start quoting line(s) with >> or end them with <<. Blockquotes may be nested.

  >>
  To make a blockquote, enclose line(s) with >> (double greater-than sign)
  and << (double less-than sign).
  <<

=item Preformatted texts

To make a preformatted text, enclose line(s) with >| (a greater-than sign followed by a vertical bar) and |< (a vertical var followed by a less-than sign).

Every >| should be placed in separate lines; don't start preformatted line(s) with >|. But some preformatted texts may be closed by |< after the last lines without separating lines.

  >|
  To make a preformatted text, enclose line(s) with >|
  (a greater-than sign followed by a vertical bar) and |<
  (a vertical var followed by a less-than sign).
  |<

This also works well.

  >|
  To make a preformatted text, enclose line(s) with >|
  (a greater-than sign followed by a vertical bar) and |<
  (a vertical var followed by a less-than sign).|<

To encode special characters into HTML entities, use >|| and ||< for >| and |<. The characters to be replaced are less-than signs (<), greater-than signs (>), double quotes ("), and ampersands (&).

  >||
  To encode special characters into HTML entities,
  use >|| and ||< for >| and |<.
  ||<

=back

=head1 SEE ALSO

L<Text::Hatena::AutoLink>
http://d.hatena.ne.jp/ (Japanese)

=head1 AUTHOR

Junya Kondo, E<lt>jkondo@hatena.ne.jpE<gt>
id:tociyuki, E<lt>http://d.hatena.ne.jp/tociyuki/E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Junya Kondo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

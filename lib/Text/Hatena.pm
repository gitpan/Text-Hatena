package Text::Hatena;
use strict;
use Text::Hatena::Context;
use Text::Hatena::BodyNode;

our $VERSION = '0.03';

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        baseuri => $args{baseuri} || '',
        permalink => $args{permalink} || '',
        ilevel => $args{ilevel} || 0, # level of default indent
        invalidnode => $args{invalidnode} || [],
        sectionanchor => $args{sectionanchor} || 'o-',
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
    );
    my $node = Text::Hatena::BodyNode->new(
        context => $self->{context},
        ilevel => $self->{ilevel},
    );
    $node->parse;
}

sub html {
    my $self = shift;
    $self->{context}->html;
}

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
  );

creates an instance of Text::Hatena.

C<permalink> is the uri of your document. It is used in H3 section anchor.

C<ilevel> is the base indent level.

C<invalidnode> is an array reference of invalid nodes. The node in the array will be skipped.

C<sectionanchor> is the string of H3 section anchor.

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

You can add footnotes by using double parentheses.

Text::Hatena treats a blank line as the end of a block. A blank line after a paragraph does not affect the output. Two blank lines are translated into a line break, three blank lines are translated into two line breaks and so on.

=item Headlines

To create a section headline, start a line with a star followed by an anchor, a star, some tags of categories and a section title. An anchor and tags are optional. If you omit an anchor, Text::Hatena generates it automatically.

More stars mean deeper levels of headlines. You can use up to three stars for headlines.

=item Lists and Tables

Text::Hatena supports ordered and unordered lists. Start every line with a minus (-) for unordered lists or a plus (+) for ordered ones. More marks mean deeper levels. You can show the end of the lists by a blank line.

Text::Hatena supports definition lists. Start every line with a colon followed by a term, a colon, and a description.

You can create tables by using a simple syntax. Table rows have to start and end with a vertical bar (|). Separete every cell with a vertical bar (|). To turn cells into headers, begin them with a star.

=item Blockquotes

To make a blockquote, enclose line(s) with >> (double greater-than sign) and << (double less-than sign). Marks should be placed in separate lines; don't start quoting line(s) with >> or end them with <<. Blockquotes may be nested.

=item Preformatted texts

To make a preformatted text, enclose line(s) with >| (a greater-than sign followed by a vertical bar) and |< (a vertical var followed by a less-than sign).

Every >| should be placed in separate lines; don't start preformatted line(s) with >|. But some preformatted texts may be closed by |< after the last lines without separating lines.

To encode special characters into HTML entities, use >|| and ||< for >| and |<. The characters to be replaced are less-than signs (<), greater-than signs (>), double quotes ("), and ampersands (&).

=back

=head1 SEE ALSO

http://d.hatena.ne.jp/ (Japanese)

=head1 AUTHOR

Junya Kondo, E<lt>jkondo@hatena.ne.jpE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Junya Kondo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

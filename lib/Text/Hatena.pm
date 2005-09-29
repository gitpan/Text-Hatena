package Text::Hatena;
use strict;
use Text::Hatena::Context;
use Text::Hatena::BodyNode;

our $VERSION = '0.01';

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

Text::Hatena - Perl extension for formating text with Hatena Style.

=head1 SYNOPSIS

  use Text::Hatena;

  my $parser = Text::Hatena->new(
    permalink => 'http://www.example.com/entry/123',
  );
  $parser->parse($text);
  my $html = $parser->html;

=head1 DESCRIPTION

Text::Hatena parses text and generate html string with Hatena Style.
Hatena Style is a set of text syntax which is originally used in 
Hatena Diary (http://d.hatena.ne.jp/).

You can get html string from simple text syntax like Wiki.

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

creates a instance of Text::Hatena.

C<permalink> is the uri of your document. It is used in H3 section anchor.

C<ilevel> is the base level of indent.

C<invalidnode> is array reference of invalid nodes. The node which is in the array will be skipped.

C<sectionanchor> is the string of H3 section anchor.

=item parse

  $parser->parse($text);

parses text and generate html.

=item html

  $html = $parser->html;

returns html string which has generated.

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

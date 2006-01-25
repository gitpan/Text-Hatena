package Text::Hatena::AutoLink;
use strict;

our $VERSION = '0.01';
our $SCHEMES = {
    mailto => 'Text::Hatena::AutoLink::Mailto',
    asin => 'Text::Hatena::AutoLink::ASIN',
    http => 'Text::Hatena::AutoLink::HTTP',
    isbn => 'Text::Hatena::AutoLink::ASIN',
    ftp => 'Text::Hatena::AutoLink::FTP',
    tex => 'Text::Hatena::AutoLink::Tex',
    id => 'Text::Hatena::AutoLink::HatenaID',
    d => 'Text::Hatena::AutoLink::HatenaDiary',
    f => 'Text::Hatena::AutoLink::HatenaFotolife',
    g => 'Text::Hatena::AutoLink::HatenaGroup',
    ']' => 'Text::Hatena::AutoLink::Unbracket',
};

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {};
    $self->{a_target} = $args{a_target};
    $self->{scheme_option} = $args{scheme_option};
    $self->{invalid_scheme} = $args{invalid_scheme};
    bless $self, $class;
    $self->init;
    return $self;
}

sub init {
    my $self = shift;
    my %invalid;
    for (@{$self->{invalid_scheme}}) { $invalid{$_}++; }
    $self->{parser} = {};
    for my $scheme (keys %$SCHEMES) {
        next if $invalid{$scheme};
        my $p = $SCHEMES->{$scheme};
        eval "use $p";
        die $@ if $@;
        my $option = $self->{scheme_option}->{$scheme} || {};
        unless (defined $option->{a_target}) {
            $option->{a_target} = $self->{a_target};
        }
        $self->{parser}->{$scheme} = $p->new(%$option);
        $self->{pattern} .= '|' if $self->{pattern};
        $self->{pattern} .= $self->{parser}->{$scheme}->pattern;
    }
    $self->{pattern} = qr/$self->{pattern}/;
}

sub add_scheme {
    my $self = shift;
    my %args = @_;
    $SCHEMES->{%args};
    $self->init;
}

sub parse {
    my $self = shift;
    my $text = shift;
    my $opt = shift;
    my @schemes = sort {$b eq ']' ? 1 : length($b) <=> length($a)} keys %{$self->{parser}};
    $text =~ s!
               ($self->{pattern})
        !
               my $text = $1;
               my $parser;
               for my $sc (@schemes) {
                    if ($text =~ /^\[?\Q$sc\E/i) {
                       $parser = $self->{parser}->{$sc};
                       last;
                   }
               }
               $parser->parse($text, $opt);
        !gex;
    return $text;
}

1;

__END__

=head1 NAME

Text::AutoLink - Perl extension for making hyperlinks in text automatically.

=head1 SYNOPSIS

  use Text::Hatena::AutoLink;

  my $parser = Text::Hatena::AutoLink->new;
  my $html = $parser->parse($text);

=head1 DESCRIPTION

Text::Hatena::AutoLink makes many hyperlinks in text automatically. Urls or many original syntaxes will be changed into hyperlinks. Many syntaxes are originally used in Hatena Diary (http://d.hatena.ne.jp/).

=head1 METHODS

Here are common methods of Text::Hatena::AutoLink.

=over 4

=item new

  $parser = Text::Hatena::AutoLink->new;
  $parser = Text::Hatena::AutoLink->new(
    a_target => '_blank',
    invalid_scheme => ['d', 'tex'],
    scheme_option => {
      id => {
        a_target => '',
      },
    ),
  );

creates an instance of Text::Hatena::AutoLink.
It will work without any options.

C<a_target> is the target name used in anchors. It can be overwritten by scheme options.

C<invalidnode> is an array reference of invalid schemes. The scheme in the array will be skipped.

C<scheme_option> are options for many schemes. You can use some common options and scheme characteristic options.

=item parse

  my $html = $parser->parse($text);

parses text and make links. It returns parsed html.

=back

=head1 Text::Hatena::AutoLink Syntax

Text::Hatena::AutoLink supports some simple markup language.

  http://www.hatena.ne.jp/
  mailto:someone@example.com
  asin:4798110523
  [tex:x^2+y^2=z^2]
  d:id:jkondo

These lines all become hyperlinks.

=head1 SEE ALSO

L<Text::Hatena>

=head1 AUTHOR

Junya Kondo, E<lt>jkondo@hatena.ne.jpE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Junya Kondo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

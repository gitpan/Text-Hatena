package Text::Hatena::AutoLink;
use strict;

our $VERSION = '0.06';
our $SCHEMES = {
    question => 'Text::Hatena::AutoLink::HatenaQuestion',
    amazon => 'Text::Hatena::AutoLink::HatenaQuestion',
    google => 'Text::Hatena::AutoLink::Google',
    mailto => 'Text::Hatena::AutoLink::Mailto',
    search => 'Text::Hatena::AutoLink::HatenaSearch',
    graph => 'Text::Hatena::AutoLink::HatenaGraph',
    https => 'Text::Hatena::AutoLink::HTTP',
    asin => 'Text::Hatena::AutoLink::ASIN',
    http => 'Text::Hatena::AutoLink::HTTP',
    idea => 'Text::Hatena::AutoLink::HatenaIdea',
    isbn => 'Text::Hatena::AutoLink::ASIN',
    ean => 'Text::Hatena::AutoLink::EAN',
    ftp => 'Text::Hatena::AutoLink::FTP',
    jan => 'Text::Hatena::AutoLink::EAN',
    map => 'Text::Hatena::AutoLink::HatenaMap',
    tex => 'Text::Hatena::AutoLink::Tex',
    id => 'Text::Hatena::AutoLink::HatenaID',
    a => 'Text::Hatena::AutoLink::HatenaAntenna',
    b => 'Text::Hatena::AutoLink::HatenaBookmark',
    d => 'Text::Hatena::AutoLink::HatenaDiary',
    f => 'Text::Hatena::AutoLink::HatenaFotolife',
    g => 'Text::Hatena::AutoLink::HatenaGroup',
    i => 'Text::Hatena::AutoLink::HatenaIdea',
    q => 'Text::Hatena::AutoLink::HatenaQuestion',
    r => 'Text::Hatena::AutoLink::HatenaRSS',
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
    my %known;
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
        next if $known{$p}++;
        $self->{pattern} .= '|' if $self->{pattern};
        $self->{pattern} .= $self->{parser}->{$scheme}->pattern;
    }
    $self->{pattern} = qr/$self->{pattern}/;
}

sub add_scheme {
    my $self = shift;
    my %args = @_;
    for (keys %args) {
        $SCHEMES->{$_} = $args{$_};
    }
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
                   if ($sc =~ /^\w+$/ && $text =~ /^\[?$sc:/i) {
                       $parser = $self->{parser}->{$sc};
                   } elsif ($text =~ /^\[?\Q$sc\E/i) {
                       $parser = $self->{parser}->{$sc};
                   }
                   last if $parser;
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
      http => {
        title_handler => sub {
          my ($title, $charset) = @_;
          return Jcode->new($title, $charset)->utf8;
        },
      },
    ),
  );

creates an instance of Text::Hatena::AutoLink.
It will work without any options.

C<a_target> is the target name used in anchors. It can be overwritten by scheme options.

C<invalid_scheme> is an array reference of invalid schemes. The scheme in the array will be skipped.

C<scheme_option> are options for many schemes. You can use some common options and scheme characteristic options.

=item parse

  my $html = $parser->parse($text);

parses text and make links. It returns parsed html.

=back

=head1 Text::Hatena::AutoLink Syntax

Text::Hatena::AutoLink supports some simple syntaxes.

  http://www.hatena.ne.jp/
  [http://www.hatena.ne.jp/:title=Hatena]
  [http://www.hatena.ne.jp/images/top/h1.gif:image]
  mailto:someone@example.com
  asin:4798110523
  [tex:x^2+y^2=z^2]
  d:id:jkondo

These lines all become into hyperlinks.

  []id:jkondo[]

You can avoid being hyperlinked with 2 pair brackets like the above line.

=head1 SEE ALSO

L<Text::Hatena>

=head1 AUTHOR

Junya Kondo, E<lt>jkondo@hatena.ne.jpE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Junya Kondo

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

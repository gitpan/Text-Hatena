package Text::Hatena::Context;
use strict;

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        text => $args{text},
        baseuri => $args{baseuri},
        permalink => $args{permalink},
        invalidnode => $args{invalidnode},
        sectionanchor => $args{sectionanchor},
        htmllines => [],
        html => '',
        footnotes => [],
        sectioncount => 0,
        syntaxrefs => [],
	nopragraph => 0,
    };
    bless $self,$class;
    $self->init;
    return $self;
}

sub init {
    my $self = shift;
    $self->{text} =~ s/\r//g;
    @{$self->{lines}} = split('\n', $self->{text});
    $self->{index} = -1;
}

sub hasnext {
    my $self = shift;
    defined ($self->{lines}->[$self->{index} + 1]);
}

sub nextline {
    my $self = shift;
    $self->{lines}->[$self->{index} + 1];
}

sub shiftline {
    my $self = shift;
    $self->{lines}->[++$self->{index}];
}

sub currentline {
    my $self = shift;
    $self->{lines}->[$self->{index}];
}

sub html {
    my $self = shift;
    join ("\n", @{$self->{htmllines}});
}

sub htmllines {
    my $self = shift;
    push @{$self->{htmllines}}, $_[0] if $_[0];
    $self->{htmllines};
}

sub lasthtmlline { $_[0]->{htmllines}->[-1]; }

sub footnotes {
    my $self = shift;
    push @{$self->{footnotes}}, $_[0] if $_[0];
    $self->{footnotes};
}

sub syntaxrefs {
    my $self = shift;
    $self->{syntaxrefs} = $_[0] if $_[0];
    $self->{syntaxrefs};
}

sub syntaxpattern {
    my $self = shift;
    $self->{syntaxpattern} = $_[0] if $_[0];
    $self->{syntaxpattern};
}

sub noparagraph {
    my $self = shift;
    $self->{noparagraph} = $_[0] if defined $_[0];
    $self->{noparagraph};
}

sub sectioncount { $_[0]->{sectioncount}; }
sub incrementsection { $_[0]->{sectioncount}++; }

sub baseuri { $_[0]->{baseuri}; }
sub permalink { $_[0]->{permalink}; }
sub invalidnode { $_[0]->{invalidnode}; }
sub sectionanchor { $_[0]->{sectionanchor}; }

1;

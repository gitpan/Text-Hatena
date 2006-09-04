use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Text::Hatena',
    VERSION_FROM      => 'lib/Text/Hatena.pm',
    PREREQ_PM         => {
	HTML::Parser => 3.26,
        Class::Data::Inheritable => 0.04,
        Net::Amazon => 0.34,
        Template => 2.14,
        LWP::UserAgent => 2.0,
        Text::VimColor => 0.11,
    },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Text/Hatena.pm',
       AUTHOR         => 'Junya Kondo <jkondo@hatena.ne.jp>') : ()),
);

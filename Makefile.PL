use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Text::Hatena',
    VERSION_FROM      => 'lib/Text/Hatena.pm',
    PREREQ_PM         => {
	HTML::Parser => 3.45,
    },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/Text/Hatena.pm',
       AUTHOR         => 'Junya Kondo <jkondo@hatena.ne.jp>') : ()),
);

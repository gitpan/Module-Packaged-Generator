
use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
  module_name   => 'Module::Packaged::Generator',
  license       => 'perl',
  dist_abstract => "build\ list\ of\ modules\ packaged\ by\ a\ linux\ distribution",
  dist_name     => "Module\-Packaged\-Generator",
  dist_author   => [
"Jerome\ Quelin",
  ],
  requires      => {
    "base" => '0',
    "relative" => '0',
    "Module::Pluggable" => '0',
    "MooseX::Has::Sugar" => '0',
    "Parse::CPAN::Packages" => '0',
    "Term::ProgressBar::Quiet" => '0',
    "English" => '0',
    "File::HomeDir" => '0',
    "Test::More" => '0',
    "perl" => '5.008',
    "List::Util" => '0',
    "File::Find" => '0',
    "Path::Class" => '0',
    "Moose" => '0',
    "DBI" => '0',
  },
  script_files => [ qw(bin/pkgcpan) ],
);

$build->create_build_script;

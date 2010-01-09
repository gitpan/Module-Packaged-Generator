
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
    "List::Util" => '0',
    "perl" => '5.008',
    "Test::More" => '0',
    "Module::Pluggable" => '0',
    "base" => '0',
    "Term::ProgressBar::Quiet" => '0',
    "English" => '0',
    "File::Find" => '0',
    "DBI" => '0',
  },
  script_files => [ qw(bin/pkgcpan) ],
);

$build->create_build_script;

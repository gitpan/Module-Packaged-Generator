
use strict;
use warnings;

use Module::Build 0.3601;

my %module_build_args = (
                       'dist_abstract' => 'build list of modules packaged by a linux distribution',
                       'dist_author' => [
                                          'Jerome Quelin'
                                        ],
                       'dist_name' => 'Module-Packaged-Generator',
                       'script_files' => [
                                           'bin/pkgcpan'
                                         ],
                       'module_name' => 'Module::Packaged::Generator',
                       'requires' => {
                                       'relative' => 0,
                                       'Module::Pluggable' => 0,
                                       'MooseX::Has::Sugar' => 0,
                                       'Parse::CPAN::Packages' => 0,
                                       'Term::ProgressBar::Quiet' => 0,
                                       'English' => 0,
                                       'File::HomeDir' => 0,
                                       'FindBin' => 0,
                                       'perl' => '5.008',
                                       'Test::More' => 0,
                                       'List::Util' => 0,
                                       'File::Find' => 0,
                                       'File::Temp' => 0,
                                       'Path::Class' => 0,
                                       'File::Spec::Functions' => 0,
                                       'Moose' => 0,
                                       'DBI' => 0
                                     },
                       'license' => 'perl'
                     );


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;

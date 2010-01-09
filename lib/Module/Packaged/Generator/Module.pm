# 
# This file is part of Module-Packaged-Generator
# 
# This software is copyright (c) 2010 by Jerome Quelin.
# 
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
# 
use 5.008;
use strict;
use warnings;

package Module::Packaged::Generator::Module;
our $VERSION = '1.100091';
# ABSTRACT: a class representing a perl module

use File::HomeDir qw{ my_home };
use Moose;
use MooseX::Has::Sugar;
use Parse::CPAN::Packages;
use Path::Class;


# -- attributes

has name    => ( ro, isa=>'Str', required          );
has version => ( ro, isa=>'Maybe[Str]'             );
has dist    => ( ro, isa=>'Maybe[Str]', lazy_build );
has pkgname => ( ro, isa=>'Str', required          );


# -- initializers & builders

{
    my $pkgfile = file( my_home(), '.cpanplus', '02packages.details.txt.gz' );
    if ( -f $pkgfile ) {
        my $cpan = Parse::CPAN::Packages->new("$pkgfile");
        *_build_dist = sub {
            my $self = shift;
            my $pkg = $cpan->package( $self->name );
            return unless $pkg;
            return $pkg->distribution->dist;
        }
    } else {
        warn "couldn't find a cpanplus index in $pkgfile\n";
        *_build_dist = sub { return };
    }
}

1;


=pod

=head1 NAME

Module::Packaged::Generator::Module - a class representing a perl module

=head1 VERSION

version 1.100091

=head1 DESCRIPTION

This module represent a Perl module with various attributes. It
should be used by the distribution drivers fetching the list of
available modules.

=head1 AUTHOR

  Jerome Quelin

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
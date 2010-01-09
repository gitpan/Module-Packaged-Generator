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

package Module::Packaged::Generator;
our $VERSION = '1.100090';
# ABSTRACT: build list of modules packaged by a linux distribution

use DBI;
use List::Util qw{ first };
use Module::Pluggable
    require     => 1,
    sub_name    => 'dists',
    search_path => __PACKAGE__.'::Distribution';
use Term::ProgressBar::Quiet;


# -- public methods


sub create_db {
    my $self = shift;

    # try to find a module than can provide the list of modules
    my $driver = first { $_->match } $self->dists;
    if ( not defined $driver ) {
        warn "no driver found for this machine distribution.\n\n",
            "list of existing distribution drivers:\n",
            map { ( my $d = $_ ) =~ s/^.*:://; "\t$d\n" } $self->dists;
        die "\n";
    }

    print "found a distribution driver: $driver\n";
    ( my $dist = $driver ) =~ s/^.*:://;
    my @modules = $driver->list;

    # save modules in a db
    my $file = "cpan_$dist.db";
    unlink($file) if -f $file;
    my $dbh = DBI->connect("dbi:SQLite:dbname=$file", '', '');
    $dbh->do("
        CREATE TABLE module (
            module      TEXT NOT NULL,
            version     TEXT,
            dist        TEXT,
            pkgname     TEXT NOT NULL
        );
    ");
    my $sth = $dbh->prepare("INSERT INTO module (module, version, pkgname) VALUES (?,?,?);");
    my $prefix = "inserting modules in db";
    my $progress = Term::ProgressBar->new( {
        count     => scalar(@modules),
        bar_width => 50,
        remove    => 1,
        name      => $prefix,
    } );
    my $next_update = 0;
    foreach my $i ( 0 .. $#modules ) {
        my $m = $modules[$i];
        $sth->execute(@$m);
        $next_update = $progress->update($_)
            if $i >= $next_update;
    }
    $progress->update( scalar(@modules) );
    $sth->finish;
    print "${prefix}: done\n";
    print "creating indexes: modules ";
    $dbh->do("CREATE INDEX module__module  on module ( module  );");
    print "dists ";
    $dbh->do("CREATE INDEX module__dist    on module ( dist    );");
    print "packages ";
    $dbh->do("CREATE INDEX module__pkgname on module ( pkgname );");
    print "done\n";
    $dbh->disconnect;
}

1;


=pod

=head1 NAME

Module::Packaged::Generator - build list of modules packaged by a linux distribution

=head1 VERSION

version 1.100090

=head1 DESCRIPTION

This module will fetch modules available as native linux distribution
package, and wraps that in a sqlite database. This then allow people to
do analysis, draw CPANTS metrics from it or whatever.

Of course, running the utility shipped in this dist will only create the
database for the current distribution. But that's not our job to do
crazy manipulation with this data, we just provide the data :-)

=head1 METHODS

=head2 create_db();

Fetch the list of available modules, and creates a sqlite database with
this information.

=head1 SEE ALSO

You can find more information on this module at:

=over 4

=item * Search CPAN

L<http://search.cpan.org/dist/Module-Packaged-Generator>

=item * See open / report bugs

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Packaged-Generator>

=item * Git repository

L<http://github.com/jquelin/module-packaged-generator>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Module-Packaged-Generator>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Module-Packaged-Generator>

=back

=head1 AUTHOR

  Jerome Quelin

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
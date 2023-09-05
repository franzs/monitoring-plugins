#!/usr/bin/perl -w -I ..

#
# Wrapper for setting and getting value from NPTest cache
#

use strict;

use NPTest;

sub usage {
    print STDERR "Usage: $0 [get|set] parameter [value]\n";
    exit 64;
}

my $command = shift;
usage() if (!defined($command) || ($command ne 'get' && $command ne 'set'));

my $parameter = shift;
usage() if (!defined($parameter));

unless (defined($ENV{"NPTEST_CACHE"} && -f $ENV{"NPTEST_CACHE"})) {
    print STDERR "Environment variable NPTEST_CACHE must be set and point to NPTest cache file.\n";
    exit 1;
}

if ($command eq 'get') {
    my $value = NPTest::SearchCache($parameter);

    if (defined($value)) {
        print NPTest::SearchCache($parameter);
    } else {
        print STDERR "Unknown parameter $parameter\n";
	exit 1;
    }
} elsif ($command eq 'set') {
    my $value = shift;
    usage() if (!defined($value));

    NPTest::LoadCache();
    NPTest::SetCacheParameter($parameter, $value);
}

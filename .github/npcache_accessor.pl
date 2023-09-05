#!/usr/bin/perl -w -I . -I ..

#
# Wrapper for setting and getting value from NPTest cache
#
# Formatted with
# perltidy --maximum-line-length=160 --paren-tightness=2 --cuddled-else npcache_accessor.pl
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
        print $value;
    } else {
        print STDERR "Unknown parameter $parameter\n";
        exit 1;
    }
} elsif ($command eq 'set') {
    my $value = shift;
    usage() if (!defined($value));

    NPTest::LoadCache();
    NPTest::SetCacheParameter($parameter, $value);

    if (!defined(NPTest::SearchCache($parameter))) {
        print STDERR "$parameter = $value was not written to $ENV{'NPTEST_CACHE'}. Maybe the parameter is missing a NP_ prefix.\n";
        exit 1;
    }
}

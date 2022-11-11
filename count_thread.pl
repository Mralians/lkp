#! /usr/bin/env perl

# SCRIPT: count_thread.pl
# DESCRIPTION: -
# USAGE: -

use utf8;
use warnings;
use strict;

sub check_exists_command {

    my $check = `sh -c 'command -v $_[0]'`;
    return $check;
}

check_exists_command "lsb_release" or die "$0 requires lsb_release";


print "System release info:\n";
system "lsb_release -a 2>/dev/null";

my $total_procs = `ps -A | wc -l`;
print "\nTotal # of process alive = ", "$total_procs";

my $total_threads = `ps -LA | wc -l`;
print "Total # of threads alive = ", "$total_threads";

my $total_kthreads =  `ps aux | awk '{print \$11}' | grep '^\\[' | wc -l`;
print "Total # of kernel threads alive = ", $total_kthreads;

print "Total # of usermode thread alive = ", $total_threads - $total_kthreads;
print "\n";

exit 0

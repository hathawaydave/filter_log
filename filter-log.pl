#!/usr/bin/env perl
# libcrack@users.noreply.github.com
# Thu Jun  9 23:03:10 CEST 2016
#
# :~$ ssh root@pfsense "clog -f /var/log/filter.log" | pfsense-filter.pl

use strict;
use warnings;

$|=1;
my $regexp = '^(.+\d+:\d+:\d+) pfsense filterlog.+: (.*)';

# die "Usage: ssh admin\@pfsense 'clog -f /var/log/filter' | $0\n" if not $ARGV[1];

while (<STDIN>) {
    my $linea = $_;
    # print $linea; 
    chomp($linea);
    if ($linea =~ /$regexp/) {
        my $datetime = $1;
        my $csv = $2;
        my @x = split(/,/, $csv, -1);
        my $out = $datetime."\t".$x[3]."\t".$x[5]."\t".$x[6]."\t".$x[7];

        # assume IPV6 since it is most common
        my $ipver = $x[8];
        my $protocol = $x[12];
        my $srcaddr = $x[15];
        my $srcport = "";
        my $destaddr = $x[16];
        my $destport = "";

        # check IP version
        if ($ipver eq "6") {
            if($protocol eq "UDP" or $protocol eq "TCP") {
                $srcaddr = "[".$srcaddr."]";
                $srcport = ":".$x[17];
                $destaddr = "[".$destaddr."]";
                $destport = ":".$x[18];
            }
        } else {
            # print $linea."\n";
            $protocol = $x[16];
            $srcaddr = $x[18];
            $destaddr = $x[19];
            if($protocol eq "tcp" or $protocol eq "udp") {
                $srcport = ":".$x[20];
                $destport = ":".$x[21];
            }
        }
        printf("%s\tIPV%s\t%s\t%-40s\t%s\n", $out,$ipver,$protocol,$srcaddr.$srcport,$destaddr.$destport);
    }
}

exit 0;

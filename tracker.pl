#!/usr/bin/perl

use strict;
use warnings;

use JSON;

exit 0 unless (-e $ARGV[0]);

# enable 'slurp' mode
local $/;
open (my $fh, '<', $ARGV[0])
    or exit 0;
my $jdata = decode_json(<$fh>);
close $fh;

# check for categorie CDN
print $jdata->{domain}
    unless grep {$_ eq 'CDN'} @{$jdata->{categories}};
exit 0;

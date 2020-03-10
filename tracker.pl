#!/usr/bin/perl

=pod

=head1 tracker.pl
    
read json files from duckduckgo/tracker-radar

=head1 SYNOPSIS

tracker.pl [options] --file=<file>

Options:

--filter    set filter level (minimum, middle, maximum)

=head1 OPTIONS

=over 12

=item B<--filter>

B<(Optional)> Set filter level. Default value is set to maximum if option is omitted.

=item B<--file>

B<(Required)> Set json file from duckduckgo/tracker-radar project.

=back

=head1 SAMPLE

./tracker.pl --filter=minimum --file=test.json

./tracker.pl --file=test.json

=head1 DESCRIPTION

B<This program> will read and parse the given input file. Return domain if domains category hit filter level.

=cut

use strict;
use warnings;

use JSON;
use Getopt::Long;

my $file         = "";
my $filter_level = "maximum";
GetOptions(
    "file=s"    => \$file,
    "filter=s"  => \$filter_level,
) or exit 0;

exit 0 unless (-e $file);

my $filter;
# includes trackers, maleware, unknown risk
$filter->{minimum} = [
    'Action Pixels',
    'Ad Fraud',
    'Ad Motivated Tracking',
    'Advertising',
    'Analytics',
    'Audience Measurement',
    'Malware',
    'Obscure Ownership',
    'Session Replay',
    'Third-Party Analytics Marketing',
    'Unknown High Risk Behavior',
];
# includes social stuff
$filter->{middle} = [
    @{$filter->{minimum}},
    'Badge',
    'Embedded Content',
    'Federated Login',
    'Social Network',
    'Social-Comment',
    'Social-Share',
];
# includes all categories
$filter->{maximum} = [
    @{$filter->{middle}},
    'CDN',
    'Online Payment',
    'SSO',
];

# enable 'slurp' mode
local $/;
open (my $fh, '<', $file)
    or exit 0;
my $jdata = decode_json(<$fh>);
close $fh;

# check for categorie CDN
exit 0 if (scalar @{$jdata->{categories}} == 0);
foreach my $category (@{$jdata->{categories}})
{
    if (grep {$_ eq $category} @{$filter->{$filter_level}})
    {
        print $jdata->{domain};
        exit 0;
    }
}

exit 0;

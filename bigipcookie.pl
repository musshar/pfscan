#!/usr/bin/perl
use strict;
use warnings;

my ($ip,$port) = split('.',$ARGV[0]);
#Convert to IP to hex
my $ip_hex = sprintf("%x",$ip);
#Prepend extra 0 if hex value is only 7 char
$ip_hex = "0"."$ip_hex" if (length $ip_hex ==7);
#Decode hex to IP
my $d_ip = join ('.',map {hex $_} reverse ($ip_hex =~ m/../g));
#Decode hex to port
my $d_port = hex join("",reverse( sprintf("%x",$port) =~ m/../g) );

print "The persistence cookie decoded: $d_ip:$d_port";

#Usage:  ./f5_decode.pl 335653056.20480.0000

#!/usr/bin/perl
#$ {"name": "remember", "language": "perl", "description": "Helps you remember things (WIP)"}

use strict;
use warnings;

sub load_database {
    my $dbname = 'remember';
    my $host = 'localhost';
    my $port = 10221;
    my $username = "john";
    my $password = "password";

    my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",
        $username,
        $password,
        {AutoCommit => 0, RaiseError => 1}
        );
        # or die $DBI::errstr;

    $dbh -> trace(1, "/home/john/scripts/remember/database.log");

}

sub split_args {
    my $argstring = join(" ", @ARGV);
    
    my ($varvalue, $varname) = split(" as ", $argstring);


}

load_database;
split_args;
#!/usr/bin/perl

use strict;
use Term::ANSIColor;
use Text::CSV;

my $csv = Text::CSV->new({ sep_char => ',' });

my $programs_path = "/Users/johnivison/clones/scripts-new/aword/.aword_programs";

my @opts = @ARGV;

if ($opts[1] eq "add") {
    open(my $programs, ">>", $programs_path) or print("WARNING: programs file could not be opened (at $programs_path)");
    say $programs "\"$opts[2]\",\"$opts[3]\"";
    close $programs or die;
    print("Source added: $opts[2] => $opts[3]\n");
} elsif ($opts[1] eq "list") {
    open(my $programs, "<", $programs_path) or print("WARNING: programs file could not be opened (at $programs_path)");
    while (my $line = <$programs>) {
        chomp $line;

        if ($csv->parse($line)) {
            my @fields = $csv->fields();

            unless ($fields[0] eq "name") {
                print color("blue");
                print $fields[0];
                print color("white");
                print "    ";
                print color("white");
                print $fields[1];
                print color("reset"), "\n\n";
            }
        }

    }
} elsif ($opts[1] eq "remove") {

} elsif ($opts[1] eq "run") {
    my ($program, $program_name);

    open(my $programs, "<", $programs_path) or print("WARNING: programs file could not be opened (at $programs_path)");

    while (my $line = <$programs>) {
        chomp $line;

        if ($csv->parse($line)) {
            my ($name, $stored_opts) = $csv->fields();

            if ($name eq $opts[2]) {
                $program = $stored_opts;
                $program_name = $name;
                last;
            }
            
        }
    }

    system("aword", split(/ +/, $program));
}
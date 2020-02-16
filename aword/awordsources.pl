use strict;
use Term::ANSIColor;

my $sources_path = "/Users/johnivison/clones/scripts-new/aword/.aword_sources";

my @opts = @ARGV;   

if (@opts[1] eq "add") {
    open(my $sources, ">>", $sources_path) or print("WARNING: sources file could not be opened (at $sources_path)");
    say $sources "$opts[2],$opts[3]";
    close $sources or die;
    print("Source added: $opts[2] => $opts[3]\n");
} elsif (@opts[1] eq "list") {
    open(my $sources, "<", $sources_path) or print("WARNING: sources file could not be opened (at $sources_path)");
    while (my $line = <$sources>) {
        chomp $line;

        my @fields = split ",", $line;

        unless ($fields[1] eq "source") {
            print color("blue");
            print $fields[0];
            print color("white");
            print " - ";
            print color("white");
            print $fields[1];
            print color("reset"), "\n\n";
        }

    }
}
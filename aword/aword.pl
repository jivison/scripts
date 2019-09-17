#!/usr/bin/perl
use strict;
# use warnings;
use LWP::Simple;
use List::Util qw(shuffle);

# This runs on keyboard interrupt
local $SIG{INT} = sub {
    print "\nGoodbye!";
    exit 130;
};

my %sources = ("Korean" => 'https://docs.google.com/spreadsheets/d/1f0K1SQJ7ZcInRaMTs7ZWJ3i5l7i_HI2OzKQY9zbE4cw/export?format=csv&id=1f0K1SQJ7ZcInRaMTs7ZWJ3i5l7i_HI2OzKQY9zbE4cw&gid=0');

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

sub update_sources {

    my $key = undef;

    foreach $key (keys %sources) {
        
        my $source = $sources{$key};
        print "Downloading source '$key'\n";
        die "A non 200 status code was returned!" unless getstore($source, "/home/john/scripts/aword/$key\_words.csv") == 200;
    }

}

sub generate_words {
    my @all_words = ();

    foreach my $key (keys %sources) {
        open(my $current_data, "<", "/home/john/scripts/aword/$key\_words.csv") || die "Could not open file $key\_words.csv!";
        while (my $line = <$current_data>) {
            chomp $line;

            my @fields = split ",", $line;
            
            push(@all_words, {
                "language" => $key,
                "word" => $fields[0],
                "translation" => $fields[1]
            });
        }
    }
    return @all_words;
}

sub ask_question {
    my @words = generate_words;
    
    my $current_word = $words[rand @words];

    my $translation = trim($current_word->{"translation"} =~ s/\"//r);
    my $source = trim($current_word->{"word"} =~ s/\"//r);

    my ($demand, $expected) = shuffle(($translation, $source));

    print $current_word->{"language"} ."\t". $demand . ": ";
    my $user_input = <STDIN>;
    chomp $user_input;
    
    if (lc $user_input eq lc $expected) {
        print "\nCorrect!\n";
    } else {
        print "I was expecting '$expected'\nBetter luck next time!\n";
    }
}

sub run {
    my $number_of_words = $ARGV[0] || 1;
    if ($number_of_words eq "endless") {
        my $endlessindex = 0;
        while (1) {
            $endlessindex++;
            print("\n", $endlessindex, ". ");
            ask_question();
            print "Press enter to see the next word...";
            <STDIN>;
        }
    } else {
        for my $index (1..$number_of_words) {
            print("\n", $index, ". ");
            
            ask_question();
            print $index eq $number_of_words ? "Press enter to end the game..." : "Press enter to see the next word...";
            <STDIN>;
        }   
    }

}

update_sources if $ARGV[1] eq "update";

run();


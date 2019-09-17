#!/usr/bin/perl
use strict;
# use warnings;
use LWP::Simple;

# This runs on keyboard interrupt
local $SIG{INT} = sub {
    print "\nGoodbye!";
    exit 130;
};

my %sources = ("Korean" => 'https://docs.google.com/spreadsheets/d/1f0K1SQJ7ZcInRaMTs7ZWJ3i5l7i_HI2OzKQY9zbE4cw/export?format=csv&id=1f0K1SQJ7ZcInRaMTs7ZWJ3i5l7i_HI2OzKQY9zbE4cw&gid=0');

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
    my $translation = $current_word->{"translation"} =~ s/\"//r;
    print $current_word->{"language"} ."\t". $current_word->{"word"} . ": ";
    my $user_input = <STDIN>;
    chomp $user_input;
    
    if (lc $user_input eq lc $translation) {
        print "\nCorrect!\n";
    } else {
        print "I was expecting '$translation'\nBetter luck next time!\n";
    }
}

sub run {
    my $number_of_words = $ARGV[0] || 1;

    for my $index (1..$number_of_words) {
        print("\n", $index, ". ");
        
        ask_question();
        print $index eq $number_of_words ? "Press enter to end the game..." : "Press enter to see the next word...";
        <STDIN>;
    }   
}

update_sources if $ARGV[1] eq "update";

run();


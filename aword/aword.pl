#!/usr/bin/perl
#$ {"name": "aword", "language": "perl", "description": "Prompts the user with a series of words in foreign languages"}
use strict;
# use warnings;
use LWP::Simple;
use List::Util qw(shuffle);
use Term::ANSIColor;

my %sources = (
    # Controlled by awordsources now
    # "korean" => 'https://docs.google.com/spreadsheets/d/1f0K1SQJ7ZcInRaMTs7ZWJ3i5l7i_HI2OzKQY9zbE4cw/export?format=csv&id=1f0K1SQJ7ZcInRaMTs7ZWJ3i5l7i_HI2OzKQY9zbE4cw&gid=0'
    );

my %options = (
    "-c" => 1,
    "update" => "false",
    "-prompt" => "random",
    "-lang" => undef
);

my @unnamed_options = (
    "update",
    "uncolored"
);

my $colored = 1;
my $global_count = 0;
my $start_time = time;

my $sources_path = "/home/john/scripts/aword/.aword_sources";
my $history_path = "/home/john/scripts/aword/.aword_history";

open(my $sources_raw, "<", $sources_path) or print("WARNING: sources file could not be opened (at $sources_path)");

while (my $line = <$sources_raw>) {
    chomp $line;
    my @fields = split ",", $line;

    if ($fields[1] ne "source" ) {
        $sources{$fields[0]} = $fields[1];
    }
}

sub write_history {
    my $play_time = time - $start_time;
    open(my $history, ">>", $history_path) or print("WARNING: history file could not be opened (at $history_path)");
    say $history "$global_count,$options{'-prompt'},$start_time,$play_time";
}

sub setdown {
    write_history() unless $global_count == 0;;

    my @goodbyes = ("Goodbye!", "안녕!", "Salut!", "Tchüss!", "Прощай!");
    print "\n$goodbyes[ rand @goodbyes ]";
}

# This runs on keyboard interrupt
local $SIG{INT} = sub {
    setdown();
    exit 130;
};


sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

sub print_help {
    my $help = <<EOF;
aword perl
==========

A word is a small Perl script to prompt for the user to translate a random word. It pulls from csv files for sources.
The first column is assumed to be the foreign word, while the second is assumed to be the english translation.

Usage:
    aword [options...]

    During the program, type in a word and hit enter to submit a translation. Type '.quit' (on the prompt screen) or press ^C to
    exit the program.

Options:

    -c <count>            The number of words the program asks you. Can be either a postive integer or "endless" (default: 1)
    -prompt <prompt>      The language that is prompted. Can be "random", "english", or "foreign". (default: "random")
    -lang <language[,lang2]>      Restricts aword to a single given language. Has to correspond with a source

    update                Forces an a redownload of all the sources.
    uncolored             Removes colour from the program

Commands:

    \@help,-help           Prints this screen
    \@stats                Prints some stats about your playtime
    \@sources              Source control    
        add <alias> <url>       Adds a source to the list of sources. Must be csv format.
        list                    List the current sources

EOF

    print($help);
}

sub update_sources {

    my $key = undef;

    foreach $key (keys %sources) {
        
        my $source = $sources{$key};
        print "Downloading source '$key'\n";
        die "A non 200 status code was returned!" unless getstore($source, "/home/john/scripts/aword/sources/$key\_words.csv") == 200;
    }

}

sub find_source {
    my ($key) = @_;
    my @all_words = ();

    if (!exists($sources{ $key })) {
            print color("yellow");
            print "Language $key could not be found!\n";
            print color("reset");
            exit 130;
        }
 
        open(my $current_data, "<", "/home/john/scripts/aword/sources/$key\_words.csv") || die "Could not open file $key\_words.csv!";
        
        # Skip the first line
        my $headers=<$current_data>;

        while (my $line = <$current_data>) {
            chomp $line;

            my @fields = split ",", $line;

            push(@all_words, {
                "language" => $key,
                "word" => $fields[0],
                "translation" => $fields[1]
            })
        }
    return @all_words
}

sub generate_words {
    my @all_words = ();

    if ($options{"-lang"}) {
        my $key = $options{"-lang"};

        if (index($key, ",") != -1) {
            foreach my $iKey (split(/\,/, $key)) {
                push(@all_words, find_source($iKey))
            }
        } else {
            push(@all_words, find_source($key))
        }

    } else {
        foreach my $key (keys %sources) {
            open(my $current_data, "<", "/home/john/scripts/aword/sources/$key\_words.csv") || die "Could not open file $key\_words.csv!";
            while (my $line = <$current_data>) {
                chomp $line;

                my @fields = split ",", $line;

                push(@all_words, {
                    "language" => $key,
                    "word" => $fields[0],
                    "translation" => $fields[1]
                })
            }
        }
    }

    return @all_words;
}

sub ask_question {
    my @words = generate_words;
    
    my $current_word = $words[rand @words];

    my $translation = trim($current_word->{"translation"} =~ s/\"//r);
    my $source = trim($current_word->{"word"} =~ s/\"//r);

    my ($demand, $expected);

    if ($options{"-prompt"} eq "random") {
        ($demand, $expected) = shuffle(($translation, $source));
    } elsif ($options{"-prompt"} eq "english") {
        ($demand, $expected) = ($translation, $source);
    } else {
        ($demand, $expected) = ($source, $translation);
    }

    print $current_word->{"language"} ."\t". $demand . ": ";
    my $user_input = <STDIN>;
    chomp $user_input;
    
    if (lc $user_input eq ".quit") {
        setdown();
        exit;
    }

    $global_count++;

    if (lc $user_input eq lc $expected) {
        print color("green") if $colored == 1;
        print "\nCorrect!\n";
        print color("reset");
    } else {
        print color("red") if $colored == 1;
        print "I was expecting '$expected'\n";
        print color("reset");
        print "Better luck next time!\n";
    }
}

sub parse_options {

    my $option_type; 
    my $option_name;

    my $string_opts = join(" ", @ARGV);

    my $prog_regex = qr/%(\w+)/;

    if (index($string_opts, "\@help") != -1 || index($string_opts, "-help") != -1) {
        print_help();
        exit;
    } elsif (index($string_opts, "\@stats") != -1) {
        system($^X, "/home/john/scripts/aword/awordstats.pl");
        exit;
    } elsif (index($string_opts, "\@sources") != -1) {  
        system($^X, "/home/john/scripts/aword/awordsources.pl", @ARGV);
        exit;
    } elsif (index($string_opts, "\@programs") != -1) {  
        system($^X, "/home/john/scripts/aword/awordprograms.pl", @ARGV);
        exit;
    } elsif ($string_opts =~ /$prog_regex/) {
        # system("aword", "\@programs", "run", $1);
        system($^X, "/home/john/scripts/aword/awordprograms.pl", "\@programs", "run", $1);
        exit;
    }
    
    for my $arg (@ARGV) {

        if ($option_type eq "param_required") {
            $options{$option_name} = $arg;
            $option_type = undef;
        } elsif (rindex($arg, "-", 0) != -1) {
            $option_type = "param_required";
            $option_name = $arg;

            if (index(join(" ", keys %options), $option_name) == -1) {
                print color("yellow") if $colored == 1;
                print("WARNING: named option '$option_name' isn't recognized, it and its value will be ignored\n");
                print color("reset");
            }

        } else {
            $option_name = $arg;
            if (index(join(" ", @unnamed_options), $option_name) == -1) {
                print color("yellow") if $colored == 1;
                print("WARNING: option '$option_name' isn't recognized, it will be ignored\n");
                print color("reset");
            }
            if ($option_name eq "update") {$options{"update"} = "true" }
            elsif ($option_name eq "uncolored") {$colored = 0}
        }
    }

}

sub setup {
    parse_options();
    update_sources if $options{"update"} eq "true";
}

sub run {
    # -c for count
    my $number_of_words = $options{"-c"};
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


setup();
run();
setdown();

#!/usr/bin/perl
use strict;

use Term::ANSIColor;
use List::UtilsBy qw(max_by);

my %stats = (
    "count" => 0,
    "total_playtime" => 0
);

my %prompt_count = ();

sub favourite_prompt {
    my $most_used = max_by { $prompt_count{$_} } keys %prompt_count;
    return $most_used
}

open(my $history, "<", "/home/john/scripts/aword/.aword_history") || die "Could not open history file!";
while (my $line = <$history>) {
    chomp $line;

    my @fields = split ",", $line;

    $stats{"count"} += 1;
    $stats{"total_playtime"} += $fields[3];
    $stats{"total_answered"} += $fields[0];
    $prompt_count{$fields[1]} and $prompt_count{$fields[1]} += 1 or $prompt_count{$fields[1]} = 1;

}


print("You've played " . color('bold blue') . $stats{'count'} . color('reset') . " games so far...\n");
print("for a total of " . color('bold red') . $stats{'total_playtime'} . color('reset') . " seconds...\n");
print("and answered " . color('bold yellow') . $stats{'total_answered'} . color('reset') . " questions... \n");
print("with your favourite prompt of " . color('bold') . favourite_prompt . color('reset') . "!\n");

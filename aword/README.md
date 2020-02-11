# aword

From the help command:

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
        -lang <language>      Restricts aword to a single given language. Has to correspond with a source

        update                Forces an a redownload of all the sources.
        uncolored             Removes colour from the program

    Commands:

        \@help,-help           Prints this screen
        \@stats                Prints some stats about your playtime
        \@sources              Source control    
            add <alias> <url>       Adds a source to the list of sources. Must be csv format.
            list                    List the current sources

    EOF
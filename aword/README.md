# aword

From the help command:

    aword perl
    ==========

    A word is a small Perl script to prompt for the user to translate a random word. It pulls from csv files for sources. The first column is assumed to be the foreign word, while the second is assumed to be the english translation.

    Usage:
        aword [options...]

    Options:

        -c <count>            The number of words the program asks you. Can be either a postive integer or "endless" (default: 1)
        -prompt <prompt>      The language that is prompted. Can be "random", "english", or "foreign". (default: "random")

        update                Forces an a redownload of all the sources.

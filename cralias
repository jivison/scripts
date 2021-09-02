#!/usr/bin/python3
from pathlib import Path
import os
import sys

HOME = str(Path.home())
ALIASFILE = HOME + "/.aliases"
COLORS = {
    "blue": "\u001b[34m",
    "yellow": "\u001b[33m",
    "reset": "\u001b[0m"
}


class Cralias:
    def add(self, alias, *command):
        cleaned_command = " ".join(command).replace('"', '\\"')

        with open(ALIASFILE, "a+") as aliasfile:
            aliasfile.write(
                f"alias {alias}=\"{cleaned_command}\"\n"
            )

        print(
            f"Successfully wrote {COLORS['blue']}{alias}{COLORS['reset']} as {COLORS['yellow']}'{cleaned_command}'{COLORS['reset']}")

    def edit(self):
        os.system(f"nano {ALIASFILE}")

    def remove(self, alias):
        filtered_lines = []
        did_remove = False

        with open(ALIASFILE, "r+") as aliasfile:
            for line in aliasfile.readlines():

                if line.split(" ")[1].split("=")[0] != alias:
                    filtered_lines.append(line)
                else:
                    did_remove = True

        with open(ALIASFILE, "w") as aliasfile:
            aliasfile.writelines(filtered_lines)

        if did_remove:
            print(
                f"Successfully removed {COLORS['blue']}{alias}{COLORS['reset']} as an alias!")
        else:
            print(
                f"Couldn't find the alias {COLORS['blue']}{alias}{COLORS['reset']}, try {COLORS['yellow']}cralias list{COLORS['reset']} to see a list of your aliases.")

    def list(self):
        with open(ALIASFILE, "r+") as aliasfile:
            lines = [line.strip()
                     for line in aliasfile.readlines() if line.strip() != ""]

            if len(lines) == 0:
                print("You don't have any aliases yet!")
                return

            for line in lines:
                print(colour_alias(line))

    def print_help(self):
        print(f"""
cralias
=======
cralias is a small command line tool to help you manage terminal aliases, written by John Ivison (github.com/jivison)

By default aliases are stored in {COLORS['blue']}~/.aliases{COLORS['reset']}

To start, add the following line to your {COLORS['blue']}~/.<shell>rc{COLORS['reset']} file:
{COLORS['yellow']}source ~/.aliases{COLORS['reset']}

To add an alias, do either:
{COLORS['yellow']}cralias add myalias my command that I don't want to type out every time{COLORS['reset']}
or 
{COLORS['yellow']}cralias myalias this command is really long and would be a pain to type out every time{COLORS['reset']}

To remove an alias, simply do:
{COLORS['yellow']}cralias remove myalias{COLORS['reset']}

To list your aliases, do:
{COLORS['yellow']}cralias list{COLORS['reset']}

Misspelled something? To edit your aliases you can do:
{COLORS['yellow']}cralias edit{COLORS['reset']}
This will open up your alias file in a text editor (by default {COLORS['blue']}nano{COLORS['reset']})

Happy aliasing!
""")


def colour_alias(alias):
    alias = alias.replace("export", f"{COLORS['blue']}export{COLORS['reset']}")
    split_alias = alias.split('"')
    if len(split_alias) >= 2:
        split_alias[0] += f'{COLORS["yellow"]}'
        split_alias[-1] += f'{COLORS["reset"]}'

    alias = '"'.join(split_alias)

    return alias


if __name__ == "__main__":
    cralias = Cralias()

    if len(sys.argv) < 2:
        cralias.print_help()
        quit()

    command = sys.argv[1]

    if command == "edit":
        cralias.edit()
    elif command == "list":
        cralias.list()
    elif command == "remove":
        if len(sys.argv) < 3:
            print("Please specifiy an alias to remove!")
            quit()

        cralias.remove(sys.argv[2])
    elif command == "add":
        if len(sys.argv) < 4:
            print(
                f"Please specifiy an alias and something to alias (eg. {COLORS['yellow']}cralias add k kubectl{COLORS['reset']})!")
            quit()

        cralias.add(sys.argv[2], *sys.argv[3:])
    else:
        if len(sys.argv) < 3:
            print(
                f"Please specifiy an alias and something to alias (eg. {COLORS['yellow']}cralias k kubectl{COLORS['reset']})!")

        cralias.add(sys.argv[1], *sys.argv[2:])


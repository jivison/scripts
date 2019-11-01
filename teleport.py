#! /bin/python3
#$ {"name": "teleport", "language": "python", "description": "Helps you jump around the system"}

import sys
import os
import csv

filepath = "/home/john/scripts/teleportLocations.csv"

class AliasError(Exception):
    pass

def writeCSV(alias, path):

    csvTempStorage = "alias,path\n"

    with open(filepath, "r+") as locations:
        reader = csv.DictReader(locations)
        for line in reader:
            if line["alias"] != alias:
                csvTempStorage += f"{line['alias']}, {line['path'].strip()}\n"

    with open(filepath, "w") as locations:
        locations.write(f"{csvTempStorage}{alias.strip()},{path.strip()}")

    print(f"Wrote location '{path.strip()}' under '{alias}'")
        
def getLocation(alias):
    with open(filepath, "r") as locations:
        reader = csv.DictReader(locations)
        for line in reader:
            if line["alias"] == alias.strip():
                return line["path"]
        raise AliasError



args = sys.argv[1:]

command = args[0]

if command == "go":

    alias = args[1]

    try:
        print(getLocation(alias).strip())
    except AliasError:
        print(f"Alias '{alias}' not found!")

elif command == "set":
    alias = args[1]

    writeCSV(alias, os.popen('pwd').read())

elif command == "list":
    with open(filepath, "r") as locations:
        reader = csv.DictReader(locations)

        count = 1

        for line in reader:
            print(f"{count}) {line['alias'].strip()}{' ' * (15 - len(line['alias'].strip()))} ⁓ {10 * ' '}{line['path']}")
            count += 1

elif command == "edit":
    print(filepath)

else:
    print("teleport: Command not found!")
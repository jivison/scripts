#! /usr/bin/python3

import os
import sys

stickyfile_path = "/Users/johnivison/clones/scripts-new/sticky/stickyfile"

def main():
    args = sys.argv[1:]
    pwd = os.popen('pwd').read()

    if args[0] == 'grab':
        with open(stickyfile_path, "w+") as stickyfile:
            stickyfile.write(pwd.strip() + "/" + args[1])

        print("Grabbed file", args[1])

    elif args[0] == 'drop':
        with open(stickyfile_path) as stickyfile:
            stickypath = stickyfile.read()

            os.system(f"cp -r {stickypath} {pwd}")

            print("Dropped file ", stickypath)


main()
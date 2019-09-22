#! /bin/python3
#$ {"name": "getImageHelper", "language": "Python", "description": "Some helper functions for getImage"}

import sys
import os
import csv

command = sys.argv[1]


if command == "specific":
    imageToGet = sys.argv[2]
    with open("/home/john/scripts/imageGreeting/images.csv", "r+") as imagesfile:
    
        reader = csv.DictReader(imagesfile)
        for line in reader:
            if line["path"] == imageToGet:
                os.system(f"tiv -w {line['size']} /home/john/scripts/imageGreeting/images/{line['path']}")

elif command == "set":
    path = input("path> ")
    size = input("size> ")

    with open("/home/john/scripts/imageGreeting/images.csv", "a") as imagesfile:
        imagesfile.write(f"{size},{path}\n")

        


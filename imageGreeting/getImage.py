#! /bin/python3
#$ {"name": "getImage", "language": "Python", "description": "Gets a random image from a series of images"}

import csv
import random
import os

with open("/home/john/scripts/imageGreeting/images.csv", "r") as imagesfile:
    reader = csv.DictReader(imagesfile)

    lines = []

    for line in reader:
        lines.append(line)

    image = random.choice(lines)

    size, imagePath = image["size"], image["path"] 

    os.system(f"tiv -w {size} /home/john/scripts/imageGreeting/images/{imagePath}")
    
# TO DO: Write a proper tool for serializing and re-serializing files
    # get file name from user input
    # determine source serialization from user input
    # parse source file, output remaining serializations

from textwrap import dedent
import rdflib
from rdflib import *
import os
import re 

def prompt_user(): 
    # get file path
    file_prompt = dedent("""Enter the path of the file relative to the working directory. 
    The file must have the extenstion ".rdf", ".ttl", ".json", or ".nt"
    For example: '../uwlswd_vocabs/newspaper_genre_list.ttl'
    > """)
    file_path = input(file_prompt)

    if os.path.exists(file_path):
        return file_path 
    
    else:
        print(dedent("Error: file could not be found.\n"))
        confirm = input("""Re-enter file path? (Yes or No)  
    > """)
        if confirm.lower() == "yes":
            return prompt_user()
        else:
            exit(0)

file_path = prompt_user()

split = file_path.split("/")
directory = ""

while len(split) > 1:
        directory = directory + split.pop(0) + "/"

print(directory)

split = split[0].split(".")
format = split.pop()
file_name = split.pop()

if format not in ["json","rdf","ttl","nt"]:
    print("Error: file is not one of the accepted formats")
    exit(0)

def serialize(format, directory, file_name):
    g = rdflib.Graph().parse(file_path)

    if format != "rdf":
        nt = g.serialize(format='xml')
        path = directory + file_name + "." + "rdf"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print(file_name + "." + "rdf" + " generated")

    if format != "nt":
        nt = g.serialize(format='nt')
        path = directory + file_name + "." + "nt"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print(file_name + "." + "nt" + " generated")

    
    if format != "ttl":
        turtle = g.serialize(format='ttl')
        path = directory + file_name + "." + "ttl"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print(file_name + "." + "ttl" + " generated")


    if format != "json":
        nt = g.serialize(format='json-ld')
        path = directory + file_name + "." + "json"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print(file_name + "." + "json" + " generated")

serialize(format, directory, file_name)
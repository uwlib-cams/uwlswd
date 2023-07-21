from textwrap import dedent
import rdflib
import json
import os
import re 

from update_md import *
# get file location
# fill out metadata if file does not exist
# serialize formats
# call xsl html 

def prompt_user(): 
    # get file path
    file_prompt = dedent("""Enter the path of the file relative to the working directory. 
    The file must have the extenstion ".rdf", ".ttl", ".jsonld", or ".nt"
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

print("directory: " + directory)

split = split[0].split(".")
format = split.pop()
file_name = split.pop()
print("format: " + format)
print("file_name: " + file_name)

if format not in ["jsonld","rdf","ttl","nt"]:
    print("Error: file is not one of the accepted formats")
    exit(0)

prompt_md(directory, file_name)
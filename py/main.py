# main file for workflow/management of uwlswd datasets/vocabs

from textwrap import dedent
import rdflib
import json
import os
import re 

from serialize import serialize
# get file location
# fill out metadata if file does not exist
# serialize formats
# call xsl html 

# this script should be run from the top-level folder of uwlswd
# saxon should be installed in top-level directory

# check set-up
print(dedent("""Please confirm:
1) Terminal is open in the uwlswd top-level directory
2) Saxon processor .jar file is located in the user's home (~) directory"""))
confirm = input("OK to proceed? (Yes or No):\n> ")
if confirm.lower() == "yes":
    pass
else:
    exit(0)

# get location and version of saxon folder
saxon_dir_prompt = dedent("""Enter the name of the directory in your home folder where your Saxon HE .jar file is stored
For example: 'saxon', 'saxon11', etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""Enter your Saxon HE version number (this will be in the .jar file name)
For example: '11.1', '11.4', etc.
> """)
saxon_version = input(saxon_version_prompt)

# get file path
def prompt_user(): 
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

# process file path for separate variables 
file_path = prompt_user()
split = file_path.split("/")

directory = ""
while len(split) > 1:
        directory = directory + split.pop(0) + "/"

split = split[0].split(".")
format = split.pop()
file_name = split.pop()
output_file = f'{directory}{file_name}.html'

if format not in ["jsonld","rdf","ttl","nt"]:
    print("Error: file is not one of the accepted formats")
    exit(0)

# serialize 
print(dedent(f"""{'=' * 20}
SERIALIZING DATA
{'=' * 20}"""))

serialize(format, file_path, directory, file_name)

# check existence/accuracy of metadata for html+rdfa
# prompt_md(directory, file_name)

# generate html+rdfa
print(dedent(f"""{'=' * 20}
GENERATING HTML+RDFa
{'=' * 20}"""))

if (file_path.endswith('.rdf')):
    xsl_input_file = file_path
else:
    xsl_input_file = file_path.rsplit(".", 1)[0] + ".rdf"

rdf2rdfa_stylesheet = "xsl/rdf2rdfa-draft.xsl"
os_command = f"""java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar 
net.sf.saxon.Transform -t 
-s:{file_path} 
-xsl:{rdf2rdfa_stylesheet} 
-o:{output_file}"""

os_command = os_command.replace('\n', '')
os.system(os_command)

print(dedent(f"""{'=' * 20}
COMPLETE
{'=' * 20}"""))
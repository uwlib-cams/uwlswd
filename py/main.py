# main file for workflow/management of uwlswd datasets/vocabs

from textwrap import dedent
import rdflib
import os

from serialize import serialize
from fancyhtml import fancify_HTML

# this script should be run from the top-level folder of uwlswd
# saxon should be installed in top-level directory (~)
# input can be either an rdf/xml file or a directory containing multiple rdf/xml files

# uses rdflib graph to format rdf/xml file so each rdf:Description element has a unique rdf:about attribute
def format_rdflib(file):
    g = rdflib.Graph().parse(file_path)

    for ns_prefix, namespace in g.namespaces():
        g.bind(ns_prefix, namespace)

    g.serialize(destination=file, format="xml")

# this function begins the process of transforming the rdf file to all other serializations 
def process_file(file_path):
    split = file_path.split("/")

    directory = ""
    while len(split) > 1:
            directory = directory + split.pop(0) + "/"

    split = split[0].split(".")
    format = split.pop()
    file_name = split.pop()
    output_file = f'{directory}{file_name}.html'

    print(dedent(f"""{'=' * 20}
PROCESSING {file_name}
{'=' * 20}"""))

    # if format not in ["jsonld","rdf","ttl","nt"]:
    #     print("Error: file is not one of the accepted formats")
    #     exit(0)

    # serialize 
    format_rdflib(file_path)
    serialize(format, file_path, directory, file_name)

    # generate html+rdfa

    # this will always end with rdf because of pre-processing
    if (file_path.endswith('.rdf')):
        xsl_input_file = file_path
    # this is only if we serialize from other formats, currently it is obsolete
    else:
        xsl_input_file = file_path.rsplit(".", 1)[0] + ".rdf"

    # call rdf2rdfa stylesheets
    rdf2rdfa_stylesheet = "xsl/rdf2rdfa-draft.xsl"
    os_command = f"""java -cp {saxon_dir}/saxon-he-{saxon_version}.jar 
    net.sf.saxon.Transform 
    -s:{file_path} 
    -xsl:{rdf2rdfa_stylesheet} 
    -o:{output_file}"""

    os_command = os_command.replace('\n', '')
    os.system(os_command)

    print(f"""    {file_name}.html generated""")

    fancy = input("\n\tFancify HTML? (Yes or No):\n\t> ")
    if fancy.lower() == "yes":
        fancify_HTML(output_file)
        print(f"fancy HTML generated")

### SCRIPT STARTS HERE ###

# check set-up
print(dedent("""Please confirm:
1) Terminal is open in the uwlswd top-level directory
2) You have the full directory path to where the Saxon processor .jar file is located ready"""))
confirm = input("OK to proceed? (Yes or No):\n> ")
if confirm.lower() == "yes":
    pass
else:
    exit(0)

# get location and version of saxon folder
saxon_dir_prompt = dedent("""Enter the full directory path to where your Saxon HE .jar file is stored
For example: '~/saxon', 'c:/Users/cpayn/saxon11', etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""Enter your Saxon HE version number (this will be in the .jar file name)
For example: '11.1', '11.4', etc.
> """)
saxon_version = input(saxon_version_prompt)

# get file path
def prompt_user(): 
    file_prompt = dedent("""Enter the path of the folder or file relative to the working directory. 
    The file must have the extenstion ".rdf", 
    if entering the path of a folder, each '.rdf' file within the directory will be serialized
    For example: '../uwlswd_vocabs' or '../uwlswd_vocabs/linked_data_platforms.rdf
    > """)
    file_path = input(file_prompt)

    if os.path.exists(file_path):
        return file_path 
    
    else:
        print(dedent("\nError: file could not be found. Please re-enter file name or press CTRL+C to cancel.\n"))
        return prompt_user()

# process file path for separate variables 
file_path = prompt_user()
if os.path.isfile(file_path):
    if file_path.endswith('.rdf'):
        process_file(file_path)
    else: 
        print("Input must be an rdf file or a directory containing rdf files")
        exit()

elif os.path.isdir(file_path):
    complete_files = []
    for root, dir_names, file_names in os.walk(file_path):
        for f in file_names:
            if f.endswith('.rdf'):
                complete_files.append(os.path.join(root, f))

    print(dedent(f"""{'=' * 20}
{len(complete_files)} FILES FOUND
{'=' * 20}"""))

    for f in complete_files:
        process_file(f)

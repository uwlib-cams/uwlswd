# This script calls the xsl script rdf2datacite.xsl
# and produces datacite metadata files stored in UWLSWD/DataCite/
# outputting any missing elements to command line 

from textwrap import dedent
import rdflib
import os


# uses rdflib graph to format rdf/xml file so each rdf:Description element has a unique rdf:about attribute
# use already existing namespaces
def format_rdflib(abs_path):
    g = rdflib.Graph(bind_namespaces="none").parse(abs_path)

    # for ns_prefix, namespace in g.namespaces():
    #     g.bind(ns_prefix, namespace)

    g.serialize(destination=abs_path, format="xml")

# calls format_rdflib and then runs rdf2datacite.xsl on formatted file
def process_file(file_path):
    # file path parsing assumes main.py is being run in top-level uwlswd 
    # AND that the file being parsed is NOT located IN uwlswd folder
    
    # absolute path
    abspath = os.path.abspath(file_path)

    print(dedent(f"""{'=' * 20}
Generating DataCite metadata file from {file_path}
{'=' * 20}"""))

    format_rdflib(abspath)

    # run rdf2datacite.xsl
    os_command = f"""java -cp {saxon_dir}/saxon-he-{saxon_version}.jar 
    net.sf.saxon.Transform 
    -s:{file_path} 
    -xsl:xsl/rdf2datacite.xsl"""

    os_command = os_command.replace('\n', '')
    os.system(os_command)


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
For example: ~/saxon, c:/Users/cpayn/saxon11, etc.
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
    For example: ../uwlswd_vocabs or ../uwlswd_vocabs/linked_data_platforms.rdf
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

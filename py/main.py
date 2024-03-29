# main file for workflow/management of uwlswd datasets/vocabs
# formats rdf/xml file(s), serializes N-Triples, Turtle, JSON-LD, and HTML+RDFa versions

from textwrap import dedent
import rdflib
import os

from serialize import serialize
from fancyhtml import fancify_HTML

# this script should be run from the top-level folder of uwlswd
# saxon should be installed in top-level directory (~)
# input can be either an rdf/xml file or a directory containing multiple rdf/xml files

# uses rdflib graph to format rdf/xml file so each rdf:Description element has a unique rdf:about attribute
# use already existing namespaces
def format_rdflib(abs_path):
    g = rdflib.Graph(bind_namespaces="none").parse(abs_path)

    # for ns_prefix, namespace in g.namespaces():
    #     g.bind(ns_prefix, namespace, override=False)

    g.serialize(destination=abs_path, format="xml", encoding="utf8")

# this function begins the process of transforming the rdf file to all other serializations 
def process_file(file_path, fancy):

    # file path parsing assumes main.py is being run in top-level uwlswd 
    # AND that the file being parsed is NOT located IN uwlswd folder
    
    # absolute path
    abspath = os.path.abspath(file_path)
    
    # path w no extension
    file_path_noext = file_path.replace(".rdf", "")

    # get uri path - assumes top-level directory for file is parallel to uwlswd directory
    uri_path = "https://uwlib-cams.github.io/" + file_path_noext.replace("../", "").replace("\\", "/")
    
    # get file name - splits string at furthest '/' and takes string to the right
    file_name = file_path_noext.rsplit("/", 1)[1]
    
    # set output file as file path with no extension + html extenstion
    output_file = f'{file_path_noext}.html'


    print(dedent(f"""{'=' * 20}
PROCESSING {file_name}
{'=' * 20}"""))

    # serialize 
    format_rdflib(abspath)
    serialize(file_path, file_name, uri_path)

    # generate html+rdfa
    # call rdf2rdfa stylesheets

    rdf2rdfa_stylesheet = "xsl/rdf2htmlrdfa.xsl"

    # **rdf2htmlrdfa-plusdc.xsl for DataCite to Schema.org**
    # ** if this becomes necessary again, schema_workflow_rdfxml needs to be passed from input to process_file()
    # if schema_workflow_rdfxml == True:
    #     rdf2rdfa_stylesheet = "xsl/rdf2htmlrdfa.xsl"
    # else: 
    #     rdf2rdfa_stylesheet = "xsl/rdf2htmlrdfa-plusdc.xsl"

    print(f"""\ngenerating HTML+RDFa with Schema.org data""")
    os_command = f"""java -cp {saxon_dir}/saxon-he-{saxon_version}.jar 
    net.sf.saxon.Transform 
    -s:{file_path} 
    -xsl:{rdf2rdfa_stylesheet} 
    -o:{output_file}"""

    os_command = os_command.replace('\n', '')
    os.system(os_command)

    print(f"""{file_name}.html generated""")

    if fancy == True:
        fancify_HTML(output_file)
        print(f"""fancy HTML generated""")

### SCRIPT STARTS HERE ###
fancy = False
# schema_workflow_rdfxml = False
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
For example: 11.1, 11.4, etc.
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
        # **rdf2htmlrdfa-plusdc.xsl**
#         schema_workflow_input = input("""\nGenerate schema.org data from rdf/xml? 
# If no, schema.org data will be generated using the DataCite metadata file located in UWLSWD/DataCite (yes/no) 
# > """)
#         if schema_workflow_input.lower() == 'yes':
#             schema_workflow_rdfxml = True

        fancy_input = input("""\nGenerate fancier HTML page? (yes/no) 
> """)
        if fancy_input.lower() == 'yes':
            fancy = True

        process_file(file_path, fancy)
    else: 
        print("Input must be an rdf file or a directory containing rdf files")
        exit()

elif os.path.isdir(file_path):
    complete_files = []

    # **rdf2htmlrdfa-plusdc.xsl**
#     schema_workflow_input = input("""\nGenerate schema.org data from rdf/xml? 
# If no, schema.org data will be generated using the DataCite metadata file located in UWLSWD/DataCite (yes/no) 
# > """)
#     if schema_workflow_input.lower() == 'yes':
#         schema_workflow_rdfxml = True

    fancy = input("""\nGenerate fancier HTML pages? (yes/no) 
> """)
    if fancy.lower() == 'yes':
        fancy = True

    for root, dir_names, file_names in os.walk(file_path):
        for f in file_names:
            if f.endswith('.rdf'):
                complete_files.append(os.path.join(root, f))

    print(dedent(f"""{'=' * 20}
{len(complete_files)} FILES FOUND
{'=' * 20}"""))

    for f in complete_files:
        process_file(f, fancy)

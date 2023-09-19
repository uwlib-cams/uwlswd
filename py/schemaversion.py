import os
from textwrap import dedent
import lxml.etree as ET
import rdflib
from rdflib import Namespace


# uses rdflib graph to format rdf/xml file so each rdf:Description element has a unique rdf:about attribute
def format_rdflib(abs_path):
    g = rdflib.Graph().parse(abs_path)
    g.serialize(destination=abs_path, format="xml")


def update_namespaces(file_path):
    with open(file_path, 'r') as f:
        file = f.read()
    if '''xmlns:schema="https://schema.org/"''' not in file:
        file = file.replace('''<rdf:RDF''', '''<rdf:RDF
   xmlns:schema="https://schema.org/"''')
        print("schema namespace added")

    with open(file_path, 'w') as f:
        f.write(file)
    

def update_version(file_path):

    versioned = False

    tree = ET.parse(file_path)
    root = tree.getroot()

    for description in root:
        if (description.tag == "{http://www.w3.org/1999/02/22-rdf-syntax-ns#}Description") and (("{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about" in description.attrib) and ('#' not in description.attrib["{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about"])):
            for elem in description:

                # old version element exists 
                if elem.tag == "{http://www.w3.org/2002/07/owl#}versionInfo" or elem.tag == "{http://www.w3.org/2002/07/owl#}version":
                    versioned = True
                    old_version = elem.text
                    version_array = old_version.split('-')
                    for i, num in enumerate(version_array):
                       version_array[i] = int(num)
                    version_array[1] = version_array[1] + 1
                    new_version = str(version_array[0]) + '-' + str(version_array[1]) + '-' + str(version_array[2])

                    new_version_elem = ET.Element("{https://schema.org/}version")
                    new_version_elem.text = new_version
                    description.append(new_version_elem)
                    print(f"schema version added")
                    description.remove(elem)
                    print(f"owl version removed")

                    print(f"version updated from {old_version} to {new_version}")
                
                # new version element already exists
                elif elem.tag == "{https://schema.org/}version":
                    print("version element already updated")
                    versioned = True

            if versioned == False:
                print("no previous version")
                new_version_elem = ET.Element("{https://schema.org/}version")
                new_version_elem.text = "1-0-0"
                description.append(new_version_elem)
                print(f"schema version added")
    
    ET.indent(root, '    ')
    tree.write(file_path, encoding="UTF-8", pretty_print = True)

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
        
        print(dedent(f"""{'=' * 20}
PROCESSING {file_path}
{'=' * 20}"""))
        abspath = os.path.abspath(file_path)
        format_rdflib(abspath)
        update_namespaces(file_path)
        update_version(file_path)
        format_rdflib(abspath)
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
        
        print(dedent(f"""{'=' * 20}
PROCESSING {f}
{'=' * 20}"""))
        abspath = os.path.abspath(f)
        format_rdflib(abspath)
        update_namespaces(f)
        update_version(f)
        format_rdflib(abspath)

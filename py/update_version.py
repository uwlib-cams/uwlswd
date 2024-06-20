import lxml.etree as ET
import os
from textwrap import dedent

# run from top-level uwlswd folder 
# changes DOIs in UWLSWD resource rdf:Description @rdf:about attributes to lowercase

def process_file(filepath):
    edited = False
    tree = ET.parse(filepath)
    root = tree.getroot()

    for description in root:
        if description.tag == '{http://www.w3.org/1999/02/22-rdf-syntax-ns#}Description':
            for child in description: 
              if '{https://schema.org/}version' in child.tag:
                    currentVersion = child.text
                    split = currentVersion.rsplit("-", 2)
                    print(split)
                    model = int(split[0])
                    revision = int(split[1]) + 1
                    addition = int(split[2])
                    newVersion = str(model) + "-" + str(revision) + '-' + '0'
                    print(newVersion)
                    child.text = newVersion
                    edited = True


    if edited == True: 
        tree.write(filepath, xml_declaration=True, encoding="UTF-8")
        print("version updated")

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

file_path = prompt_user()
if os.path.isfile(file_path):
    if file_path.endswith('.rdf'):
        print("\nprocessing " + file_path)
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

    for f in complete_files:
        print("\nprocessing " + f)
        process_file(f)

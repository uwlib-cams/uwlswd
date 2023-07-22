from textwrap import dedent
import rdflib
import json
import xmltodict
import lxml.etree as ET
import os
import re 

def save_to_file(json_data, xmlfile):
    
    root = ET.Element("data")
    root.text = json.dumps(json_data)
    tree = ET.ElementTree(root)
    tree.write(xmlfile, xml_declaration=True, encoding="UTF-8", pretty_print = True)

def create_md(directory, file_name):
    name_prompt = dedent("""\n    Enter dataset name
    > """)
    desc_prompt = dedent("""\n    Enter description of dataset
    > """)
    path_prompt = dedent("""\n    Enter path
    > """)
    doi_prompt = dedent("""\n    Enter doi
    > """)

    dict = {}
    datasetName = input(name_prompt)
    description = input(desc_prompt)
    path = input(path_prompt)
    doi = input(doi_prompt)
    dict["datasetName"] = datasetName
    dict["description"] = description
    dict["fileName"] = file_name
    dict["path"] = path
    dict["doi"] = doi

    json_dict = json.dumps(dict, indent=4)
    with open(f'{directory}{file_name}_metadata.json', 'w') as file:
        file.write(json_dict)
    
def edit_md(dict, key):
    value_prompt = f"""\n    Enter new value for {key}
    > """
    value = input(value_prompt)
    dict[key] = value
    print(f'\n    \033[34m{key}\033[00m set to \033[34m{value}\033[00m')

def prompt_md(directory, file_name):
    if os.path.exists(f'{directory}{file_name}_metadata.xml'):
        with open(f'{directory}{file_name}_metadata.xml') as file:
            file_dict = xmltodict.parse(file.read())
            file_dict = file_dict["data"].translate({ord(i): None for i in '[]'})
        print(file_dict)  
        md = json.loads(file_dict)
        
        for i in md.keys():
              print(f'\n    \033[34m{i}\033[00m is set as \033[34m{md[i]}\033[00m')
              answer = input("    is this correct (y/n)> ")
              if answer.lower() == 'n':
                  edit_md(md, i)
        
        json_dict = json.dumps(md, indent=4)
        save_to_file(md, f'{directory}/{file_name}_metadata.xml')

    else: 
        create_md(directory, file_name)
from textwrap import dedent
import rdflib
import json
import os
import re 

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
    if os.path.exists(f'{directory}{file_name}_metadata.json'):
        with open(f'{directory}{file_name}_metadata.json') as file:
            md = json.load(file)
        
        for i in md.keys():
              print(f'\n    \033[34m{i}\033[00m is set as \033[34m{md[i]}\033[00m')
              answer = input("    is this correct (y/n)> ")
              if answer.lower() == 'n':
                  edit_md(md, i)
        
        json_dict = json.dumps(md, indent=4)
        with open(f'{directory}/{file_name}_metadata.json', 'w') as file:
            file.write(json_dict)

    else: 
        create_md(directory, file_name)

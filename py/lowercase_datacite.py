import lxml.etree as ET
import os
from textwrap import dedent

# run from top-level uwlswd folder 
# changes DOIs to lowercase in DataCite metadata files

def process_file(filepath):
    edited = False
    tree = ET.parse(filepath)
    root = tree.getroot()

    for child in root:
        if child.tag == '{http://datacite.org/schema/kernel-4}identifier':
            old_doi = child.text
            print(old_doi)
                    
            if old_doi.islower() == False: 
                final_doi = old_doi.lower()
                child.text = final_doi
                edited = True
                
    if edited == True: 
        tree.write(filepath, xml_declaration=True, encoding="UTF-8")
        print("DOI changed to lowercase")


complete_files = []

for root, dir_names, file_names in os.walk('DataCite'):
    for f in file_names:
        if f.endswith('.xml'):
           complete_files.append(os.path.join(root, f))

for f in complete_files:
    print("\nprocessing " + f)
    process_file(f)

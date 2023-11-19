# This script parses an html file produced using main.py
# and adjusts formatting to create tabs displaying each serialization of the resource
# written by Cypress Payne

import lxml.etree as ET

def fancify_HTML(filepath):
    basepath = (filepath.rsplit('.', 1)).pop(0)
    rdfpath = basepath + '.rdf'
    ttlpath = basepath + '.ttl'
    ntpath = basepath + '.nt'
    jsonpath = basepath + '.jsonld'

    tree = ET.parse(filepath)
    root = tree.getroot()

    
    for child in root:

        # go to body tag
        if child.tag == "body":
            child.insert(0, ET.XML(
                         '''<script type="text/javascript" src="https://uwlib-cams.github.io/webviews/js/uwlswd.js"></script>'''))
            # find header 
            triple_h2 = child.find("h2[@id='triples']")

            # find links in alternatlinks div and copy href
            alternatelinks = child.find("div[@class='alternatelinks']")
            rdflink_href = "NOT FOUND"
            ttlink_href = "NOT FOUND"
            ntlink_href = "NOT FOUND"
            jsonlink_href = "NOT FOUND"
            for link in alternatelinks:
                if link.attrib["href"].endswith(".nt"):
                    ntlink_href = link.attrib["href"]
                if link.attrib["href"].endswith(".ttl"):
                    ttlink_href = link.attrib["href"]
                if link.attrib["href"].endswith(".jsonld"):
                    jsonlink_href = link.attrib["href"]
                if link.attrib["href"].endswith(".rdf"):
                    rdflink_href = link.attrib["href"]

            # remove alternatelink div and label
            child.remove(alternatelinks)
            child.remove(child.find("h2[@id='links']"))

            # add tabs
            triple_h2.addnext(ET.XML(
                         '''<div class="tab">
         <button class="tablinks" onclick="openTab(event, 'table')">Table View</button>
         <button class="tablinks" onclick="openTab(event, 'rdfxml')">RDF/XML</button>
         <button class="tablinks" onclick="openTab(event, 'ttl')">Turtle</button>
         <button class="tablinks" onclick="openTab(event, 'nt')">N-Triples</button>
         <button class="tablinks" onclick="openTab(event, 'json')">JSON</button>
      </div>'''))
            
            # set up table tab
            table_div = ET.Element("div")
            table_div.attrib["id"] = "table"
            table_div.attrib["class"] = "tabcontent"
            table_div.attrib["style"] = "display:block"
            table = child.find("table")
            table_div.append(table)
            
            # add table under tab buttons
            tab_div = child.find("div[@class='tab']")
            tab_div.addnext(table_div)


            # set up other tabcontent divs

            # create rdf tab div
            with open(rdfpath) as f:
                rdftext = f.read()

            rdf_div = ET.Element("div")
            rdf_div.attrib["id"] = "rdfxml"
            rdf_div.attrib["class"] = "tabcontent"
            
            # download link 
            rdflink_a = ET.SubElement(rdf_div, "a")
            rdflink_a.attrib["class"] = "download"
            rdflink_a.attrib["href"] = rdflink_href
            rdflink_a.attrib["download"] = ""
            rdflink_a.attrib["target"] = "_blank"
            rdflink_a.attrib["rel"] = "noopener noreferrer"
            rdflink_a.text = "Download RDF/XML"
            
            # display text
            rdfPre = ET.SubElement(rdf_div, "pre")
            rdfPre.text = rdftext

            # create ttl tab div
            with open(ttlpath) as f:
                ttltext = f.read()
            ttlDiv = ET.Element("div")
            ttlDiv.attrib["id"] = "ttl"
            ttlDiv.attrib["class"] = "tabcontent"

            # download link 
            ttllink_a = ET.SubElement(ttlDiv, "a")
            ttllink_a.attrib["class"] = "download"
            ttllink_a.attrib["href"] = ttlink_href
            ttllink_a.attrib["download"] = ""
            ttllink_a.attrib["target"] = "_blank"
            ttllink_a.attrib["rel"] = "noopener noreferrer"
            ttllink_a.text = "Download Turtle"

            # display text
            ttlPre = ET.SubElement(ttlDiv, "pre")
            ttlPre.text = ttltext

            # create nt tab div
            with open(ntpath) as f:
                nttext = f.read()
            nt_Div = ET.Element("div")
            nt_Div.attrib["id"] = "nt"
            nt_Div.attrib["class"] = "tabcontent"

            # download link 
            ntlink_a = ET.SubElement(nt_Div, "a")
            ntlink_a.attrib["class"] = "download"
            ntlink_a.attrib["href"] = ntlink_href
            ntlink_a.attrib["download"] = ""
            ntlink_a.attrib["target"] = "_blank"
            ntlink_a.attrib["rel"] = "noopener noreferrer"
            ntlink_a.text = "Download N-Triples"

            #display text
            ntPre = ET.SubElement(nt_Div, "pre")
            ntPre.text = nttext

            # create json tab div
            with open(jsonpath) as f:
                jsontext = f.read()
            json_div = ET.Element("div")
            json_div.attrib["id"] = "json"
            json_div.attrib["class"] = "tabcontent"

            # download link 
            jsonlink_a = ET.SubElement(json_div, "a")
            jsonlink_a.attrib["class"] = "download"
            jsonlink_a.attrib["href"] = jsonlink_href
            jsonlink_a.attrib["download"] = ""
            jsonlink_a.attrib["target"] = "_blank"
            jsonlink_a.attrib["rel"] = "noopener noreferrer"
            jsonlink_a.text = "Download JSON-LD"

            # display text
            jsonPre = ET.SubElement(json_div, "pre")
            jsonPre.text = jsontext

            # locate hr and add tab divs above
            hr = child.find("hr")

            hr.addprevious(rdf_div)
            hr.addprevious(ttlDiv)
            hr.addprevious(nt_Div)
            hr.addprevious(json_div)
    
    # format and rewrite file
    ET.indent(root, '    ')
    tree.write(filepath, method="html", encoding="UTF-8", pretty_print = True)

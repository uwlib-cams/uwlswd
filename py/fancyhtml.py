import lxml.etree as ET

def fancifyHTML(filepath):
    basepath = (filepath.rsplit('.', 1)).pop(0)
    rdfpath = basepath + '.rdf'
    ttlpath = basepath + '.ttl'
    ntpath = basepath + '.nt'
    jsonpath = basepath + '.jsonld'

    tree = ET.parse(filepath)
    root = tree.getroot()
    
    for child in root:
        # go to body tag
        if child.tag == "{http://www.w3.org/1999/xhtml}body":
            child.insert(0, ET.XML(
                         '''<script type="text/javascript" src="https://uwlib-cams.github.io/webviews/js/uwlswd.js"></script>'''))
            # find header 
            tripleH2 = child.find("{http://www.w3.org/1999/xhtml}h2[@id='triples']")

            # find links
            alternatelinks = child.find("{http://www.w3.org/1999/xhtml}div[@class='alternatelinks']")
            rdflink = "NOT FOUND"
            ttllink = "NOT FOUND"
            ntlink = "NOT FOUND"
            jsonlink = "NOT FOUND"
            for link in alternatelinks:
                if link.attrib["href"].endswith(".nt"):
                    ntlink = link.attrib["href"]
                if link.attrib["href"].endswith(".ttl"):
                    ttllink = link.attrib["href"]
                if link.attrib["href"].endswith(".jsonld"):
                    jsonlink = link.attrib["href"]
                if link.attrib["href"].endswith(".rdf"):
                    rdflink = link.attrib["href"]

            child.remove(alternatelinks)
            child.remove(child.find("{http://www.w3.org/1999/xhtml}h2[@id='links']"))

            # add tabs
            tripleH2.addnext(ET.XML(
                         '''<div class="tab" xmlns="http://www.w3.org/1999/xhtml">
         <button class="tablinks" onclick="openTab(event, 'table')">Table View</button>
         <button class="tablinks" onclick="openTab(event, 'rdfxml')">RDF/XML</button>
         <button class="tablinks" onclick="openTab(event, 'ttl')">Turtle</button>
         <button class="tablinks" onclick="openTab(event, 'nt')">N-Triple</button>
         <button class="tablinks" onclick="openTab(event, 'json')">JSON</button>
      </div>'''))
            
            # set up table tab
            tableDiv = ET.Element("{http://www.w3.org/1999/xhtml}div")
            tableDiv.attrib["id"] = "table"
            tableDiv.attrib["class"] = "tabcontent"
            tableDiv.attrib["style"] = "display:block"
            table = child.find("{http://www.w3.org/1999/xhtml}table")
            tableDiv.append(table)
            
            tabDiv = child.find("{http://www.w3.org/1999/xhtml}div[@class='tab']")
            tabDiv.addnext(tableDiv)


            # add other tabcontent divs after
            hr = child.find("{http://www.w3.org/1999/xhtml}hr")

            with open(rdfpath) as f:
                rdftext = f.read()

            rdfDiv = ET.Element("{http://www.w3.org/1999/xhtml}div")
            rdfDiv.attrib["id"] = "rdfxml"
            rdfDiv.attrib["class"] = "tabcontent"
            
            # download link 
            rdfLink = ET.SubElement(rdfDiv, "{http://www.w3.org/1999/xhtml}a")
            rdfLink.attrib["class"] = "download"
            rdfLink.attrib["href"] = rdflink
            rdfLink.attrib["download"] = ""
            rdfLink.attrib["target"] = "_blank"
            rdfLink.attrib["rel"] = "noopener noreferrer"
            rdfLink.text = "Download RDF/XML"
            
            # display text
            rdfPre = ET.SubElement(rdfDiv, "{http://www.w3.org/1999/xhtml}pre")
            rdfPre.text = rdftext

            with open(ttlpath) as f:
                ttltext = f.read()
            ttlDiv = ET.Element("{http://www.w3.org/1999/xhtml}div")
            ttlDiv.attrib["id"] = "ttl"
            ttlDiv.attrib["class"] = "tabcontent"

            # download link 
            ttlLink = ET.SubElement(ttlDiv, "{http://www.w3.org/1999/xhtml}a")
            ttlLink.attrib["class"] = "download"
            ttlLink.attrib["href"] = ttllink
            ttlLink.attrib["download"] = ""
            ttlLink.attrib["target"] = "_blank"
            ttlLink.attrib["rel"] = "noopener noreferrer"
            ttlLink.text = "Download Turtle"

            # display text
            ttlPre = ET.SubElement(ttlDiv, "{http://www.w3.org/1999/xhtml}pre")
            ttlPre.text = ttltext


            with open(ntpath) as f:
                nttext = f.read()
            ntDiv = ET.Element("{http://www.w3.org/1999/xhtml}div")
            ntDiv.attrib["id"] = "nt"
            ntDiv.attrib["class"] = "tabcontent"

            # download link 
            ntLink = ET.SubElement(ntDiv, "{http://www.w3.org/1999/xhtml}a")
            ntLink.attrib["class"] = "download"
            ntLink.attrib["href"] = ntlink
            ntLink.attrib["download"] = ""
            ntLink.attrib["target"] = "_blank"
            ntLink.attrib["rel"] = "noopener noreferrer"
            ntLink.text = "Download N-Triples"

            #display text
            ntPre = ET.SubElement(ntDiv, "{http://www.w3.org/1999/xhtml}pre")
            ntPre.text = nttext

            
            with open(jsonpath) as f:
                jsontext = f.read()
            jsonDiv = ET.Element("{http://www.w3.org/1999/xhtml}div")
            jsonDiv.attrib["id"] = "json"
            jsonDiv.attrib["class"] = "tabcontent"

            # download link 
            jsonLink = ET.SubElement(jsonDiv, "{http://www.w3.org/1999/xhtml}a")
            jsonLink.attrib["class"] = "download"
            jsonLink.attrib["href"] = jsonlink
            jsonLink.attrib["download"] = ""
            jsonLink.attrib["target"] = "_blank"
            jsonLink.attrib["rel"] = "noopener noreferrer"
            jsonLink.text = "Download JSON-LD"

            # display text
            jsonPre = ET.SubElement(jsonDiv, "{http://www.w3.org/1999/xhtml}pre")
            jsonPre.text = jsontext

            hr.addprevious(rdfDiv)
            hr.addprevious(ttlDiv)
            hr.addprevious(ntDiv)
            hr.addprevious(jsonDiv)
    
    ET.indent(root, '    ')
    tree.write("../uwlswd_vocabs/test_format.html", method="html", encoding="UTF-8", pretty_print = True)
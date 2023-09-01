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
            rdfPre = ET.SubElement(rdfDiv, "{http://www.w3.org/1999/xhtml}pre")
            rdfPre.text = rdftext

            with open(ttlpath) as f:
                ttltext = f.read()
            ttlDiv = ET.Element("{http://www.w3.org/1999/xhtml}div")
            ttlDiv.attrib["id"] = "ttl"
            ttlDiv.attrib["class"] = "tabcontent"
            ttlPre = ET.SubElement(ttlDiv, "{http://www.w3.org/1999/xhtml}pre")
            ttlPre.text = ttltext


            with open(ntpath) as f:
                nttext = f.read()
            ntDiv = ET.Element("{http://www.w3.org/1999/xhtml}div")
            ntDiv.attrib["id"] = "nt"
            ntDiv.attrib["class"] = "tabcontent"
            ntPre = ET.SubElement(ntDiv, "{http://www.w3.org/1999/xhtml}pre")
            ntPre.text = nttext

            
            with open(jsonpath) as f:
                jsontext = f.read()
            jsonDiv = ET.Element("{http://www.w3.org/1999/xhtml}div")
            jsonDiv.attrib["id"] = "json"
            jsonDiv.attrib["class"] = "tabcontent"
            jsonPre = ET.SubElement(jsonDiv, "{http://www.w3.org/1999/xhtml}pre")
            jsonPre.text = jsontext

            hr.addprevious(rdfDiv)
            hr.addprevious(ttlDiv)
            hr.addprevious(ntDiv)
            hr.addprevious(jsonDiv)
    
    ET.indent(root, '    ')
    tree.write(filepath, method="html", encoding="UTF-8", pretty_print = True)
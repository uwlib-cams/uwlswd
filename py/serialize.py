# Function for serializing dataset/vocabulary
# set up to accept input as rdf/xml, nt, ttl, or json-ld and
# produces rdf/xml, nt, ttl, and json-ld formats
# however, currently only run for rdf from main.py 

import rdflib
from textwrap import dedent
import os

## returns doi for generated dct:hasFormat
def get_doi(graph):
    i = 0
    doi = ""
    while i < 1:
        for s, p, o in graph.triples((None, rdflib.URIRef("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"), None)):
            if ("http://www.w3.org/2004/02/skos/core#ConceptScheme" in o) or ("http://rdfs.org/ns/void#Dataset" in o):
                 doi = s
                 i = i + 1

        if doi == "":
            print("resource must contain a rdf:type triple with object http://www.w3.org/2004/02/skos/core#ConceptScheme or http://rdfs.org/ns/void#Dataset")
            exit()

    return doi

# adds all four dct:hasFormat triples - resetting the graph 
def reset_hasFormat(graph, uri_path):
    doi = get_doi(graph)

    dct_hasFormat = rdflib.URIRef("http://purl.org/dc/terms/hasFormat")

    if (doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.rdf")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.rdf")))
    if (doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.ttl")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.ttl")))
    if (doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.nt")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.nt")))
    if (doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.jsonld")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.jsonld")))
    if (doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.html")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{uri_path}.html")))

# removes dct:hasFormat of the current format
# e.g. if serializing rdf, removes the dct:hasFormat with the rdf file as the object
def fix_hasFormat(new_format, graph, uri_path):
    reset_hasFormat(graph, uri_path)

    doi = get_doi(graph)
    base_uri = rdflib.URIRef(uri_path)
    doi_uri = rdflib.URIRef(doi)
    dct_hasFormat = rdflib.URIRef("http://purl.org/dc/terms/hasFormat")
    new_file = rdflib.URIRef(f"{base_uri}.{new_format}")

    graph.remove((doi_uri, dct_hasFormat, new_file))


# this function processes data as rdflib graph and parses to all formats, adding dct:hasFormat
# serializations are saved in the same location as the input file

def serialize(file_path, file_name, uri_path):

    # file path w/o extension
    file_path_noext = file_path.rsplit('.', 1)[0]

    # generate rdflib graph
    g = rdflib.Graph().parse(file_path)

    # bind namespaces
    for ns_prefix, namespace in g.namespaces():
        g.bind(ns_prefix, namespace)

    def format_rdf(g, uri_path):
        fix_hasFormat("rdf", g, uri_path)
        rdf = g.serialize(format='xml')
        path = file_path_noext + "." + "rdf"
        file = open(path, 'w')
        file.write(rdf)
        file.close()
        print("    " + file_name + "." + "rdf" + " generated")

    def format_nt(g, uri_path):
        fix_hasFormat("nt", g, uri_path)
        nt = g.serialize(format='nt')
        path = file_path_noext + "." + "nt"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print("    " + file_name + "." + "nt" + " generated")

    
    def format_ttl(g, uri_path):
        fix_hasFormat("ttl", g, uri_path)
        turtle = g.serialize(format='turtle')
        path = file_path_noext + "." + "ttl"
        file = open(path, 'w')
        file.write(turtle)
        file.close()
        print("    " + file_name + "." + "ttl" + " generated")


    def format_jsonld(g, uri_path):
        fix_hasFormat("jsonld", g, uri_path)
        jsonld = g.serialize(format='json-ld')
        path = file_path_noext + "." + "jsonld"
        file = open(path, 'w')
        file.write(jsonld)
        file.close()
        print("    " + file_name + "." + "jsonld" + " generated")
    
    format_rdf(g, uri_path)
    format_nt(g, uri_path)
    format_ttl(g, uri_path)
    format_jsonld(g, uri_path)

# onlySerialize can be run from this script to produce all serializations
# except an html-rdfa serialization
def only_serialize():
    file_prompt = dedent("""Enter the path of the file relative to the working directory. 
    The file must have the extenstion ".rdf", ".ttl", ".jsonld", or ".nt"
    For example: '../uwlswd_vocabs/newspaper_genre_list.ttl'
    > """)
    file_path = input(file_prompt)

    if not(os.path.exists(file_path)):
        exit()
    
    # get format - CHECK
    format = file_path.rsplit(".", 1)[1]
    if format not in ["jsonld","rdf","ttl","nt"]:
        print("Error: file is not one of the accepted formats")
        exit(0)
    
    # remove extension
    ext = "." + format
    file_path_noext = file_path.replace(ext, "")
    
    # get uri path - assumes top-level directory for file is parallel to uwlswd directory
    uri_path = "https://uwlib-cams.github.io/" + file_path_noext.replace("../", "")

    # gets file name - splits string at furthest / and takes string to the right
    file_name = file_path_noext.rsplit("/", 1)[1]

    print(dedent(f"""{'=' * 20}
SERIALIZING DATA
{'=' * 20}"""))

    serialize(file_path, file_name, uri_path)

# only_serialize()


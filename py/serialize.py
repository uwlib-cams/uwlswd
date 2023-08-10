# Function for serializing dataset/vocabulary
# set up to accept input as rdf/xml, nt, ttl, or json-ld and
# produces rdf/xml, nt, ttl, and json-ld formats
# however, currently only run for rdf from main.py 

import rdflib
from textwrap import dedent
import os

## returns doi for generated dct:hasFormat
def get_doi(graph):
    # get doi - why is this so difficult 
    i = 0
    while i < 1:
        for s, p, o in graph.triples((None, rdflib.URIRef("http://purl.org/dc/terms/hasFormat"), None)):
            doi = s
            i = i + 1
    
    return doi

## returns base uri for generating dct:hasFormat
def get_object(graph, doi):
    doi_uri = rdflib.URIRef(doi)
    dct_hasFormat = rdflib.URIRef("http://purl.org/dc/terms/hasFormat")
    base_uri = graph.value(subject=doi_uri, predicate=dct_hasFormat, object=None, any=True)
    base_uri = base_uri.rsplit(".",1)[0]
    return base_uri

# adds all four dct:hasFormat triples - resetting the graph 
def reset_hasFormat(graph):
    doi = get_doi(graph)
    base_uri = get_object(graph, doi)
    dct_hasFormat = rdflib.URIRef("http://purl.org/dc/terms/hasFormat")

    if (doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.rdf")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.rdf")))
    if (doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.ttl")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.ttl")))
    if (doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.nt")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.nt")))
    if (doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.jsonld")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.jsonld")))
    if (doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.html")) not in graph:
        graph.add((doi, dct_hasFormat, rdflib.URIRef(f"{base_uri}.html")))

# removes dct:hasFormat of the current format
# e.g. if serializing rdf, removes the dct:hasFormat with the rdf file as the object
def fix_hasFormat(new_format, graph):
    reset_hasFormat(graph)

    doi = get_doi(graph)
    base_uri = get_object(graph, doi)
    doi_uri = rdflib.URIRef(doi)
    dct_hasFormat = rdflib.URIRef("http://purl.org/dc/terms/hasFormat")
    new_file = rdflib.URIRef(f"{base_uri}.{new_format}")

    graph.remove((doi_uri, dct_hasFormat, new_file))


# this function processes data as rdflib graph and parses to missing formats
# serializations are saved in the same location as the inputted file
# note: does not fix dct:hasFormat in initial file 
def serialize(format, file_path, directory, file_name):
    g = rdflib.Graph().parse(file_path)

    for ns_prefix, namespace in g.namespaces():
        g.bind(ns_prefix, namespace)

    if format != "rdf":
        fix_hasFormat("rdf", g)
        rdf = g.serialize(format='xml')
        path = directory + file_name + "." + "rdf"
        file = open(path, 'w')
        file.write(rdf)
        file.close()
        print("    " + file_name + "." + "rdf" + " generated")

    if format != "nt":
        fix_hasFormat("nt", g)
        nt = g.serialize(format='nt')
        path = directory + file_name + "." + "nt"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print("    " + file_name + "." + "nt" + " generated")

    
    if format != "ttl":
        fix_hasFormat("ttl", g)
        turtle = g.serialize(format='turtle')
        path = directory + file_name + "." + "ttl"
        file = open(path, 'w')
        file.write(turtle)
        file.close()
        print("    " + file_name + "." + "ttl" + " generated")


    if format != "jsonld":
        fix_hasFormat("jsonld", g)
        jsonld = g.serialize(format='json-ld')
        path = directory + file_name + "." + "jsonld"
        file = open(path, 'w')
        file.write(jsonld)
        file.close()
        print("    " + file_name + "." + "jsonld" + " generated")

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
    
    # process file path for separate variables 
    split = file_path.split("/")

    directory = ""
    while len(split) > 1:
            directory = directory + split.pop(0) + "/"

    split = split[0].split(".")
    format = split.pop()
    file_name = split.pop()

    if format not in ["jsonld","rdf","ttl","nt"]:
        print("Error: file is not one of the accepted formats")
        exit(0)

    print(dedent(f"""{'=' * 20}
SERIALIZING DATA
{'=' * 20}"""))

    serialize(format, file_path, directory, file_name)

#only_serialize()


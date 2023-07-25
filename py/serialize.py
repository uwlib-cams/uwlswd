# Function for serializing dataset/vocabulary
# Produces rdf/xml, nt, ttl, and json-ld formats

import rdflib

def get_object(graph, doi):
    doi_uri = rdflib.URIRef(doi)
    dct_hasFormat = rdflib.URIRef("http://purl.org/dc/terms/hasFormat")
    base_url = graph.value(subject=doi_uri, predicate=dct_hasFormat, object=None, any=True)
    base_url = base_url.rsplit(".",1)[0]
    return base_url

def get_doi(graph):
    # get doi - why is this so difficult 
    i = 0
    while i < 1:
        for s, p, o in graph.triples((None, rdflib.URIRef("http://purl.org/dc/terms/hasFormat"), None)):
            doi = s
            i = i + 1
    
    return doi

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

def fix_hasFormat(new_format, graph):
    reset_hasFormat(graph)

    doi = get_doi(graph)
    base_uri = get_object(graph, doi)
    doi_uri = rdflib.URIRef(doi)
    dct_hasFormat = rdflib.URIRef("http://purl.org/dc/terms/hasFormat")
    new_file = rdflib.URIRef(f"{base_uri}.{new_format}")

    graph.remove((doi, dct_hasFormat, new_file))


# this function processes data as rdflib graph and parses to missing formats
# serializations are saved in the same location as the inputted file
# note: does not fix has_Format in initial file 
def serialize(format, file_path, directory, file_name):
    g = rdflib.Graph(bind_namespaces="rdflib").parse(file_path)

    if format != "rdf":
        fix_hasFormat("rdf", g)
        rdf = g.serialize(format='xml')
        path = directory + file_name + "." + "rdf"
        file = open(path, 'w')
        file.write(rdf)
        file.close()
        print(file_name + "." + "rdf" + " generated")

    if format != "nt":
        fix_hasFormat("nt", g)
        nt = g.serialize(format='nt')
        path = directory + file_name + "." + "nt"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print(file_name + "." + "nt" + " generated")

    
    if format != "ttl":
        fix_hasFormat("ttl", g)
        turtle = g.serialize(format='turtle')
        path = directory + file_name + "." + "ttl"
        file = open(path, 'w')
        file.write(turtle)
        file.close()
        print(file_name + "." + "ttl" + " generated")


    if format != "jsonld":
        fix_hasFormat("jsonld", g)
        jsonld = g.serialize(format='json-ld')
        path = directory + file_name + "." + "jsonld"
        file = open(path, 'w')
        file.write(jsonld)
        file.close()
        print(file_name + "." + "jsonld" + " generated")
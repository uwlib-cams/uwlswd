# Function for serializing dataset/vocabulary
# Produces rdf/xml, nt, ttl, and json-ld formats

import rdflib

# this function processes data as rdflib graph and parses to missing formats
# serializations are saved in the same location as the inputted file
def serialize(format, file_path, directory, file_name):
    g = rdflib.Graph().parse(file_path)

    if format != "rdf":
        nt = g.serialize(format='xml')
        path = directory + file_name + "." + "rdf"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print(file_name + "." + "rdf" + " generated")

    if format != "nt":
        nt = g.serialize(format='nt')
        path = directory + file_name + "." + "nt"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print(file_name + "." + "nt" + " generated")

    
    if format != "ttl":
        turtle = g.serialize(format='turtle')
        path = directory + file_name + "." + "ttl"
        file = open(path, 'w')
        file.write(turtle)
        file.close()
        print(file_name + "." + "ttl" + " generated")


    if format != "json":
        nt = g.serialize(format='json-ld')
        path = directory + file_name + "." + "jsonld"
        file = open(path, 'w')
        file.write(nt)
        file.close()
        print(file_name + "." + "jsonld" + " generated")

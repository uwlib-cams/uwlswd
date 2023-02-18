import rdflib


g1 = rdflib.Graph().parse("../uwlswd_vocabs/newspaperGenreList.ttl", format="turtle")
g2 = rdflib.Graph().parse("../uwlswd_vocabs/newspaperGenreList.nt", format="nt")
g3 = rdflib.Graph().parse("../uwlswd_vocabs/newspaperGenreList.json", format="json-ld")
g4 = rdflib.Graph().parse("../uwlswd_vocabs/newspaperGenreList.rdf", format="xml")


#result = g1.parse("../uwlswd_vocabs/newspaperGenreList.ttl", format="turtle")

# print the number of "triples" in the Graph
print("The Turtle graph has {} statements.".format(len(g1)))
print("The NTriples graph has {} statements.".format(len(g2)))
print("The JSON-LD graph has {} statements.".format(len(g3)))
print("The RDF/XML graph has {} statements.".format(len(g4)))
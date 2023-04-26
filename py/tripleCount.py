import rdflib


g1 = rdflib.Graph().parse("./uwlswd_vocabs/newspaper_genre_list.ttl", format="turtle")
g2 = rdflib.Graph().parse("./uwlswd_vocabs/newspaper_genre_list.nt", format="nt")
g3 = rdflib.Graph().parse("./uwlswd_vocabs/newspaper_genre_list.json", format="json-ld")
g4 = rdflib.Graph().parse("./uwlswd_vocabs/newspaper_genre_list.rdf", format="xml")


#result = g1.parse("../uwlswd_vocabs/newspaperGenreList.ttl", format="turtle")

# print the number of "triples" in the Graph
print("The Turtle graph has {} statements.".format(len(g1)))
print("The NTriples graph has {} statements.".format(len(g2)))
print("The JSON-LD graph has {} statements.".format(len(g3)))
print("The RDF/XML graph has {} statements.".format(len(g4)))
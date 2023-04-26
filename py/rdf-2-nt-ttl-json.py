import rdflib

g = rdflib.Graph()

xml = g.parse("../uwlswd_vocabs/newspaper_genre_list.rdf", format="xml")


nt = xml.serialize(format='nt')
turtle = xml.serialize(format='turtle')
json = xml.serialize(format='json-ld')

file = open('../uwlswd_vocabs/newspaper_genre_list.nt', 'w')
file.write(nt)
file.close()

file = open('../uwlswd_vocabs/newspaper_genre_list.ttl', 'w')
file.write(turtle)
file.close()

file = open('../uwlswd_vocabs/newspaper_genre_list.json', 'w')
file.write(json)
file.close()


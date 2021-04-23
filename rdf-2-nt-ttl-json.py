import rdflib

g = rdflib.Graph()

xml = g.parse("../uwlswd_vocabs/newspaperGenreList.rdf", format="xml")


nt = xml.serialize(format='nt')
turtle = xml.serialize(format='turtle')
json = xml.serialize(format='json-ld')

file = open('../uwlswd_vocabs/newspaperGenreList.nt', 'wb')
file.write(nt)
file.close()

file = open('../uwlswd_vocabs/newspaperGenreList.ttl', 'wb')
file.write(turtle)
file.close()

file = open('../uwlswd_vocabs/newspaperGenreList.json', 'wb')
file.write(json)
file.close()


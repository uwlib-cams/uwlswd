import rdflib

g = rdflib.Graph()

turtle = g.parse("../uwlswd_vocabs/newspaperGenreList.ttl", format="turtle")

json = turtle.serialize(format='json-ld')
nt = turtle.serialize(format='nt')

file = open('../uwlswd_vocabs/newspaperGenreList.json', 'wb')
file.write(json)
file.close()

file = open('../uwlswd_vocabs/ngl.newspaperGenreList', 'wb')
file.write(nt)
file.close()
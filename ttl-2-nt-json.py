import rdflib

g = rdflib.Graph()

turtle = g.parse("../uwlswd_vocabs/ngl.ttl", format="turtle")

json = turtle.serialize(format='json-ld')
nt = turtle.serialize(format='nt')

file = open('../uwlswd_vocabs/ngl.json', 'wb')
file.write(json)
file.close()

file = open('../uwlswd_vocabs/ngl.nt', 'wb')
file.write(nt)
file.close()
import rdflib
import os

g = rdflib.Graph()

turtle = g.parse("../uwlswd_vocabs/newspaper_genre_list.ttl", format="turtle")

json = turtle.serialize(format='json-ld')
nt = turtle.serialize(format='nt')

file = open('../uwlswd_vocabs/newspaper_genre_list.json', 'w')
file.write(json)
file.close()

file = open('../uwlswd_vocabs/newspaper_genre_list.nt', 'w')
file.write(nt)
file.close()
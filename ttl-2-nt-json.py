import rdflib
import os

g = rdflib.Graph()

turtle = g.parse("../uwlswd_vocabs/newspaperGenreList.ttl", format="turtle")

json = turtle.serialize(format='json-ld')
nt = turtle.serialize(format='nt')

if os.path.exists('../uwlswd_vocabs/newspaperGenreList.json'):
    os.remove('../uwlswd_vocabs/newspaperGenreList.json')

if os.path.exists('../uwlswd_vocabs/newspaperGenreList.nt'):
    os.remove('../uwlswd_vocabs/newspaperGenreList.nt')

file = open('../uwlswd_vocabs/newspaperGenreList.json', 'wb')
file.write(json)
file.close()

file = open('../uwlswd_vocabs/newspaperGenreList.nt', 'wb')
file.write(nt)
file.close()
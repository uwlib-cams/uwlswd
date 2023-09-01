import rdflib

g = rdflib.Graph()

xml = g.parse("../../uwlswd_vocabs_marc_006_008/008/continuing_form_of_original_item/continuing_form_of_original_item.rdf", format="xml")


nt = xml.serialize(format='nt')
turtle = xml.serialize(format='turtle')
json = xml.serialize(format='json-ld')

file = open('../../uwlswd_vocabs_marc_006_008/008/continuing_form_of_original_item/continuing_form_of_original_item.nt', 'w')
file.write(nt)
file.close()

file = open('../../uwlswd_vocabs_marc_006_008/008/continuing_form_of_original_item/continuing_form_of_original_item.ttl', 'w')
file.write(turtle)
file.close()

file = open('../../uwlswd_vocabs_marc_006_008/008/continuing_form_of_original_item/continuing_form_of_original_item.json', 'w')
file.write(json)
file.close()
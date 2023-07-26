import rdflib

g = rdflib.Graph()

xml = g.parse("../../uwlswd_datasets/void_description_of_the_dataset_university_of_washington_libraries_semantic_web_data.rdf", format="xml")


nt = xml.serialize(format='nt')
turtle = xml.serialize(format='turtle')
json = xml.serialize(format='json-ld')

file = open('../../uwlswd_datasets/void_description_of_the_dataset_university_of_washington_libraries_semantic_web_data.nt', 'w')
file.write(nt)
file.close()

file = open('../../uwlswd_datasets/void_description_of_the_dataset_university_of_washington_libraries_semantic_web_data.ttl', 'w')
file.write(turtle)
file.close()

file = open('../../uwlswd_datasets/void_description_of_the_dataset_university_of_washington_libraries_semantic_web_data.json', 'w')
file.write(json)
file.close()
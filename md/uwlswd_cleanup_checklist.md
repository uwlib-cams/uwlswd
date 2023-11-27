# CLEANUP CHECKLIST

- [ ] Delete any incorrect `dct:hasFormat` triples
- [ ] Delete any incorrect `dct:format` triples
- [ ] Replace incorrect prop `owl:version` with `schema:version`
- [ ] Confirm dct:description exists, proofread, draft if doesn't exist
- [ ] Namespace prefixes
   - [ ] Confirm that the schema.org namespace is `https://schema.org/` (not `http`)
   - [ ] Replace `dcterms` prefix with `dct`
- [ ] Check agent triples - dc:creator, dct:creator, dc:publisher, dct:publisher, dc:contributor, and dct:contributor
   - dct:agent triples with IRI values are *always* preferred. dc:agent with a literal value should *only* be used if an IRI is not associated with that agent. 
   - There should only ever be one triple within a dataset that describes each agent. A dc:agent triple with a literal value and a dct:agent triple with an IRI value should never refer to the same agent. 
   - [ ] If an IRI is associated with that agent, replace dc:agent triples with dct:agent triples 
   - [ ] If an agent is described in the resource with both a dc:agent triple and a dct:agent triple, delete the dc:agent triple
   - [ ] Confirm that the agent is entered into agents.xml
- [ ] Add schema:disambiguatingDescription if needed - see [resourceType tab](https://docs.google.com/spreadsheets/d/1jKYPFzhE_iNsqrekX696_wFehq9NTM4v212J41jGv0s/edit#gid=1330494801)

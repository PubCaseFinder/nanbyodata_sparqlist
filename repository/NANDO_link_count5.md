# NANDO_link_count_5_pubchem

## Endpoint
https://rdfportal.org/pubchem/sparql

## `result1` shoman pubchem count
```sparql
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix cooccurrence: <http://rdf.ncbi.nlm.nih.gov/pubchem/cooccurrence/>
prefix sio: <http://semanticscience.org/resource/>
prefix vocab: <http://rdf.ncbi.nlm.nih.gov/pubchem/vocabulary#>
prefix disease: <http://rdf.ncbi.nlm.nih.gov/pubchem/disease/>
prefix compound: <http://rdf.ncbi.nlm.nih.gov/pubchem/compound/>
prefix ns6: <http://edamontology.org/>
Prefix skos: <http://www.w3.org/2004/02/skos/core#>
Prefix NANDO: <http://identifiers.org/NANDO:>
Prefix dcterms: <http://purl.org/dc/terms/>
Prefix pcvocab: <http://rdf.ncbi.nlm.nih.gov/pubchem/vocabulary#>

SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?cid) as ?pubchem)
WHERE{
  ?s skos:closeMatch|skos:relatedMatch ?nando
     FILTER (CONTAINS(STR(?nando), "http://identifiers.org/NANDO:2"))
  ?coid rdf:object ?s.
  ?coid rdf:subject ?cid.
  FILTER(contains(str(?cid),"CID"))
    }
```
## `result2` shitei pubchem count
```sparql
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix cooccurrence: <http://rdf.ncbi.nlm.nih.gov/pubchem/cooccurrence/>
prefix sio: <http://semanticscience.org/resource/>
prefix vocab: <http://rdf.ncbi.nlm.nih.gov/pubchem/vocabulary#>
prefix disease: <http://rdf.ncbi.nlm.nih.gov/pubchem/disease/>
prefix compound: <http://rdf.ncbi.nlm.nih.gov/pubchem/compound/>
prefix ns6: <http://edamontology.org/>
Prefix skos: <http://www.w3.org/2004/02/skos/core#>
Prefix NANDO: <http://identifiers.org/NANDO:>
Prefix dcterms: <http://purl.org/dc/terms/>
Prefix pcvocab: <http://rdf.ncbi.nlm.nih.gov/pubchem/vocabulary#>

SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?cid) as ?pubchem)
WHERE{
  ?s skos:closeMatch|skos:relatedMatch ?nando
     FILTER (CONTAINS(STR(?nando), "http://identifiers.org/NANDO:1"))
  ?coid rdf:object ?s.
  ?coid rdf:subject ?cid.
  FILTER(contains(str(?cid),"CID"))
    }
```

## Output
```javascript
({result1,result2}) => {
  const namedResults = {
    shoman_pubchem: result1,
    shitei_pubchem: result2,

      };

  const processed = {};

  for (const [name, result] of Object.entries(namedResults)) {
    const data = result.results.bindings[0];
    processed[name] = Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  }

  return processed;
}


```
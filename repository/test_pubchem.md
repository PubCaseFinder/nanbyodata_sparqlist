# Get chemical information
- Pubchemからの化合物データを取る

## Parameters

* `nando_id` NANDO ID
  * default: 2200381

## Endpoint

https://rdfportal.org/pubchem/sparql

## `result` 
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

SELECT DISTINCT ?s ?coid ?cid ?label ?id ?ref ?title
WHERE{
  ?s skos:closeMatch|skos:relatedMatch NANDO:{{nando_id}}  .
  ?coid rdf:object ?s.
  ?coid rdf:subject ?cid.
  ?cid skos:prefLabel ?label.
  ?cid dcterms:identifier ?id.
  FILTER(contains(str(?cid),"CID"))
  ?ref pcvocab:discussesAsDerivedByTextMining ?s, ?cid;
       dcterms:title ?title.
    }

```

## Output
```javascript

({ result }) => {
  let tree = [];
  let uniqueCheck = new Set();

  result.results.bindings.forEach(d => {
    tree.push({
      cid: d.cid.value,
      label: d.label.value,
      id: d.id.value,
      id_url: "https://pubchem.ncbi.nlm.nih.gov/compound/" + d.id.value,
      ref_url: d.ref.value,
      title: d.title.value,
      });

    uniqueCheck.add(d.label.value);
  });

  return tree;
};


```
## Description
- 2025/09/19 first version
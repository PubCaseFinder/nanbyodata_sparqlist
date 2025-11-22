# NANDO_link_count_3_brc


## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result1` shoman cell count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>


SELECT DISTINCT count(distinct ?ontology) as ?nando count(distinct  ?id) as ?cell 
FROM <http://metadb.riken.jp/db/xsearch_cell_brso>
WHERE {
  ?cell dct:identifier ?id;
    brso:donor ?donor.
    BIND (STR(?id) as ?id_plain)
 ?donor obo:RO_0000091 ?disease. # <http://purl.obolibrary.org/obo/RO_0000091>
  OPTIONAL {?disease rdfs:seeAlso ?ontology}
  FILTER (CONTAINS(STR(?ontology), "http://nanbyodata.jp/ontology/NANDO_2"))
}
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result2` shitei cell count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>


SELECT DISTINCT count(distinct ?ontology) as ?nando count(distinct  ?id) as ?cell 
FROM <http://metadb.riken.jp/db/xsearch_cell_brso>
WHERE {
  ?cell dct:identifier ?id;
    brso:donor ?donor.
    BIND (STR(?id) as ?id_plain)
 ?donor obo:RO_0000091 ?disease. # <http://purl.obolibrary.org/obo/RO_0000091>
  OPTIONAL {?disease rdfs:seeAlso ?ontology}
  FILTER (CONTAINS(STR(?ontology), "http://nanbyodata.jp/ontology/NANDO_1"))
}
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result3` shoman dna count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?o) as ?nando count(distinct  ?id) as ?gene
WHERE {
    GRAPH <http://metadb.riken.jp/db/dna_diseaseID> {
    ?dna <http://purl.obolibrary.org/obo/RO_0003301> ?o.
      FILTER (CONTAINS(STR(?o), "http://nanbyodata.jp/ontology/NANDO_2"))
        }
  GRAPH <http://metadb.riken.jp/db/xsearch_dnabank_brso> {
    ?dna dct:identifier ?id.       
        }
      }

```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result4` shitei dna count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?o) as ?nando count(distinct  ?id) as ?gene
WHERE {
    GRAPH <http://metadb.riken.jp/db/dna_diseaseID> {
    ?dna <http://purl.obolibrary.org/obo/RO_0003301> ?o.
      FILTER (CONTAINS(STR(?o), "http://nanbyodata.jp/ontology/NANDO_1"))
        }
  GRAPH <http://metadb.riken.jp/db/xsearch_dnabank_brso> {
    ?dna dct:identifier ?id.       
        }
      }
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result5` shoman mouse count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?o) as ?nando count(distinct  ?id) as ?mouse
WHERE {
    GRAPH <http://metadb.riken.jp/db/mouse_diseaseID> {
    ?dna <http://purl.obolibrary.org/obo/RO_0003301> ?o.
      FILTER (CONTAINS(STR(?o), "http://nanbyodata.jp/ontology/NANDO_2"))
          }
  GRAPH <http://metadb.riken.jp/db/xsearch_animal_brso> {
    ?dna dct:identifier ?id.       
          }
       }
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result6` shitei mouse count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?o) as ?nando count(distinct  ?id) as ?mouse
WHERE {
    GRAPH <http://metadb.riken.jp/db/mouse_diseaseID> {
    ?dna <http://purl.obolibrary.org/obo/RO_0003301> ?o.
      FILTER (CONTAINS(STR(?o), "http://nanbyodata.jp/ontology/NANDO_1"))
          }
  GRAPH <http://metadb.riken.jp/db/xsearch_animal_brso> {
    ?dna dct:identifier ?id.       
          }
       }


```
## Output
```javascript

({result1, result2, result3, result4, result5, result6}) => {
  const namedResults = {
    shoman_cell: result1,
    shitei_cell: result2,
    shoman_DNA: result3,
    shitei_DNA: result4,
    shoman_mouse: result5,
    shitei_mouse: result6,
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
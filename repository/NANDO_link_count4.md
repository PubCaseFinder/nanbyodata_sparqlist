# NANDO_link_count_4_GM&Hum&CuratedGene

## Endpoint
https://nanbyodata.jp/sparql

## `result1` shoman GM count
```sparql
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix gm: <https://db.gestaltmatcher.org/patients/>
prefix obo: <http://purl.obolibrary.org/obo/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix : <http://nanbyodata.jp/ontology/NANDO_>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix sio: <http://semanticscience.org/resource/>


SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?person) as ?GM)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  # NANDO → MONDO → OMIM
  ?nando skos:exactMatch ?mondo .
   FILTER (CONTAINS(STR(?nando), "http://nanbyodata.jp/ontology/NANDO_2"))
  
  ?mondo skos:exactMatch ?exactMatch_disease .
   FILTER(STRSTARTS(STR(?exactMatch_disease), "https://omim.org/entry/"))
  
  # GM 側（ブランクノードを介して person と接続）
  ?b1 rdfs:seeAlso ?exactMatch_disease.
  ?person sio:SIO_001279 ?b1 .
  }
``` 

## `result2` shitei GM count
```sparql

prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix gm: <https://db.gestaltmatcher.org/patients/>
prefix obo: <http://purl.obolibrary.org/obo/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix : <http://nanbyodata.jp/ontology/NANDO_>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix sio: <http://semanticscience.org/resource/>

SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?person) as ?GM)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  # NANDO → MONDO → OMIM
  ?nando skos:exactMatch ?mondo .
   FILTER (CONTAINS(STR(?nando), "http://nanbyodata.jp/ontology/NANDO_1"))
  
  ?mondo skos:exactMatch ?exactMatch_disease .
   FILTER(STRSTARTS(STR(?exactMatch_disease), "https://omim.org/entry/"))
  
  # GM 側（ブランクノードを介して person と接続）
  ?b1 rdfs:seeAlso ?exactMatch_disease.
  ?person sio:SIO_001279 ?b1 .
  }
```

## `result3` shoman hum count
```sparql

PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX hum: <https://humandbs.dbcls.jp/>
PREFIX mondo: <http://purl.obolibrary.org/obo/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio: <http://semanticscience.org/resource/>

SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?hum_id) as ?hum)
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?hum_uri rdfs:seeAlso ?nando
     FILTER (CONTAINS(STR(?nando), "http://nanbyodata.jp/ontology/NANDO_2"))
  ?hum_uri a sio:SIO_000756 ;
            dcterms:identifier ?hum_id .
}
```
## `result4` shitei hum count
```sparql

PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX hum: <https://humandbs.dbcls.jp/>
PREFIX mondo: <http://purl.obolibrary.org/obo/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio: <http://semanticscience.org/resource/>

SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?hum_id) as ?hum)
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?hum_uri rdfs:seeAlso ?nando
     FILTER (CONTAINS(STR(?nando), "http://nanbyodata.jp/ontology/NANDO_1"))
  ?hum_uri a sio:SIO_000756 ;
            dcterms:identifier ?hum_id .
}
```
## `result5` shoman curated gene count
```sparql

PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX sio: <http://semanticscience.org/resource/>

SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?label) as ?curatedGene)
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?nando  sio:SIO_000352 ?blank.
   FILTER (CONTAINS(STR(?nando), "http://nanbyodata.jp/ontology/NANDO_2"))
  ?blank rdfs:label ?label.
          }
```
## `result6` shitei curated gene count
```sparql

PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX sio: <http://semanticscience.org/resource/>

SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?label) as ?curatedGene)
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?nando  sio:SIO_000352 ?blank.
   FILTER (CONTAINS(STR(?nando), "http://nanbyodata.jp/ontology/NANDO_1"))
  ?blank rdfs:label ?label.
          }
```
## Output
```javascript
({result1,result2,result3,result4,result5,result6}) => {
  const namedResults = {
    shoman_gm: result1,
    shitei_gm: result2,
    shoman_hum: result3,
    shitei_hum: result4,
    shoman_CG: result5,
    shitei_CG: result6
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
# Get reference gene
- マニュアルキュレーションをした遺伝子を表示するためのAPI

## Parameters

* `nando_id` NANDO ID
  * default: 1200489 
  * example: 2200856

## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result` 
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

SELECT DISTINCT
?label ?gene ?gene2 ?gene_name ?gene_desc
FROM <https://nanbyodata.jp/rdf/nanbyodata>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
  nando:1200235  sio:SIO_000352 ?blank.
  ?blank rdfs:label ?label;
         rdfs:seeAlso ?gene.
FILTER(CONTAINS(STR(?gene), "http://identifiers.org/ncbigene/"))
   ?blank rdfs:seeAlso ?gene2.
FILTER(CONTAINS(STR(?gene2), "https://www.genenames.org/data/gene-symbol-report/#!/hgnc_id/HGNC:"))
  ?gene dcterms:description ?gene_name;
        obo:NCIT_C42581 ?gene_desc.

  }


```

## Output
```javascript
({result})=>{ 
  return result.results.bindings.map(data => {
    return Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  });
}
```
## Description
- 2025/06/23 名称変更
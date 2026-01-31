# Get phenotype list data　疾患症状の一覧

## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `phenotype` get mondo_id correspoinding to nando_id

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX oa: <http://www.w3.org/ns/oa#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT DISTINCT ?nando_id ?nando_uri ?nando_label_ja ?nando_label_en ?hpo ?hpo_id ?hpo_label_en ?hpo_label_ja
FROM <https://nanbyodata.jp/rdf/ontology/hp>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
  ?an a oa:Annotation ;
      oa:hasBody ?hpo ;
      oa:hasTarget [ rdfs:seeAlso ?mondo_uri ] ;
      dcterms:source [ dcterms:creator ?creator ] .

  FILTER(?creator NOT IN ("Database Center for Life Science"))

  ?hpo oboInOwl:id ?hpo_id ;
       obo:IAO_0000115 ?definition .

  OPTIONAL {?hpo rdfs:label ?hpo_label_ja . FILTER(lang(?hpo_label_ja) = "ja") }
  OPTIONAL {?hpo rdfs:label ?hpo_label_en . FILTER(lang(?hpo_label_en) = "") }

  ?nando_uri (skos:exactMatch|skos:closeMatch) ?mondo_uri ;
            dcterms:identifier ?nando_id .

  OPTIONAL { ?nando_uri rdfs:label ?nando_label_ja . FILTER(lang(?nando_label_ja) = "ja") }
  OPTIONAL { ?nando_uri rdfs:label ?nando_label_en . FILTER(lang(?nando_label_en) = "en") }
}
ORDER BY ?nando_id


```
## Output

```javascript
({phenotype})=>{ 
  return phenotype.results.bindings.map(data => {
    return Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  });
}

```
## Description
- 2026/01/30 編集中　高月
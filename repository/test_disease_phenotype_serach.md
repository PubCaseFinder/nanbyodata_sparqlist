# get_disease_list_by_Phenotype_search
## Parameters
* `hp_id` HPO ID
  * default: HP:0000093
  * example: 
  -testtes
  
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `search` 

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX oa: <http://www.w3.org/ns/oa#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX HP: <http://purl.obolibrary.org/obo/HP_>

SELECT DISTINCT ?nando_id ?nando_uri ?nando_label_ja ?nando_label_en
FROM <https://nanbyodata.jp/rdf/ontology/hp>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
?an rdf:type oa:Annotation ;
    oa:hasBody {{hp_id}} ;
    oa:hasTarget [ rdfs:seeAlso ?mondo_uri ] ;
    dcterms:source [ dcterms:creator ?creator ] .
FILTER(?creator NOT IN ("Database Center for Life Science"))
?nando_uri (skos:exactMatch|skos:closeMatch) ?mondo_uri .
?nando_uri dcterms:identifier ?nando_id .
OPTIONAL { ?nando_uri rdfs:label ?nando_label_ja . FILTER(lang(?nando_label_ja) = "ja") }
OPTIONAL { ?nando_uri rdfs:label ?nando_label_en . FILTER(lang(?nando_label_en) = "en") }
}
ORDER BY ?nando_id
```
## Output
```javascript
({search})=>{ 
  return search.results.bindings.map(data => {
    return Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  });
}
```

## Description
- 検索用のAPI（表現型）2026/01/27 高月
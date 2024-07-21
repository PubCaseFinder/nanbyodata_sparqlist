# NANDOの下位概念を検索する
## Parameters
* `nando_id` NANDO ID
  * default: 1200725
  * examples: 1200005
## Endpoint

https://dev-pubcasefinder.dbcls.jp/sparql/

## `result`
```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
SELECT *
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
  ?nando_sub rdfs:subClassOf* ?nando;
             dcterms:identifier ?id;
             rdfs:label ?nando_label;
             rdfs:label ?nando_englabel;
             rdfs:subClassOf ?nando_id.
  FILTER(lang(?nando_label)= "ja")        
  FILTER(lang(?nando_englabel)= "en")
 }
ORDER BY ?nando_id
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
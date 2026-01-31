# get_disease_list_by_group_search
## Parameters
* `nando_id` NANDO ID
  * default: 1100001
  * example: 1100002
  -1100001(神経・筋疾患）、1100002(代謝系疾患)
  
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `search` 

```sparql

PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT ?disease ?label_en ?label_ja ?id
WHERE {
  ?disease rdfs:subClassOf* nando:{{nando_id}} ;
           dcterms:identifier ?id;
           rdfs:label ?label_ja.
    FILTER(LANG(?label_ja) = 'ja')        
           
    OPTIONAL {
    ?disease rdfs:label ?label_en
    FILTER(LANG(?label_en) = 'en') 
    }

}
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
- 検索用のAPI（疾患群）2026/01/27 高月
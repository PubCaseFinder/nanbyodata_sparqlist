# get_disease_list_by_kokutibango_search_shitei

## Parameters
* `kokuchi_s` 
  * default: 1
* `kokuchi_f`
  * default: 10
  
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `search` 

```sparql
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT DISTINCT ?disease ?label_en ?label_ja ?id ?kokuchibango
WHERE {
  ?disease dcterms:identifier ?id;
           nando:hasNotificationNumber ?kokuchibango.
  FILTER(
  xsd:integer(?kokuchibango) >= {{kokuchi_s}} &&
  xsd:integer(?kokuchibango) <= {{kokuchi_f}})
  
  FILTER(REGEX(STR(?id), "NANDO:12"))
    
  ?disease rdfs:label ?label_ja.
    FILTER(LANG(?label_ja) = "ja")
           
    OPTIONAL {
    ?disease rdfs:label ?label_en.
    FILTER(LANG(?label_en) = 'en') 
    }
}
ORDER BY ?id
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
- 検索用のAPI（指定難病告知番号）値に範囲を指定する必要がある。kokushi-sが始まり、kokuchi-fが範囲の終わりの番号　2026/01/28 高月
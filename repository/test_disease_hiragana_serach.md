# get_disease_list_by_group_search
## Parameters
* `hiragana` 
  * default: あいうえお
  * example: かきくけこ
  -ひらがなでなくても、数値やアルファベットも大丈夫
  
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `search` 

```sparql
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX nando: <http://nanbyodata.jp/ontology/>

SELECT DISTINCT ?disease ?label_hira ?label_en ?label_ja ?id
WHERE {
  ?disease dcterms:identifier ?id;
           rdfs:label ?label_hira.
    FILTER(LANG(?label_hira) = 'ja-hira')  
   # 先頭が「あ行（あ・い・う・え・お）」のものだけ
    FILTER(REGEX(STR(?label_hira), "^[{{hiragana}}]"))
    ?disease rdfs:label ?label_ja.
    FILTER(LANG(?label_ja) = "ja")
           
    OPTIONAL {
    ?disease rdfs:label ?label_en.
    FILTER(LANG(?label_en) = 'en') 
    }
}
ORDER BY ?label_hira
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
- 検索用のAPI（ひらがな読み）2026/01/28 高月
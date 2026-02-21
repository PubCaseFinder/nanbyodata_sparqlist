# get_nando_list

  
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `search` 

```sparql

PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX oa: <http://www.w3.org/ns/oa#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX HP: <http://purl.obolibrary.org/obo/HP_>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT DISTINCT ?disease ?id ?label_ja ?label_en ?label_hira ?notification_number
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/hp>
FROM <https://nanbyodata.jp/rdf/pcf>

WHERE {
  ?disease a owl:Class ;
         dcterms:identifier ?id;
            rdfs:label ?label_ja.
    FILTER(LANG(?label_ja) = 'ja')
 OPTIONAL {
    ?disease rdfs:label ?label_en.
    FILTER(LANG(?label_en) = 'en') 
    }
 OPTIONAL {
      ?disease rdfs:label ?label_hira.
      FILTER(LANG(?label_hira) = 'ja-hira')
    }
   OPTIONAL {
      ?disease nando:hasNotificationNumber ?notification_number.
    }
}
GROUP BY
  ?disease ?id ?label_ja ?label_en ?label_hira ?notification_number

```
## Output

```javascript

({ search }) => {
  let tree = [];
  let uniqueCheck = new Set();

  // 指定(1)・小児慢性(2) 判定は残す
  const typeMap = { "1": "shitei", "2": "syoman" };

  search.results.bindings.forEach(d => {
    const id = d.id?.value ?? "";
    if (!id) return;

    // 重複スキップ（id単位）
    if (uniqueCheck.has(id)) return;
    uniqueCheck.add(id);

    const numeric = id.replace(/^NANDO:/, "");
    const prefix = numeric[0];
    const category = typeMap[prefix] ?? "other";

    tree.push({
      disease: d.disease?.value ?? "",                 // ?disease
      id: id,                                          // ?id (想定: "NANDO:xxxx")
      label_ja: d.label_ja?.value ?? "",               // ?label_ja
      label_en: d.label_en?.value ?? "",               // ?label_en
      label_hira: d.label_hira?.value ?? "",           // ?label_hira
      notification_number: d.notification_number?.value ?? "", // ?notification_number
      category: category
    });
  });

  return tree;
};



```


## Description
- 検索用のAPI 2026/02/16 高月
# Get Orphanet ID by NANDO ID
## Parameters
* `nando_id` NANDO ID
  * default: 2200053

## Endpoint

https://pubcasefinder-rdf.dbcls.jp/sparql

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

SELECT ?nando ?mondo ?mondo_id ?mondo_label_ja ?mondo_label_en ?exactMatch_disease ?property
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
  
  OPTIONAL {
    {
      ?nando skos:closeMatch ?mondo .
    }
    UNION
    {
      ?nando skos:exactMatch ?mondo .
    }
    ?nando ?property ?mondo.
    ?mondo oboInOwl:id ?mondo_id .
    ?mondo skos:exactMatch ?exactMatch_disease.
  }

  # 日本語ラベルの取得
  OPTIONAL {
    ?nando skos:closeMatch|skos:exactMatch ?mondo .
    ?mondo rdfs:label ?mondo_label_ja .
    FILTER (lang(?mondo_label_ja) = "ja")
  }

  # 英語ラベルの取得、または言語タグがない場合
  OPTIONAL {
    ?nando skos:closeMatch|skos:exactMatch ?mondo .
    ?mondo rdfs:label ?mondo_label_en .
    FILTER (lang(?mondo_label_en) = "en" || lang(?mondo_label_en) = "")
  } 

   FILTER (CONTAINS(STR(?exactMatch_disease), "http://www.orpha.net/ORDO/Orphanet_"))
}




```
## Output

```javascript

({ result }) => {
  const tree = [];

  if (!result?.results?.bindings) return tree;

  const replacePrefix = (value, prefix, replacement) =>
    value?.startsWith(prefix) ? value.replace(prefix, replacement) : value;

  const isDuplicate = (arr, criteria) => arr.some(item =>
    Object.keys(criteria).every(key => item[key] === criteria[key])
  );

  result.results.bindings.forEach(d => {
    const originalDisease = d.exactMatch_disease?.value ?? null;
    const modifiedDisease = replacePrefix(originalDisease, "http://www.orpha.net/ORDO/Orphanet_", "Orphanet:");
    const nando = replacePrefix(d.nando?.value, "http://nanbyodata.jp/ontology/NANDO_", "NANDO:");
    const mondo_id = d.mondo_id?.value ?? null;

    if (nando && mondo_id && originalDisease) {
      // 親ノードを追加する際に重複チェック
      if (!isDuplicate(tree, { id: nando, type: "parent" })) {
        tree.push({
          id: nando,
          uid: d.nando?.value ?? null,
          type: "parent",
        });
      }

      // 子ノードを追加する際に重複チェック
      if (!isDuplicate(tree, { parent: nando, id: mondo_id })) {
        tree.push({
          parent: nando,
          id: mondo_id,
          mondo_label_ja: d.mondo_label_ja?.value ?? null,
          mondo_label_en: d.mondo_label_en?.value ?? null,
          mondo_url: mondo_id.replace("MONDO:", "https://monarchinitiative.org/MONDO:"),
        });
      }

      // 原疾患ノードを追加
      if (!isDuplicate(tree, { id: modifiedDisease, parent: mondo_id })) {
        tree.push({
          id: modifiedDisease,
          displayid: modifiedDisease,
          mondolinki: d.mondo?.value ?? null,
          property: d.property?.value ?? null,
          parent: mondo_id,
          mondo_label_ja2: d.mondo_label_ja?.value ?? null,
          mondo_label_en2: d.mondo_label_en?.value ?? null,
          original_disease: replacePrefix(originalDisease, "http://www.orpha.net/ORDO/Orphanet_", "https://www.orpha.net/en/disease/detail/"),
        });
      }
    }
  });

  return tree;
};


```
## Description
- NanbyoDataでMONDOIDを経由してOrphanetIDを表示させるためのSPARQListです。2024/11/19 高月
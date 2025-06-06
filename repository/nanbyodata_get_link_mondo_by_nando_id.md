# Get MONDO ID by NANDO ID
## Parameters
* `nando_id` NANDO ID
  * default: 2200053

## Endpoint

https://nanbyodata.jp/sparql

## `result`
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT ?nando ?mondo ?mondo_id ?mondo_label_ja ?mondo_label_en ?property
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
OPTIONAL {
  ?nando skos:exactMatch | skos:closeMatch ?mondo ;
         ?property ?mondo.
  ?mondo oboInOwl:id ?mondo_id.

  # 日本語ラベルの取得
  OPTIONAL {
    ?mondo rdfs:label ?mondo_label_ja .
    FILTER (lang(?mondo_label_ja) = "ja")
  }

  # 英語ラベルの取得、または言語タグがない場合
  OPTIONAL {
    ?mondo rdfs:label ?mondo_label_en .
    FILTER (lang(?mondo_label_en) = "en" || lang(?mondo_label_en) = "")}
  }
}

```
## Output

```javascript

({ result }) => {
  let tree = [];

  if (result && result.results && result.results.bindings) {
    result.results.bindings.forEach(d => {
      let mondo_id = d.mondo_id ? d.mondo_id.value : null;

      // mondo_id が存在しない場合、JSON生成をスキップ
      if (mondo_id) {
        let nando = d.nando ? d.nando.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:") : null;

        let nandoNode = {
          id: nando, // 親ノード (nando)
          uid: d.nando ? d.nando.value : null,
          type: 'parent', // 親ノードであることを示す
        };

        // 重複チェック: `id` と `uid` が一致するものがないか確認
        let isNandoNodeExists = tree.some(
          node => node.id === nandoNode.id && node.uid === nandoNode.uid
        );

        // 重複がない場合のみ追加
        if (!isNandoNodeExists) {
          tree.push(nandoNode);
        }

        let mondoNode = {
          parent: nando, // nando の子として配置
          id: mondo_id, // 子ノード (mondo_id)
          displayid: mondo_id,
          property: d.property ? d.property.value : null,
          mondo_label_ja: d.mondo_label_ja ? d.mondo_label_ja.value : null,
          mondo_label_en: d.mondo_label_en ? d.mondo_label_en.value : null,
          mondo_url: mondo_id.replace("MONDO:", "https://monarchinitiative.org/MONDO:"),
        };

        tree.push(mondoNode);
      }
    });
  }

  return tree;
};


```
## Description
- NanbyoDataでMONDOIDを表示させるためのSPARQListです。2024/11/19 高月

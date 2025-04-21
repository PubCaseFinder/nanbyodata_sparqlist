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

SELECT ?nando ?kegg ?kegg_id ?kegg_label_ja ?kegg_label_en ?property
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .
OPTIONAL {
  ?nando oboInOwl:hasDbXref ?kegg ;
         ?property ?kegg.
  ?kegg dc:identifier ?kegg_id.

  # 日本語ラベルの取得
  OPTIONAL {
    ?kegg rdfs:label ?kegg_label_ja .
    FILTER (lang(?kegg_label_ja) = "ja")
  }

  # 英語ラベルの取得、または言語タグがない場合
  OPTIONAL {
    ?kegg rdfs:label ?kegg_label_en .
    FILTER (lang(?kegg_label_en) = "en" || lang(?kegg_label_en) = "")}
  }
}

```
## Output

```javascript

({ result }) => {
  let tree = [];

  if (result && result.results && result.results.bindings) {
    result.results.bindings.forEach(d => {
      let kegg_id = d.kegg_id ? d.kegg_id.value : null;

      // mondo_id が存在しない場合、JSON生成をスキップ
      if (kegg_id) {
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

        let keggNode = {
          parent: nando, // nando の子として配置
          id: kegg_id, // 子ノード (mondo_id)
          displayid: kegg_id,
          property: d.property ? d.property.value : null,
          kegg_label_ja: d.kegg_label_ja ? d.kegg_label_ja.value : null,
          kegg_label_en: d.kegg_label_en ? d.kegg_label_en.value : null,
          kegg_url: d.kegg ? d.kegg.value : null 
        };

        tree.push(keggNode);
      }
    });
  }

  return tree;
};


```
## Description
- NanbyoDataでKEGGIDを表示させるためのSPARQListです。2025/02/28 高月

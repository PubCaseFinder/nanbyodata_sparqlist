# Get OMIM ID by NANDO ID

## parameters
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

SELECT ?nando ?mondo ?mondo_id ?mondo_label_ja ?mondo_label_en ?exactMatch_disease ?property
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" .

  OPTIONAL {
    ?nando skos:exactMatch | skos:closeMatch ?mondo ;
           ?property ?mondo .
    ?mondo oboInOwl:id ?mondo_id ;
           skos:exactMatch ?exactMatch_disease .

    # 日本語ラベルの取得
    OPTIONAL {
      ?nando skos:closeMatch | skos:exactMatch ?mondo .
      ?mondo rdfs:label ?mondo_label_ja .
      FILTER (lang(?mondo_label_ja) = "ja")
    }

    # 英語ラベルの取得、または言語タグがない場合
    OPTIONAL {
      ?nando skos:closeMatch | skos:exactMatch ?mondo .
      ?mondo rdfs:label ?mondo_label_en .
      FILTER (lang(?mondo_label_en) = "en" || lang(?mondo_label_en) = "")
    }

    FILTER (CONTAINS(STR(?exactMatch_disease), "omim"))

    BIND (IRI(REPLACE(STR(?exactMatch_disease), "http://identifiers.org/omim/", "http://identifiers.org/mim/")) AS ?disease)
  }
}




```
## Output

```javascript

({ result }) => {
  let tree = [];

  if (result && result.results && result.results.bindings) {
    result.results.bindings.forEach(d => {
      let originalDisease = d.exactMatch_disease ? d.exactMatch_disease.value : null;
      let modifiedDisease = originalDisease;

      if (modifiedDisease) {
        if (modifiedDisease.includes("https://omim.org/entry/")) {
          modifiedDisease = modifiedDisease.replace("https://omim.org/entry/", "OMIM:");
        } else if (modifiedDisease.includes("https://omim.org/phenotypicSeries/")) {
          modifiedDisease = modifiedDisease.replace("https://omim.org/phenotypicSeries/PS", "OMIMPS:");
        }
      }

      let nando = d.nando ? d.nando.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:") : null;
      let mondo_id = d.mondo_id ? d.mondo_id.value : null;

      // nando, mondo_id, originalDisease のすべてが存在する場合のみJSONを生成
      if (nando && mondo_id && originalDisease) {
        let nandoNode = {
          id: nando, // 親ノード (nando)
          uid: d.nando ? d.nando.value : null,
          type: 'parent', // 親ノードであることを示す
        };

        // 重複チェック: `id` と `uid` の組み合わせが既に存在するか
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
          mondo_label_ja: d.mondo_label_ja ? d.mondo_label_ja.value : null,
          mondo_label_en: d.mondo_label_en ? d.mondo_label_en.value : null,
          mondo_url: mondo_id.replace("MONDO:", "https://monarchinitiative.org/MONDO:"),
        };

        // 子ノードの重複チェック: `parent` と `id` の組み合わせが既に存在するか
        let isMondoNodeExists = tree.some(
          node => node.parent === mondoNode.parent && node.id === mondoNode.id
        );

        // 重複がない場合のみ追加
        if (!isMondoNodeExists) {
          tree.push(mondoNode);
        }

        let originalDiseaseNode = {
          id: modifiedDisease,
          displayid: modifiedDisease,
          mondolink: d.mondo ? d.mondo.value : null,
          parent: mondo_id,
          property: d.property ? d.property.value : null,
          mondo_label_ja2: d.mondo_label_ja ? d.mondo_label_ja.value : null,
          mondo_label_en2: d.mondo_label_en ? d.mondo_label_en.value : null,
          original_disease: originalDisease,
        };

        // 原疾患ノードの重複チェック: `id` と `parent` の組み合わせが既に存在するか
        let isOriginalDiseaseNodeExists = tree.some(
          node => node.id === originalDiseaseNode.id && node.parent === originalDiseaseNode.parent
        );

        // 重複がない場合のみ追加
        if (!isOriginalDiseaseNodeExists) {
          tree.push(originalDiseaseNode);
        }
      }
    });
  }

  return tree;
};



```
## Description
- NanbyoDataでMONDOIDを経由してOMIMIDを表示させるためのSPARQListです。2024/11/19 高月
# Get sub-class by NANDO ID
## Parameters
* `nando_id` NANDO ID
  * default: 1200725
  * examples: 1200005
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

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
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:{{nando_id}}" ;
         rdfs:label ?nando_label.
  FILTER(lang(?nando_label) = "ja") 

  OPTIONAL {
    ?nando rdfs:label ?nando_englabel.
    FILTER(lang(?nando_englabel) = "en")
  }

  ?nando_sub rdfs:subClassOf* ?nando;
             dcterms:identifier ?id;
             rdfs:label ?nando_sub_label;
             rdfs:subClassOf ?parent.
  FILTER(lang(?nando_sub_label) = "ja") 

  OPTIONAL {
    ?nando_sub rdfs:label ?nando_sub_englabel.
    FILTER(lang(?nando_sub_englabel) = "en")
  }
}
ORDER BY ?nando_id


```
## Output

```javascript

({ result }) => {
  let tree = [];
  let uniqueIds = new Set();
  let addedSubIds = new Set();
  let nandoSubSet = new Set();
  let nandoIdSet = new Set(); // ?nando の ID を追跡

  // result.results.bindings の存在を確認
  if (result && result.results && result.results.bindings) {
    // nando_sub の値を収集
    result.results.bindings.forEach(d => {
      const nandoSubId = d.nando_sub.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:");
      nandoSubSet.add(nandoSubId);
    });

    // 1. ?parentが ?nando と一致する場合を優先して追加
    result.results.bindings.forEach(d => {
      const nandoEngLabel = d.nando_englabel ? d.nando_englabel.value : "";
      const nandoSubEngLabel = d.nando_sub_englabel ? d.nando_sub_englabel.value : "";

      const nandoId = d.id.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:");
      const parentId = d.parent.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:");
      const nandoSubId = d.nando_sub.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:");

      // ?nando をセットに追加
      nandoIdSet.add(nandoId);

      // ?nando と ?nando_sub が同じ場合
      if (d.nando.value === d.nando_sub.value) {
        if (!uniqueIds.has(nandoId)) {
          tree.push({
            id: nandoId,
            idurl: d.nando.value,
            label: d.nando_label.value,
            engLabel: nandoEngLabel,
            // parentフィールドを入れない
          });
          uniqueIds.add(nandoId);
        }
      } else {
        // ?nando と parent が一致し、?nando_sub の値がまだ追加されていない場合のみ追加
        if (d.nando.value === d.parent.value && !addedSubIds.has(nandoSubId)) {
          tree.push({
            id: nandoSubId,
            idurl: d.nando_sub.value,
            label: d.nando_sub_label.value,
            engLabel: nandoSubEngLabel,
            parent: parentId,
            uparent: d.parent.value,
          });
          addedSubIds.add(nandoSubId);
        }
      }
    });

    // 2. 重複しない ?nando_sub のみを追加（?nando と ?parent が一致しない場合）
    result.results.bindings.forEach(d => {
      const nandoSubEngLabel = d.nando_sub_englabel ? d.nando_sub_englabel.value : "";
      const nandoSubId = d.nando_sub.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:");
      const parentId = d.parent.value.replace("http://nanbyodata.jp/ontology/NANDO_", "NANDO:");

      // 重複がない ?nando_sub のみ追加
      if (!addedSubIds.has(nandoSubId)) {
        tree.push({
          id: nandoSubId,
          idurl: d.nando_sub.value,
          label: d.nando_sub_label.value,
          engLabel: nandoSubEngLabel,
          parent: parentId,
          uparent: d.parent.value,
        });
        addedSubIds.add(nandoSubId);
      }
    });

    // 3. 重複する ?nando の id がある場合、parent がないものを優先して残す
    let finalTree = [];
    let nandoIdCount = {};

    // 各 id の出現回数を確認
    tree.forEach(node => {
      nandoIdCount[node.id] = (nandoIdCount[node.id] || 0) + 1;
    });

    // 重複する場合、parent がないものを優先
    tree.forEach(node => {
      if (nandoIdCount[node.id] > 1) {
        if (node.parent === undefined) { // parent フィールドがないものを優先
          finalTree.push(node);
        }
      } else {
        finalTree.push(node);
      }
    });

    // 4. 最後に parent の値が他のレコードの id にない場合を削除（?nando と ?nando_sub が同じ場合を除く）
    const ids = new Set(finalTree.map(node => node.id)); // 現在のすべての id をセットにする
    finalTree = finalTree.filter(node => {
      if (node.parent === undefined || node.id === node.parent) {
        // parent がない場合、または ?nando と ?nando_sub が同じ場合は残す
        return true;
      }
      // parent が id に存在する場合のみ残す
      return ids.has(node.parent);
    });

    console.log("最終ツリー:", finalTree);
    return finalTree;
  }
};

```
## Description
- NanbyoDataで下位疾患を表示させるためのSPARQListです。2024/11/19 高月
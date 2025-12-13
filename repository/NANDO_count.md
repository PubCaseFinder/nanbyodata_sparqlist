# NANDO_count

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result1` 指定難病疾患数カウント
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?s)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?s ?p ?o.
FILTER (CONTAINS(STR(?s), "NANDO_1"))
}

```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result2` 小児慢性疾患数カウント
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?s)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?s ?p ?o.
FILTER (CONTAINS(STR(?s), "NANDO_2"))
}

```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result3` 小児慢性疾患グループカウント
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?s)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?s ?p ?o.
FILTER (CONTAINS(STR(?s), "NANDO_21"))
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result4` 指定難病疾患グループカウント
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?s)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?s ?p ?o.
FILTER (CONTAINS(STR(?s), "NANDO_11"))
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result5` 指定難病疾患カウント
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?s)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?s ?p ?o.
FILTER (CONTAINS(STR(?s), "NANDO_12"))
?s rdfs:subClassOf ?g.
FILTER (CONTAINS(STR(?g), "NANDO_11"))
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result6` 小児慢性疾患カウント
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?s)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?s ?p ?o.
FILTER (CONTAINS(STR(?s), "NANDO_22"))
?s rdfs:subClassOf ?g.
FILTER (CONTAINS(STR(?g), "NANDO_21"))
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result7` 小児慢性疾患サブクラスカウント
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?s)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?s ?p ?o.
FILTER (CONTAINS(STR(?s), "NANDO_22"))
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result8` 指定難病サブクラスカウント
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?s)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?s ?p ?o.
FILTER (CONTAINS(STR(?s), "NANDO_12"))
}


```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result9` 指定難病の最大値を計算する
```sparql
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX medgen: <http://med2rdf/ontology/medgen#>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX nando: <http://nanbyodata.jp/ontology/>

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX nando: <http://nanbyodata.jp/ontology/>

SELECT ?child ?grandchild (COUNT(?descendant) AS ?numDescendants)
WHERE {
  ?child rdfs:subClassOf nando:NANDO_1000001 .
  ?grandchild rdfs:subClassOf ?child .
  
  # ?descendant は ?grandchild のすべての子孫を取得
  OPTIONAL {
    ?descendant rdfs:subClassOf+ ?grandchild .
  }
}
GROUP BY ?child ?grandchild
ORDER BY ?child DESC(?numDescendants)

```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result10` 小児慢性の最大値を計算する
```sparql
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX medgen: <http://med2rdf/ontology/medgen#>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX nando: <http://nanbyodata.jp/ontology/>


SELECT ?greatGrandchild (COUNT(?descendant) AS ?numDescendants)
WHERE {
  ?child rdfs:subClassOf nando:NANDO_2000001 .
  ?grandchild rdfs:subClassOf ?child .
  ?greatGrandchild rdfs:subClassOf ?grandchild .

  # ?descendant は ?greatGrandchild のすべての子孫を取得
  OPTIONAL {
    ?descendant rdfs:subClassOf+ ?greatGrandchild .
  }
}
GROUP BY ?greatGrandchild
ORDER BY DESC(?numDescendants)

```

## Output
```javascript
({
  result1, result2, result3, result4, result5,
  result6, result7, result8, result9, result10
}) => {
  const namedResults = {
    shitei_all:      result1,
    shoman_all:      result2,
    shoman_group:    result3,
    shitei_group:    result4,
    shitei_disease:  result5,
    shoman_disease:  result6,
    name7:           result7,
    name8:           result8,
    name9:           result9,   // ★ result9
    name10:          result10,  // ★ result10
  };

  const processed = {};

  for (const [name, result] of Object.entries(namedResults)) {
    const bindings = result.results.bindings;

    if (!bindings || bindings.length === 0) {
      // 結果が無い場合は null を入れておく（必要に応じて変更）
      processed[name] = null;
      continue;
    }

    // まず使う行（row）を決める
    let row;

    // ★ name9 / name10 だけは numDescendants 最大の行を選ぶ
    if (name === 'name9' || name === 'name10') {
      row = bindings.reduce((maxRow, curRow) => {
        const cur = Number(curRow.numDescendants?.value ?? -Infinity);
        const max = Number(maxRow.numDescendants?.value ?? -Infinity);
        return cur > max ? curRow : maxRow;
      }, bindings[0]);
    } else {
      // それ以外は従来通り、先頭の1件
      row = bindings[0];
    }

    // 選んだ row から .value だけを取り出す
    processed[name] = Object.keys(row).reduce((obj, key) => {
      obj[key] = row[key].value;
      return obj;
    }, {});
  }

  return processed;
}


```
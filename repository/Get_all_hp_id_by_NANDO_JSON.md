# Get all HP by NANDO - HPにアップロードする表現型のファイルを作成する（JASON）

## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `nando2mondo2hp` get mondo_id correspoinding to nando_id

```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT ?nando_id ?hpo_id
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/hp>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier ?nando_id .
  OPTIONAL {
    {
      ?nando skos:closeMatch | skos:exactMatch ?mondo .
    }
    ?mondo oboInOwl:id ?mondo_id
  }
  
  ?an rdf:type oa:Annotation ;
      oa:hasTarget [rdfs:seeAlso ?mondo] ;
      oa:hasBody ?hpo_url ;
      dcterms:source [dcterms:creator ?creator] .
  FILTER(?creator NOT IN("Database Center for Life Science"))

  ?hpo_url oboInOwl:id ?hpo_id.
}

```
## Output

```javascript

({ nando2mondo2hp }) => {
  let tree = [];
  nando2mondo2hp.results.bindings.forEach(d => {
    // 安全に値をチェック
    const nandoID = d.nando_id?.value || null;
    const hpoID = d.hpo_id?.value || null;

    tree.push({
      nando_id: nandoID,
      hpo_id: hpoID
    });
  });
  return tree;
};


```

```
## Description
- NanbyoDataで症状を表示させるためのSPARQListです。
- NANDOからMONDOへ変更し、MONDOからHPOのIDを取得しています。
- 編集：高月（2024/01/12)
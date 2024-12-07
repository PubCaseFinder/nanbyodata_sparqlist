# Get phenotype data

## Endpoint

https://dev-pubcasefinder.dbcls.jp/sparql/

## `nando2mondo` get mondo_id correspoinding to nando_id

```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT ?nand ?nandoid ?mondo ?mondo_id
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier ?nandoid .
  OPTIONAL {
    {
      ?nando skos:closeMatch ?mondo .
    }
    UNION
    {
      ?nando skos:exactMatch ?mondo .
    }
    ?mondo oboInOwl:id ?mondo_id
  }
   }
```

## `mondo_uri_list` get mondo uri

```javascript
({
  json({nando2mondo}) {
    let rows = nando2mondo.results.bindings;
    let mondo_uris = [];
    
    for (let i = 0; i < rows.length; i++) {
      if (rows[i].mondo_id) {
        mondo_uris.push((rows[i].mondo_id.value).replace('MONDO:', 'MONDO_'));
      } else {
        mondo_uris.push("NA");
      }
    }
    //return mondo_uris[0]
    return "obo:" + mondo_uris.join(' obo:')
  }
})

```


## Endpoint

https://dev-pubcasefinder.dbcls.jp/sparql/

## `phenotype` retrieve phenotypes associated with the mondo uri

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX mim: <http://identifiers.org/mim/>
PREFIX oa: <http://www.w3.org/ns/oa#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX dcterms: <http://purl.org/dc/terms/>

SELECT DISTINCT
?hpo_id
?hpo_url
?hpo_label_en
?hpo_label_ja
WHERE { 
  {{#if mondo_uri_list}}
	VALUES ?mondo_uri { {{mondo_uri_list}} }
  {{/if}}
    
  ?an rdf:type oa:Annotation ;
      oa:hasTarget [rdfs:seeAlso ?mondo_uri] ;
      oa:hasBody ?hpo_url ;
      dcterms:source [dcterms:creator ?creator] .
  FILTER(?creator NOT IN("Database Center for Life Science"))
    
  GRAPH <https://pubcasefinder.dbcls.jp/rdf/ontology/hp>{
    optional { ?hpo_category rdfs:subClassOf obo:HP_0000118 . }
    ?hpo_url rdfs:label ?hpo_label_en .
    ?hpo_url <http://www.geneontology.org/formats/oboInOwl#id> ?hpo_id .
    ?hpo_url obo:IAO_0000115 ?definition .
  }  
 optional { ?hpo_url rdfs:label ?hpo_label_ja . FILTER (lang(?hpo_label_ja) = "ja") }    
}

```
## Output

```javascript

({ phenotype }) => {
  let tree = [];

  phenotype.results.bindings.forEach(d => {
    const hpo_id = d.hpo_id && d.hpo_id.value;
    const hpo_label_en = d.hpo_label_en && d.hpo_label_en.value;

    // hpo_id が存在する場合のみ処理
    if (hpo_id) {
      tree.push({
        hpo_id: hpo_id,
        hpo_label_en: hpo_label_en || "Unknown Label" // デフォルト値設定
      });
    }
  });
  return tree;
};


```
## Description
- NanbyoDataで症状を表示させるためのSPARQListです。
- NANDOからMONDOへ変更し、MONDOからHPOのIDを取得しています。
- 編集：高月（2024/01/12)
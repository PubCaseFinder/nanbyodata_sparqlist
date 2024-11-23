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
function processResults(nando2mondo, phenotype) {
  // 入力データの検証
  if (!Array.isArray(nando2mondo) || !Array.isArray(phenotype)) {
    throw new Error("Invalid input: `nando2mondo` and `phenotype` must be arrays.");
  }

  const nandoToMondoMap = {};

  // `nando2mondo` から nando_id と mondo_id を対応付け
  nando2mondo.forEach(row => {
    if (row && row.nandoid && row.nandoid.value) {
      const nando_id = row.nandoid.value;
      const mondo_id = row.mondo_id ? row.mondo_id.value.replace("MONDO:", "MONDO_") : null;

      if (!nandoToMondoMap[nando_id]) {
        nandoToMondoMap[nando_id] = {
          nando_id,
          mondo_id,
          hpo_ids: []
        };
      }
    }
  });

  // `phenotype` から hpo_id を対応付け
  phenotype.forEach(row => {
    if (row && row.mondo_uri && row.mondo_uri.value && row.hpo_id && row.hpo_id.value) {
      const mondo_uri = row.mondo_uri.value.replace("obo:", "MONDO_");
      const hpo_id = row.hpo_id.value;

      Object.values(nandoToMondoMap || {}).forEach(entry => {
        if (entry.mondo_id === mondo_uri) {
          entry.hpo_ids.push(hpo_id);
        }
      });
    }
  });

  // 結果を JSON 形式に整形
  const result = Object.values(nandoToMondoMap || {}).map(entry => ({
    nando_id: entry.nando_id,
    hpo_ids: entry.hpo_ids.length > 0 ? entry.hpo_ids : ["NA"]
  }));

  return result;
}




```
## Description
- NanbyoDataで症状を表示させるためのSPARQListです。
- NANDOからMONDOへ変更し、MONDOからHPOのIDを取得しています。
- 編集：高月（2024/01/12)
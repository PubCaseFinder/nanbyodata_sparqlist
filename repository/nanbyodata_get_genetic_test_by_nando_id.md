# Get genetic test data

## Parameters

* `nando_id` NANDO ID
  * default: 1200489 
  * example: 2200856

## Endpoint

https://nanbyodata.jp/sparql

## `result` 
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX genetest: <http://nanbyodata.jp/ontology/genetest_>

SELECT DISTINCT
?hp ?label ?gene ?facility
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?s  foaf:homepage ?hp.
  OPTIONAL{?s  rdfs:label    ?label.}
  OPTIONAL{?s  genetest:has_test ?gene.}
  OPTIONAL{?s  genetest:has_inspectionFacility ?facility.}
  ?s rdfs:seeAlso ?disease.
  FILTER (CONTAINS(STR(?disease), "{{nando_id}}"))
}

```

## Output
```javascript
({result})=>{ 
  return result.results.bindings.map(data => {
    return Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  });
}
```
## Description
- 2025/05/13 名称変更
- nanbyodata_get_gene_test => nanbyodata_get_genetic_test_by_nando_id
- NANDOで遺伝子の各種検査を表示させているSPARQListです。
- RDFのデータは高月の方で作成し、PubcaseFinderのエンドポイントにデータはあります。
- 編集：高月(2024/01/12)

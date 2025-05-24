# Get PMID(MedGen) by NANDO ID
## Parameters
* `nando_id` NANDO ID
  * default: 2200317

## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `nando2medgen2pmid`
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX mo: <http://med2rdf/ontology/medgen#>
PREFIX nci: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX dct: <http://purl.org/dc/terms/>

SELECT DISTINCT ?nando ?mondo ?mondo_id ?property ?medgen ?concept ?concept_id ?concept_name ?mondo_label_en ?mondo_label_ja ?converted
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/medgen>
WHERE {
  ?nando a owl:Class ;
         dcterms:identifier "NANDO:2200317" .
  
  OPTIONAL {
    ?nando skos:exactMatch | skos:closeMatch ?mondo ;
      ?property ?mondo .
    ?mondo oboInOwl:id ?mondo_id .
  }

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

  ?mgconso rdfs:seeAlso ?mondo ;
           dct:source mo:MONDO .
  ?concept a mo:ConceptID ;
           mo:mgconso ?mgconso ;
           rdfs:label ?concept_name ;
           dct:identifier ?concept_id .
  ?medgen rdfs:seeAlso ?concept ;
          dct:references ?pmid.
  
  FILTER STRSTARTS(STR(?pmid), "http://identifiers.org/pubmed/")
  BIND(IRI(REPLACE(STR(?pmid), "^http://identifiers.org/pubmed/", "http://rdf.ncbi.nlm.nih.gov/pubmed/")) AS ?converted)

}

```
## `pmid`
 ```javascript
({nando2medgen2pmid}) => {
  return nando2medgen2pmid.results.bindings.map(b => b.converted.value);
}

```
## Endpoint
https://rdfportal.org/ncbi/sparql

## `pmid_data`
```sparql

PREFIX dct: <http://purl.org/dc/terms/>
PREFIX prism:<http://prismstandard.org/namespeces/1.2/basic/>

SELECT DISTINCT ?id ?title ?name ?date 

WHERE{
  VALUES ?pmid { {{#each pmid}} <{{this}}> {{/each}} } 
    
  GRAPH <http://rdfportal.org/dataset/pubmed> {
    ?pmid dct:identifier ?id;
          dct:title ?title;
          prism:publicationName ?name;
          dct:issued ?date. }
    }




```
## Description
- 2025/05/15 新規設定　NANDO-MONDO-MedGenからMeGenの文献情報を引っ張ってくる　高月
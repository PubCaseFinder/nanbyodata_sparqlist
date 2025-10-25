# Get PMID(MedGen) by NANDO ID

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

SELECT (COUNT(DISTINCT ?nando) as ?NANDO) (COUNT(DISTINCT ?pmid) as ?PMID)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/medgen>
WHERE {
  ?nando skos:exactMatch | skos:closeMatch ?mondo.
    FILTER (CONTAINS(STR(?nando), "http://nanbyodata.jp/ontology/NANDO_1"))
  ?mgconso rdfs:seeAlso ?mondo ;
           dct:source mo:MONDO .
  ?concept a mo:ConceptID.
          # mo:mgconso ?mgconso ;
          # rdfs:label ?concept_name ;
          # dct:identifier ?concept_id .
  ?medgen rdfs:seeAlso ?concept ;
          dct:references ?pmid.
    FILTER STRSTARTS(STR(?pmid), "http://identifiers.org/pubmed/")
}

```
## Description
- 2025/10/24 APIの名前を設定　高月
- 2025/05/15 新規設定　NANDO-MONDO-MedGenからMeGenの文献情報を引っ張ってくる　高月
# NANDO_link_count

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shoman mondo exact count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub) count(distinct ?o) as ?mondo
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  ?sub rdfs:subClassOf+ nando:2000001 .
  ?sub skos:exactMatch ?o.
  FILTER (CONTAINS(STR(?o), "MONDO"))
}

```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shitei mondo exact count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub) count(distinct ?o) as ?mondo
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  ?sub rdfs:subClassOf+ nando:1000001 .
  ?sub skos:exactMatch ?o.
  FILTER (CONTAINS(STR(?o), "MONDO"))
}

```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shoman mondo close count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub) count(distinct ?o) as ?mondo
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  ?sub rdfs:subClassOf+ nando:2000001 .
  ?sub skos:closeMatch ?o.
  FILTER (CONTAINS(STR(?o), "MONDO"))
}

```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shitei mondo close count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub)  count(distinct ?o) as ?mondo
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  ?sub rdfs:subClassOf+ nando:1000001 .
  ?sub skos:closeMatch ?o.
  FILTER (CONTAINS(STR(?o), "MONDO"))
}

```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shitei kegg count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub) count(distinct ?o) as ?kegg
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  ?sub rdfs:subClassOf+ nando:1000001 .
  ?sub oboInOwl:hasDbXref ?o.
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shoman kegg count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub) as ?nando count(distinct ?o) as ?kegg
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  ?sub rdfs:subClassOf+ nando:2000001 .
  ?sub oboInOwl:hasDbXref ?o.
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shoman omim count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub)as ?nando count(distinct ?mondo) as ?mondo
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
WHERE {
       ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
       FILTER (CONTAINS(STR(?mondo), "MONDO"))
    
       ?mondo oboInOwl:id ?mondo_id ;
           skos:exactMatch ?exactMatch_disease .
    FILTER (CONTAINS(STR(?exactMatch_disease), "omim"))
   }
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shitei omim count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub)as ?nando count(distinct ?mondo) as ?mondo
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
WHERE {
       ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
       FILTER (CONTAINS(STR(?mondo), "MONDO"))
    
       ?mondo oboInOwl:id ?mondo_id ;
           skos:exactMatch ?exactMatch_disease .
    FILTER (CONTAINS(STR(?exactMatch_disease), "omim"))
   }
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shoman medgen count
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

SELECT DISTINCT count(distinct ?sub)as ?nando count(distinct ?medgen) as ?medgen
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/medgen>
WHERE {
  ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
       FILTER (CONTAINS(STR(?mondo), "MONDO"))

  ?mgconso rdfs:seeAlso ?mondo ;
           dct:source mo:MONDO .
  ?concept a mo:ConceptID ;
           mo:mgconso ?mgconso.
  ?medgen rdfs:seeAlso ?concept .        
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shitei medgen count
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

SELECT DISTINCT count(distinct ?sub)as ?nando count(distinct ?medgen) as ?medgen
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/medgen>
WHERE {
  ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
       FILTER (CONTAINS(STR(?mondo), "MONDO"))

  ?mgconso rdfs:seeAlso ?mondo ;
           dct:source mo:MONDO .
  ?concept a mo:ConceptID ;
           mo:mgconso ?mgconso.
  ?medgen rdfs:seeAlso ?concept .        
}
```
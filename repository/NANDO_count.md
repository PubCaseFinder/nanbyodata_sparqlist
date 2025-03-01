# NANDO_count

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## shitei count
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

## shoman count
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

## shoman group count
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

## shitei group count
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

## shitei group count subclass
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

## shoman group count subclass
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

## shoman subclass count
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

## shitei subclass count
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

## shitei description count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?sub rdfs:subClassOf+ nando:1000001 .
?sub dcterms:description ?desc .
}

```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## syoman description count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>

SELECT count(distinct ?sub)
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
?sub rdfs:subClassOf+ nando:2000001 .
?sub dcterms:description ?desc .
}
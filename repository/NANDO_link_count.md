# NANDO_link_count

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result1` shoman mondo exact count
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

## `result2` shitei mondo exact count
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

## `result3` shoman mondo close count
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

## `result4` shitei mondo close count
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

## `result5` shitei kegg count
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

## `result6` shoman kegg count
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

## `result7`shoman omim count
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

## `result8` shitei omim count
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

## `result9` shoman medgen count
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

## `result10` shitei medgen count
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
## `result11` shoman ordo count
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
    FILTER (CONTAINS(STR(?exactMatch_disease), "Orphanet"))
   }
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result12` shitei ordo count
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
    FILTER (CONTAINS(STR(?exactMatch_disease), "Orphanet"))
   }
```
## Output
```javascript
({result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12}) => {
  const namedResults = {
    name1: result1,
    name2: result2,
    name3: result3,
    name4: result4,
    name5: result5,
    name6: result6,
    name7: result7,
    name8: result8,
    name9: result9,
    name10: result10,
    name11: result11,
    name12: result12,
  };

  const processed = {};

  for (const [name, result] of Object.entries(namedResults)) {
    const data = result.results.bindings[0];
    processed[name] = Object.keys(data).reduce((obj, key) => {
      obj[key] = data[key].value;
      return obj;
    }, {});
  }

  return processed;
}

```
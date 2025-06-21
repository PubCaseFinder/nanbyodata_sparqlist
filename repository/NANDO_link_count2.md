# NANDO_link_count_2

## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result1` shoman mgend count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX mo: <http://med2rdf/ontology/medgen#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#> 
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
PREFIX mgendo: <http://med2rdf.org/mgend/ontology#> 
PREFIX m2r: <http://med2rdf.org/ontology/med2rdf#>

SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?variantID) as ?mgend 
FROM <https://nanbyodata.jp/rdf/mgend>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    OPTIONAL {
       ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
  }
  GRAPH <https://nanbyodata.jp/rdf/ontology/mondo> {
    ?mondo rdfs:label ?mondolabel; 
    oboInOwl:hasDbXref ?dbxref.
    FILTER (lang(?mondolabel) = "") 
    FILTER contains(?dbxref,'OMIMPS')
    BIND(REPLACE(?dbxref,'OMIMPS:','https://omim.org/phenotypicSeries/PS') AS ?omimps)
    BIND(IRI(?omimps)AS ?omimuri)
  }
   GRAPH <https://nanbyodata.jp/rdf/mgend> {
    ?mgendcase rdfs:seeAlso ?omimuri.
    ?mgendcase mgendo:case_significance ?significance;
               mgendo:variant_type ?type;
               mgendo:variant ?variantID.
    ?variantID rdf:type ?vtype;
               skos:note ?hgvs;
               faldo:location ?blank1.
    FILTER CONTAINS(?hgvs,":c.")
    ?blank1 faldo:position ?position;
               faldo:reference ?ch.
    ?variantID m2r:gene ?mgendogeneID.
    ?mgendogeneID rdfs:label ?genelabel;
                  rdfs:seeAlso ?geneXref.              
  }
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result2` shitei mgend count
```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX mo: <http://med2rdf/ontology/medgen#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#> 
PREFIX faldo: <http://biohackathon.org/resource/faldo#>
PREFIX mgendo: <http://med2rdf.org/mgend/ontology#> 
PREFIX m2r: <http://med2rdf.org/ontology/med2rdf#>

SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?variantID) as ?mgend 
FROM <https://nanbyodata.jp/rdf/mgend>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/nando>
WHERE {
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    OPTIONAL {
       ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
  }
  GRAPH <https://nanbyodata.jp/rdf/ontology/mondo> {
    ?mondo rdfs:label ?mondolabel; 
    oboInOwl:hasDbXref ?dbxref.
    FILTER (lang(?mondolabel) = "") 
    FILTER contains(?dbxref,'OMIMPS')
    BIND(REPLACE(?dbxref,'OMIMPS:','https://omim.org/phenotypicSeries/PS') AS ?omimps)
    BIND(IRI(?omimps)AS ?omimuri)
  }
   GRAPH <https://nanbyodata.jp/rdf/mgend> {
    ?mgendcase rdfs:seeAlso ?omimuri.
    ?mgendcase mgendo:case_significance ?significance;
               mgendo:variant_type ?type;
               mgendo:variant ?variantID.
    ?variantID rdf:type ?vtype;
               skos:note ?hgvs;
               faldo:location ?blank1.
    FILTER CONTAINS(?hgvs,":c.")
    ?blank1 faldo:position ?position;
               faldo:reference ?ch.
    ?variantID m2r:gene ?mgendogeneID.
    ?mgendogeneID rdfs:label ?genelabel;
                  rdfs:seeAlso ?geneXref.              
  }
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result3` shoman gene count
```sparql
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?hgnc_gene_symbol) as ?gene 
 FROM <https://nanbyodata.jp/rdf/ontology/nando>
 FROM <https://nanbyodata.jp/rdf/ontology/mondo>
 FROM <https://nanbyodata.jp/rdf/pcf>

WHERE {
      OPTIONAL {
       ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
      ?mondo  skos:exactMatch ?exactMatch_disease .
     FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
     BIND (IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease) .
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result4` shite gene count
```sparql
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?hgnc_gene_symbol) as ?gene 
 FROM <https://nanbyodata.jp/rdf/ontology/nando>
 FROM <https://nanbyodata.jp/rdf/ontology/mondo>
 FROM <https://nanbyodata.jp/rdf/pcf>

WHERE {
      OPTIONAL {
       ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
      ?mondo  skos:exactMatch ?exactMatch_disease .
     FILTER(CONTAINS(STR(?exactMatch_disease), "omim") || CONTAINS(STR(?exactMatch_disease), "Orphanet"))
     BIND (IRI(replace(STR(?exactMatch_disease), 'https://omim.org/entry/', 'http://identifiers.org/mim/')) AS ?disease) .
  ?as sio:SIO_000628 ?disease ;
      sio:SIO_000628 ?gene_id .
  ?disease rdf:type ncit:C7057 .
  ?gene_id sio:SIO_000205 [rdfs:label ?hgnc_gene_symbol] .
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result5` shoman hp count
```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX oa: <http://www.w3.org/ns/oa#>


SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?hpo_id) as ?hp
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/hp>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
 OPTIONAL {
       ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }  
  ?an rdf:type oa:Annotation ;
      oa:hasTarget [rdfs:seeAlso ?mondo] ;
      oa:hasBody ?hpo_url ;
      dcterms:source [dcterms:creator ?creator] .
  FILTER(?creator NOT IN("Database Center for Life Science"))

  ?hpo_url oboInOwl:id ?hpo_id.
}
```
## Endpoint
https://dev-nanbyodata.dbcls.jp/sparql

## `result6` shitei hp count
```sparql
PREFIX : <http://nanbyodata.jp/ontology/nando#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX oa: <http://www.w3.org/ns/oa#>


SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?hpo_id) as ?hp
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/ontology/hp>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE {
 OPTIONAL {
       ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }  
  ?an rdf:type oa:Annotation ;
      oa:hasTarget [rdfs:seeAlso ?mondo] ;
      oa:hasBody ?hpo_url ;
      dcterms:source [dcterms:creator ?creator] .
  FILTER(?creator NOT IN("Database Center for Life Science"))

  ?hpo_url oboInOwl:id ?hpo_id.
}
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result7` shoman cell count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>


SELECT DISTINCT count(distinct ?ontology) as ?nando count(distinct  ?id) as ?cell 
FROM <http://metadb.riken.jp/db/xsearch_cell_brso>
WHERE {
  ?cell dct:identifier ?id;
    brso:donor ?donor.
    BIND (STR(?id) as ?id_plain)
 ?donor obo:RO_0000091 ?disease. # <http://purl.obolibrary.org/obo/RO_0000091>
  OPTIONAL {?disease rdfs:seeAlso ?ontology}
  FILTER (CONTAINS(STR(?ontology), "http://nanbyodata.jp/ontology/NANDO_2"))
}
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result8` shitei cell count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>


SELECT DISTINCT count(distinct ?ontology) as ?nando count(distinct  ?id) as ?cell 
FROM <http://metadb.riken.jp/db/xsearch_cell_brso>
WHERE {
  ?cell dct:identifier ?id;
    brso:donor ?donor.
    BIND (STR(?id) as ?id_plain)
 ?donor obo:RO_0000091 ?disease. # <http://purl.obolibrary.org/obo/RO_0000091>
  OPTIONAL {?disease rdfs:seeAlso ?ontology}
  FILTER (CONTAINS(STR(?ontology), "http://nanbyodata.jp/ontology/NANDO_1"))
}
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result9` shoman gene count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?o) as ?nando count(distinct  ?id) as ?gene
WHERE {
    GRAPH <http://metadb.riken.jp/db/dna_diseaseID> {
    ?dna <http://purl.obolibrary.org/obo/RO_0003301> ?o.
      FILTER (CONTAINS(STR(?o), "http://nanbyodata.jp/ontology/NANDO_2"))
        }
  GRAPH <http://metadb.riken.jp/db/xsearch_dnabank_brso> {
    ?dna dct:identifier ?id.       
        }
      }

```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result10` shitei gene count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?o) as ?nando count(distinct  ?id) as ?gene
WHERE {
    GRAPH <http://metadb.riken.jp/db/dna_diseaseID> {
    ?dna <http://purl.obolibrary.org/obo/RO_0003301> ?o.
      FILTER (CONTAINS(STR(?o), "http://nanbyodata.jp/ontology/NANDO_1"))
        }
  GRAPH <http://metadb.riken.jp/db/xsearch_dnabank_brso> {
    ?dna dct:identifier ?id.       
        }
      }
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result11` shoman mouse count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?o) as ?nando count(distinct  ?id) as ?mouse
WHERE {
    GRAPH <http://metadb.riken.jp/db/mouse_diseaseID> {
    ?dna <http://purl.obolibrary.org/obo/RO_0003301> ?o.
      FILTER (CONTAINS(STR(?o), "http://nanbyodata.jp/ontology/NANDO_2"))
          }
  GRAPH <http://metadb.riken.jp/db/xsearch_animal_brso> {
    ?dna dct:identifier ?id.       
          }
       }
```
## Endpoint
https://knowledge.brc.riken.jp/sparql

## `result12` shitei mouse count
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX brso: <http://purl.jp/bio/10/brso/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?o) as ?nando count(distinct  ?id) as ?mouse
WHERE {
    GRAPH <http://metadb.riken.jp/db/mouse_diseaseID> {
    ?dna <http://purl.obolibrary.org/obo/RO_0003301> ?o.
      FILTER (CONTAINS(STR(?o), "http://nanbyodata.jp/ontology/NANDO_1"))
          }
  GRAPH <http://metadb.riken.jp/db/xsearch_animal_brso> {
    ?dna dct:identifier ?id.       
          }
       }
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result13` shoman description

```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX mondo: <http://purl.obolibrary.org/obo/mondo#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?desc) as ?desc
FROM <https://nanbyodata.jp/rdf/ontology/nando>

WHERE {
 OPTIONAL {
       ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub dcterms:description ?desc.}
}
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result14` shitei description

```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX mondo: <http://purl.obolibrary.org/obo/mondo#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?desc) as ?desc
FROM <https://nanbyodata.jp/rdf/ontology/nando>

WHERE {
 OPTIONAL {
       ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub dcterms:description ?desc.}
}
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result15` shoman altlabel

```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX mondo: <http://purl.obolibrary.org/obo/mondo#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?altlabel) as ?alt
FROM <https://nanbyodata.jp/rdf/ontology/nando>

WHERE {
 OPTIONAL {
       ?sub rdfs:subClassOf+ nando:2000001 .
       ?sub skos:altLabel ?altlabel.}
}
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result16` shitei altlabel

```sparql
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX mondo: <http://purl.obolibrary.org/obo/mondo#>
PREFIX nando: <http://nanbyodata.jp/ontology/NANDO_>

SELECT DISTINCT count(distinct ?sub) as ?nando count(distinct  ?altlabel) as ?alt
FROM <https://nanbyodata.jp/rdf/ontology/nando>

WHERE {
 OPTIONAL {
       ?sub rdfs:subClassOf+ nando:1000001 .
       ?sub skos:altLabel ?altlabel.}
}
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result17` shoman inheritance
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX mondo: <http://purl.obolibrary.org/obo/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX nando: <http://nanbyodata.jp/ontology/nando#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?sub) as ?nando count(?inheritance) as ?inheritance
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE{
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    OPTIONAL {
       ?sub rdfs:subClassOf+ <http://nanbyodata.jp/ontology/NANDO_2000001> .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
  }

  ?disease rdfs:seeAlso ?mondo ;
           nando:hasInheritance ?inheritance .
  }
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result18` shitei inheritance
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX mondo: <http://purl.obolibrary.org/obo/>
PREFIX ncit: <http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX nando: <http://nanbyodata.jp/ontology/nando#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

SELECT DISTINCT count(distinct ?sub) as ?nando count(?inheritance) as ?inheritance
FROM <https://nanbyodata.jp/rdf/ontology/nando>
FROM <https://nanbyodata.jp/rdf/ontology/mondo>
FROM <https://nanbyodata.jp/rdf/pcf>
WHERE{
  GRAPH <https://nanbyodata.jp/rdf/ontology/nando> {
    OPTIONAL {
       ?sub rdfs:subClassOf+ <http://nanbyodata.jp/ontology/NANDO_1000001> .
       ?sub skos:exactMatch | skos:closeMatch ?mondo .
    }
  }

  ?disease rdfs:seeAlso ?mondo ;
           nando:hasInheritance ?inheritance .
  }
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result19` shoman genetest
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX genetest: <http://nanbyodata.jp/ontology/genetest_>

SELECT DISTINCT count(distinct ?disease) as ?nando count(distinct  ?s) as ?genetest
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?s  foaf:homepage ?hp.
  ?s rdfs:seeAlso ?disease.
  FILTER (CONTAINS(STR(?disease), "http://nanbyodata.jp/ontology/NANDO_2"))
}
```
## Endpoint

https://dev-nanbyodata.dbcls.jp/sparql

## `result20` shitei genetest
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dct:  <http://purl.org/dc/terms/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX genetest: <http://nanbyodata.jp/ontology/genetest_>

SELECT DISTINCT count(distinct ?disease) as ?nando count(distinct  ?s) as ?genetest
FROM <https://nanbyodata.jp/rdf/nanbyodata>
WHERE {
  ?s  foaf:homepage ?hp.
  ?s rdfs:seeAlso ?disease.
  FILTER (CONTAINS(STR(?disease), "http://nanbyodata.jp/ontology/NANDO_1"))
}
```
## Output
```javascript
({result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12, result13, result14, result15, result16, result17, result18, result19, result20}) => {
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
    name13: result13,
    name14: result14,
    name15: result15,
    name16: result16,
    name17: result17,
    name18: result18,
    name19: result19,
    name20: result20
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
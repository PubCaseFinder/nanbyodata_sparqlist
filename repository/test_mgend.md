 
## Endpoint
https://dev-pubcasefinder.dbcls.jp/sparql/

## `nando2mondo2mgend`
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

SELECT DISTINCT COUNT(?mgendogeneID)
 WHERE{
  GRAPH <https://pubcasefinder.dbcls.jp/rdf/ontology/nando>{ 
       ?nando skos:closeMatch ?mondo .
    }
  GRAPH <https://pubcasefinder.dbcls.jp/rdf/ontology/mondo>{ 
    ?mondo rdfs:label ?mondolabel; 
    oboInOwl:hasDbXref ?dbxref.
    FILTER contains(?dbxref,'OMIMPS')
    BIND(REPLACE(?dbxref,'OMIMPS:','https://omim.org/phenotypicSeries/PS') AS ?omimps)
    BIND(IRI(?omimps)AS ?omimuri)}
   GRAPH <https://pubcasefinder.dbcls.jp/rdf/mgend>{
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
    }}
```